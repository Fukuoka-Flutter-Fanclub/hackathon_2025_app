import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackathon_2025_app/core/services/audio_playback_service.dart';
import 'package:hackathon_2025_app/core/services/location_service.dart';
import 'package:hackathon_2025_app/features/finder/domain/providers/finder_state.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';
import 'package:hackathon_2025_app/features/map/data/models/marker/marker_data.dart';
import 'package:latlong2/latlong.dart';

/// Finder Notifier Provider
final finderNotifierProvider =
    StateNotifierProvider.autoDispose<FinderNotifier, FinderState>((ref) {
  return FinderNotifier(ref);
});

/// Finder Notifier
class FinderNotifier extends StateNotifier<FinderState> {
  FinderNotifier(this._ref) : super(const FinderState());

  final Ref _ref;
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<double>? _compassSubscription;
  StreamSubscription<PlaybackState>? _playbackSubscription;

  final Distance _distanceCalculator = const Distance();

  /// Koemyakuデータで初期化
  Future<void> initialize(KoemyakuData koemyaku) async {
    try {
      // 音声があるマーカーのみをフィルター
      final markersWithVoice = koemyaku.markers
          .where((m) => m.voicePath != null && m.voicePath!.isNotEmpty)
          .toList();

      if (markersWithVoice.isEmpty) {
        state = state.copyWith(
          status: FinderStatus.error,
          errorMessage: 'No voice markers found',
        );
        return;
      }

      state = state.copyWith(
        allMarkers: markersWithVoice,
        status: FinderStatus.initializing,
      );

      // 位置情報サービスを開始
      await _startLocationTracking();
    } catch (e) {
      debugPrint('Finder initialization error: $e');
      state = state.copyWith(
        status: FinderStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _startLocationTracking() async {
    final locationService = _ref.read(locationServiceProvider);

    // 権限チェック
    final hasPermission = await locationService.ensureLocationPermission();
    if (!hasPermission) {
      state = state.copyWith(
        status: FinderStatus.error,
        errorMessage: 'Location permission denied',
      );
      return;
    }

    // 現在位置を取得
    final position = await locationService.getCurrentLocation();
    if (position != null) {
      _updatePosition(position);
    }

    // バックグラウンド位置情報の権限をリクエスト（オプション）
    await locationService.ensureBackgroundLocationPermission();

    // ナビゲーション用位置情報ストリームを開始（ポーリング付き、バックグラウンドモード有効）
    _positionSubscription = locationService
        .getNavigationPositionStream(
          distanceFilter: 3,
          intervalMs: 2000, // 2秒間隔
          enableBackgroundMode: true,
        )
        .listen(
      (position) {
        _updatePosition(position);
      },
      onError: (e) {
        debugPrint('Position stream error: $e');
      },
    );

    // コンパスストリームを開始
    final isCompassAvailable = await locationService.isCompassAvailable();
    if (isCompassAvailable) {
      _compassSubscription = locationService.getCompassStream().listen(
        (heading) {
          state = state.copyWith(userHeading: heading);
        },
        onError: (e) {
          debugPrint('Compass stream error: $e');
        },
      );
    }

    // 音声再生状態を監視
    _playbackSubscription = _ref
        .read(audioPlaybackServiceProvider)
        .stateStream
        .listen(_onPlaybackStateChanged);
  }

  void _updatePosition(Position position) {
    final currentLatLng = LatLng(position.latitude, position.longitude);

    state = state.copyWith(
      currentLatitude: position.latitude,
      currentLongitude: position.longitude,
      userHeading: position.heading,
    );

    // 初期化中なら最初のターゲットを設定
    if (state.status == FinderStatus.initializing) {
      _findNearestMarker(currentLatLng);
      state = state.copyWith(status: FinderStatus.navigating);
    } else if (state.status == FinderStatus.navigating) {
      _updateNavigationState(currentLatLng);
    }
  }

  void _findNearestMarker(LatLng currentPosition) {
    if (state.allMarkers.isEmpty) return;

    MarkerData? nearest;
    double nearestDistance = double.infinity;

    for (final marker in state.allMarkers) {
      if (state.visitedMarkerIds.contains(marker.id)) continue;

      final distance = _distanceCalculator.as(
        LengthUnit.Meter,
        currentPosition,
        marker.latLng,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = marker;
      }
    }

    if (nearest != null) {
      final bearing = _calculateBearing(currentPosition, nearest.latLng);
      // 表示用の距離はマーカー半径を考慮（ゾーン境界までの距離）
      final effectiveDistance = math.max(0.0, nearestDistance - nearest.radius);
      state = state.copyWith(
        currentTarget: nearest,
        distanceToTarget: effectiveDistance,
        bearingToTarget: bearing,
      );
    } else {
      // すべて訪問済み
      state = state.copyWith(status: FinderStatus.completed);
    }
  }

  void _updateNavigationState(LatLng currentPosition) {
    final target = state.currentTarget;
    if (target == null) return;

    final distance = _distanceCalculator.as(
      LengthUnit.Meter,
      currentPosition,
      target.latLng,
    );

    final bearing = _calculateBearing(currentPosition, target.latLng);

    // 表示用の距離はマーカー半径を考慮（ゾーン境界までの距離）
    final effectiveDistance = math.max(0.0, distance - target.radius);

    state = state.copyWith(
      distanceToTarget: effectiveDistance,
      bearingToTarget: bearing,
    );

    // 到着判定（中心からの距離が半径以内）
    if (distance <= target.radius) {
      _onArrived();
    }
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180;
    final lat2 = to.latitude * math.pi / 180;
    final deltaLon = (to.longitude - from.longitude) * math.pi / 180;

    final y = math.sin(deltaLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

    var bearing = math.atan2(y, x) * 180 / math.pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  void _onArrived() {
    final target = state.currentTarget;
    if (target == null) return;

    state = state.copyWith(status: FinderStatus.arrived);

    // 音声を再生
    if (target.voicePath != null) {
      _playAudio(target.voicePath!);
    }
  }

  Future<void> _playAudio(String path) async {
    try {
      final audioService = _ref.read(audioPlaybackServiceProvider);
      await audioService.loadAudio(path);
      await audioService.play();
    } catch (e) {
      debugPrint('Audio playback error: $e');
      // エラーでも次に進む
      _onPlaybackComplete();
    }
  }

  void _onPlaybackStateChanged(PlaybackState playbackState) {
    if (playbackState == PlaybackState.completed &&
        state.status == FinderStatus.arrived) {
      _onPlaybackComplete();
    }
  }

  void _onPlaybackComplete() {
    final target = state.currentTarget;
    if (target == null) return;

    // 訪問済みに追加
    final newVisitedIds = {...state.visitedMarkerIds, target.id};

    state = state.copyWith(visitedMarkerIds: newVisitedIds);

    // 次のマーカーを探す
    final currentPosition = LatLng(state.currentLatitude, state.currentLongitude);
    _findNearestMarker(currentPosition);

    if (state.currentTarget != null &&
        !newVisitedIds.contains(state.currentTarget!.id)) {
      state = state.copyWith(status: FinderStatus.navigating);
    } else {
      state = state.copyWith(status: FinderStatus.completed);
    }
  }

  /// 手動でスキップ
  void skipCurrentMarker() {
    _onPlaybackComplete();
  }

  /// 再生を停止してクリーンアップ
  void stopAndCleanup() {
    _positionSubscription?.cancel();
    _compassSubscription?.cancel();
    _playbackSubscription?.cancel();
    _ref.read(audioPlaybackServiceProvider).stop();
  }

  @override
  void dispose() {
    stopAndCleanup();
    super.dispose();
  }
}
