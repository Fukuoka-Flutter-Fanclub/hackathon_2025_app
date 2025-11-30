import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hackathon_2025_app/core/services/audio_playback_service.dart';
import 'package:hackathon_2025_app/features/finder/domain/providers/finder_provider.dart';
import 'package:hackathon_2025_app/features/finder/domain/providers/finder_state.dart';
import 'package:hackathon_2025_app/features/finder/presentation/widgets/animated_compass_circle.dart';
import 'package:hackathon_2025_app/features/finder/presentation/widgets/compass_circle.dart';
import 'package:hackathon_2025_app/features/finder/presentation/widgets/distance_indicator.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';
import 'package:hackathon_2025_app/features/map/presentation/widgets/current_location_marker.dart';
import 'package:hackathon_2025_app/i18n/strings.g.dart';
import 'package:latlong2/latlong.dart';

class FinderPage extends ConsumerStatefulWidget {
  const FinderPage({super.key, required this.koemyaku});

  final KoemyakuData koemyaku;

  static const String routeName = '/finder';
  static const String name = 'finder';

  @override
  ConsumerState<FinderPage> createState() => _FinderPageState();
}

class _FinderPageState extends ConsumerState<FinderPage> {
  @override
  void initState() {
    super.initState();
    // 初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(finderNotifierProvider.notifier).initialize(widget.koemyaku);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final finderState = ref.watch(finderNotifierProvider);
    final audioService = ref.watch(audioPlaybackServiceProvider);

    // 完了時にダイアログを表示
    ref.listen<FinderState>(finderNotifierProvider, (previous, next) {
      if (previous?.status != FinderStatus.completed &&
          next.status == FinderStatus.completed) {
        _showCompletionDialog(context, t);
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _onClose(context),
        ),
        title: Text(widget.koemyaku.title, style: theme.textTheme.titleMedium),
        centerTitle: true,
        actions: [
          // 進捗表示
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Text(
                '${finderState.visitedMarkerIds.length}/${finderState.allMarkers.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, finderState, audioService, t)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMapBottomSheet(context, finderState),
        child: const Icon(Icons.map),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    FinderState state,
    AudioPlaybackService audioService,
    Translations t,
  ) {
    switch (state.status) {
      case FinderStatus.initializing:
        return _buildInitializing(context, t);
      case FinderStatus.navigating:
        return _buildNavigating(context, state, t);
      case FinderStatus.arrived:
        return _buildArrived(context, state, audioService, t);
      case FinderStatus.completed:
        return _buildCompleted(context, t);
      case FinderStatus.error:
        return _buildError(context, state, t);
    }
  }

  Widget _buildInitializing(BuildContext context, Translations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 24.h),
          Text(
            t.finder.initializing,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigating(
    BuildContext context,
    FinderState state,
    Translations t,
  ) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ターゲット情報
        if (state.currentTarget != null)
          Text(
            t.finder.findingVoice(
              index: state.currentTargetIndex + 1,
              total: state.allMarkers.length,
            ),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

        SizedBox(height: 40.h),

        // コンパスサークル（矢印）
        Center(
          child: AnimatedCompassCircle(
            state: CompassCircleState.navigating,
            arrowAngle: state.relativeAngle,
            size: 250.w,
          ),
        ),

        SizedBox(height: 40.h),

        // 距離表示
        DistanceIndicator(distanceInMeters: state.distanceToTarget),

        SizedBox(height: 16.h),

        Text(
          t.finder.distanceAway,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),

        const Spacer(),

        // スキップボタン
        Padding(
          padding: EdgeInsets.only(bottom: 32.h),
          child: TextButton(
            onPressed: () {
              ref.read(finderNotifierProvider.notifier).skipCurrentMarker();
            },
            child: Text(t.finder.skip),
          ),
        ),
      ],
    );
  }

  Widget _buildArrived(
    BuildContext context,
    FinderState state,
    AudioPlaybackService audioService,
    Translations t,
  ) {
    final theme = Theme.of(context);
    final target = state.currentTarget;
    final amplitudes = target?.amplitudes ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t.finder.arrived,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),

        SizedBox(height: 40.h),

        // 波形サークル
        Center(
          child: StreamBuilder<Duration>(
            stream: audioService.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = audioService.totalDuration;
              final progress = duration.inMilliseconds > 0
                  ? position.inMilliseconds / duration.inMilliseconds
                  : 0.0;

              return PulsingWaveformCircle(
                amplitudes: amplitudes.isNotEmpty
                    ? amplitudes
                    : List.generate(20, (i) => 0.3 + (i % 5) * 0.1),
                playbackProgress: progress,
                size: 250.w,
                isPlaying: audioService.currentState == PlaybackState.playing,
              );
            },
          ),
        ),

        SizedBox(height: 40.h),

        // 再生時間表示
        StreamBuilder<Duration>(
          stream: audioService.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            final duration = audioService.totalDuration;
            return Text(
              '${AudioPlaybackService.formatDuration(position)} / ${AudioPlaybackService.formatDuration(duration)}',
              style: theme.textTheme.bodyLarge,
            );
          },
        ),

        const Spacer(),

        // スキップボタン
        Padding(
          padding: EdgeInsets.only(bottom: 32.h),
          child: TextButton(
            onPressed: () {
              ref.read(finderNotifierProvider.notifier).skipCurrentMarker();
            },
            child: Text(t.finder.skipToNext),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleted(BuildContext context, Translations t) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 100.sp,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 24.h),
          Text(
            t.finder.allCompleted,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            t.finder.allCompletedMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, FinderState state, Translations t) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: theme.colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(t.finder.error, style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          Text(
            state.errorMessage ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.finder.close),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, Translations t) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(t.finder.completedTitle),
        content: Text(t.finder.completedMessage),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // ダイアログを閉じる
              Navigator.of(context).pop(); // Finderページを閉じる
            },
            child: Text(t.finder.finish),
          ),
        ],
      ),
    );
  }

  void _onClose(BuildContext context) {
    ref.read(finderNotifierProvider.notifier).stopAndCleanup();
    Navigator.of(context).pop();
  }

  void _showMapBottomSheet(BuildContext context, FinderState initialState) {
    final theme = Theme.of(context);

    // 初期中心位置を計算
    LatLng initialCenter;
    if (initialState.currentLatitude != 0 && initialState.currentLongitude != 0) {
      initialCenter = LatLng(initialState.currentLatitude, initialState.currentLongitude);
    } else if (initialState.allMarkers.isNotEmpty) {
      initialCenter = initialState.allMarkers.first.latLng;
    } else {
      initialCenter = const LatLng(35.6812, 139.7671); // 東京駅
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(finderNotifierProvider);

            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // ハンドル
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      // マップ
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                          child: FlutterMap(
                            options: MapOptions(initialCenter: initialCenter, initialZoom: 15),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                                userAgentPackageName: 'com.example.hackathon_2025_app',
                              ),
                              // 現在地マーカー
                              if (state.currentLatitude != 0 &&
                                  state.currentLongitude != 0)
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(
                                        state.currentLatitude,
                                        state.currentLongitude,
                                      ),
                                      width: 60,
                                      height: 60,
                                      child: CurrentLocationMarker(
                                        heading: state.userHeading,
                                      ),
                                    ),
                                  ],
                                ),
                              // 音声マーカー
                              MarkerLayer(
                                markers: state.allMarkers.map((marker) {
                                  final isVisited = state.visitedMarkerIds.contains(
                                    marker.id,
                                  );
                                  final isTarget = state.currentTarget?.id == marker.id;
                                  return Marker(
                                    point: marker.latLng,
                                    width: 40,
                                    height: 40,
                                    child: _VoiceMarkerIcon(
                                      isVisited: isVisited,
                                      isTarget: isTarget,
                                    ),
                                  );
                                }).toList(),
                              ),
                              // Attribution
                              RichAttributionWidget(
                                attributions: [
                                  TextSourceAttribution(
                                    'OpenStreetMap contributors',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 右上の閉じるボタン
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Material(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.close,
                            size: 24.sp,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 音声マーカーのアイコン
class _VoiceMarkerIcon extends StatelessWidget {
  const _VoiceMarkerIcon({required this.isVisited, required this.isTarget});

  final bool isVisited;
  final bool isTarget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color iconColor;
    double size;

    if (isTarget) {
      backgroundColor = theme.colorScheme.primary;
      iconColor = theme.colorScheme.onPrimary;
      size = 40;
    } else if (isVisited) {
      backgroundColor = theme.colorScheme.surfaceContainerHighest;
      iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
      size = 32;
    } else {
      backgroundColor = theme.colorScheme.primaryContainer;
      iconColor = theme.colorScheme.onPrimaryContainer;
      size = 36;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isVisited ? Icons.check : Icons.mic,
        color: iconColor,
        size: size * 0.5,
      ),
    );
  }
}
