import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hackathon_2025_app/core/services/audio_playback_service.dart';
import 'package:hackathon_2025_app/core/services/web_compass_service.dart';
import 'package:hackathon_2025_app/features/finder/domain/providers/finder_web_provider.dart';
import 'package:hackathon_2025_app/features/finder/presentation/widgets/animated_compass_circle.dart';
import 'package:hackathon_2025_app/features/finder/presentation/widgets/compass_circle.dart';
import 'package:hackathon_2025_app/features/finder/presentation/widgets/distance_indicator.dart';
import 'package:hackathon_2025_app/features/map/presentation/widgets/current_location_marker.dart';
import 'package:hackathon_2025_app/i18n/strings.g.dart';
import 'package:latlong2/latlong.dart';

/// Web用 Finder ページ
class FinderWebPage extends ConsumerStatefulWidget {
  const FinderWebPage({super.key, required this.koemyakuId});

  final String koemyakuId;

  static const String routeName = '/finder-web';
  static const String name = 'finder-web';

  @override
  ConsumerState<FinderWebPage> createState() => _FinderWebPageState();
}

class _FinderWebPageState extends ConsumerState<FinderWebPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(finderWebNotifierProvider.notifier)
          .initializeWithId(widget.koemyakuId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final state = ref.watch(finderWebNotifierProvider);
    final audioService = ref.watch(audioPlaybackServiceProvider);

    ref.listen<FinderWebState>(finderWebNotifierProvider, (previous, next) {
      if (previous?.status != FinderWebStatus.completed &&
          next.status == FinderWebStatus.completed) {
        _showCompletionDialog(context, t);
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context, theme, state, t),
      body: SafeArea(child: _buildBody(context, state, audioService, t)),
      floatingActionButton:
          state.status == FinderWebStatus.navigating ||
              state.status == FinderWebStatus.arrived
          ? FloatingActionButton(
              onPressed: () => _showMapBottomSheet(context, state),
              child: const Icon(Icons.map),
            )
          : null,
    );
  }

  AppBar? _buildAppBar(
    BuildContext context,
    ThemeData theme,
    FinderWebState state,
    Translations t,
  ) {
    if (state.status == FinderWebStatus.loading ||
        state.status == FinderWebStatus.waitingPermission) {
      return null;
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _onClose(context),
      ),
      title: Text(
        state.koemyaku?.title ?? '',
        style: theme.textTheme.titleMedium,
      ),
      centerTitle: true,
      actions: [
        if (state.allMarkers.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Text(
                '${state.visitedMarkerIds.length}/${state.allMarkers.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    FinderWebState state,
    AudioPlaybackService audioService,
    Translations t,
  ) {
    switch (state.status) {
      case FinderWebStatus.loading:
        return _buildLoading(context, t);
      case FinderWebStatus.waitingPermission:
        return _buildPermissionRequest(context, state, t);
      case FinderWebStatus.initializing:
        return _buildInitializing(context, t);
      case FinderWebStatus.navigating:
        return _buildNavigating(context, state, t);
      case FinderWebStatus.arrived:
        return _buildArrived(context, state, audioService, t);
      case FinderWebStatus.completed:
        return _buildCompleted(context, t);
      case FinderWebStatus.error:
        return _buildError(context, state, t);
    }
  }

  Widget _buildLoading(BuildContext context, Translations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 24.h),
          Text(
            t.finderWeb.loading,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequest(
    BuildContext context,
    FinderWebState state,
    Translations t,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: 80.sp, color: theme.colorScheme.primary),
            SizedBox(height: 32.h),
            Text(
              t.finderWeb.permissionTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              t.finderWeb.permissionMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              t.finderWeb.permissionNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            FilledButton.icon(
              onPressed: () {
                ref
                    .read(finderWebNotifierProvider.notifier)
                    .requestCompassPermission();
              },
              icon: const Icon(Icons.check),
              label: Text(t.finderWeb.grantPermission),
            ),
            if (state.compassPermissionStatus ==
                WebCompassPermissionStatus.denied) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  t.finderWeb.permissionDeniedMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
    FinderWebState state,
    Translations t,
  ) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        Center(
          child: AnimatedCompassCircle(
            state: CompassCircleState.navigating,
            arrowAngle: state.relativeAngle,
            size: 250.w,
          ),
        ),
        SizedBox(height: 40.h),
        DistanceIndicator(distanceInMeters: state.distanceToTarget),
        SizedBox(height: 16.h),
        Text(
          t.finder.distanceAway,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 32.h),
          child: TextButton(
            onPressed: () {
              ref.read(finderWebNotifierProvider.notifier).skipCurrentMarker();
            },
            child: Text(t.finder.skip),
          ),
        ),
      ],
    );
  }

  Widget _buildArrived(
    BuildContext context,
    FinderWebState state,
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
        Padding(
          padding: EdgeInsets.only(bottom: 32.h),
          child: TextButton(
            onPressed: () {
              ref.read(finderWebNotifierProvider.notifier).skipCurrentMarker();
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

  Widget _buildError(
    BuildContext context,
    FinderWebState state,
    Translations t,
  ) {
    final theme = Theme.of(context);

    String errorTitle = t.finder.error;
    String errorMessage = state.errorMessage ?? '';

    if (state.errorMessage == 'Koemyaku not found') {
      errorTitle = t.finderWeb.notFound;
      errorMessage = '';
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(errorTitle, style: theme.textTheme.titleMedium),
            if (errorMessage.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                errorMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: () {
                ref
                    .read(finderWebNotifierProvider.notifier)
                    .initializeWithId(widget.koemyakuId);
              },
              child: Text(t.home.retry),
            ),
          ],
        ),
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
              Navigator.of(context).pop();
            },
            child: Text(t.finder.finish),
          ),
        ],
      ),
    );
  }

  void _onClose(BuildContext context) {
    ref.read(finderWebNotifierProvider.notifier).stopAndCleanup();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _showMapBottomSheet(BuildContext context, FinderWebState state) {
    final theme = Theme.of(context);

    LatLng center;
    if (state.currentLatitude != 0 && state.currentLongitude != 0) {
      center = LatLng(state.currentLatitude, state.currentLongitude);
    } else if (state.allMarkers.isNotEmpty) {
      center = state.allMarkers.first.latLng;
    } else {
      center = const LatLng(35.6812, 139.7671);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                      child: FlutterMap(
                        options: MapOptions(initialCenter: center, initialZoom: 15),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                            userAgentPackageName: 'com.example.hackathon_2025_app',
                          ),
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
        ),
      ),
    );
  }
}

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
