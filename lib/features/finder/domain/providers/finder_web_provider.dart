import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackathon_2025_app/core/services/audio_playback_service.dart';
import 'package:hackathon_2025_app/core/services/koemyaku_service.dart';
import 'package:hackathon_2025_app/core/services/location_service.dart';
import 'package:hackathon_2025_app/core/services/web_compass_service.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';
import 'package:hackathon_2025_app/features/map/data/models/marker/marker_data.dart';
import 'package:latlong2/latlong.dart';

/// Web用 Finder Notifier Provider
final finderWebNotifierProvider =
    StateNotifierProvider.autoDispose<FinderWebNotifier, FinderWebState>((ref) {
      return FinderWebNotifier(ref);
    });

/// Web用 Finder の状態
enum FinderWebStatus {
  /// 初期化中（データ読み込み中）
  loading,

  /// コンパス権限待ち
  waitingPermission,

  /// 初期化完了
  initializing,

  /// ナビゲーション中（目的地へ向かっている）
  navigating,

  /// 到着（音声再生中）
  arrived,

  /// 完了（すべてのマーカーを訪問済み）
  completed,

  /// エラー
  error,
}

/// Web用 Finder の状態クラス
class FinderWebState {
  const FinderWebState({
    this.status = FinderWebStatus.loading,
    this.koemyaku,
    this.allMarkers = const [],
    this.visitedMarkerIds = const {},
    this.currentTarget,
    this.distanceToTarget = 0,
    this.bearingToTarget = 0,
    this.userHeading = 0,
    this.currentLatitude = 0,
    this.currentLongitude = 0,
    this.errorMessage,
    this.compassPermissionStatus = WebCompassPermissionStatus.unknown,
  });

  final FinderWebStatus status;
  final KoemyakuData? koemyaku;
  final List<MarkerData> allMarkers;
  final Set<String> visitedMarkerIds;
  final MarkerData? currentTarget;
  final double distanceToTarget;
  final double bearingToTarget;
  final double userHeading;
  final double currentLatitude;
  final double currentLongitude;
  final String? errorMessage;
  final WebCompassPermissionStatus compassPermissionStatus;

  /// 相対角度（ユーザーが向いている方向を基準にした矢印の角度）
  double get relativeAngle {
    var angle = bearingToTarget - userHeading;
    while (angle < 0) {
      angle += 360;
    }
    while (angle >= 360) {
      angle -= 360;
    }
    return angle;
  }

  /// 残りのマーカー数
  int get remainingCount => allMarkers.length - visitedMarkerIds.length;

  /// 進捗（0.0-1.0）
  double get progress {
    if (allMarkers.isEmpty) return 0;
    return visitedMarkerIds.length / allMarkers.length;
  }

  /// 現在のターゲットのインデックス
  int get currentTargetIndex {
    if (currentTarget == null) return 0;
    return allMarkers.indexWhere((m) => m.id == currentTarget!.id);
  }

  FinderWebState copyWith({
    FinderWebStatus? status,
    KoemyakuData? koemyaku,
    List<MarkerData>? allMarkers,
    Set<String>? visitedMarkerIds,
    MarkerData? currentTarget,
    double? distanceToTarget,
    double? bearingToTarget,
    double? userHeading,
    double? currentLatitude,
    double? currentLongitude,
    String? errorMessage,
    WebCompassPermissionStatus? compassPermissionStatus,
  }) {
    return FinderWebState(
      status: status ?? this.status,
      koemyaku: koemyaku ?? this.koemyaku,
      allMarkers: allMarkers ?? this.allMarkers,
      visitedMarkerIds: visitedMarkerIds ?? this.visitedMarkerIds,
      currentTarget: currentTarget ?? this.currentTarget,
      distanceToTarget: distanceToTarget ?? this.distanceToTarget,
      bearingToTarget: bearingToTarget ?? this.bearingToTarget,
      userHeading: userHeading ?? this.userHeading,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      errorMessage: errorMessage ?? this.errorMessage,
      compassPermissionStatus:
          compassPermissionStatus ?? this.compassPermissionStatus,
    );
  }
}

/// Web用 Finder Notifier
class FinderWebNotifier extends StateNotifier<FinderWebState> {
  FinderWebNotifier(this._ref) : super(const FinderWebState());

  final Ref _ref;
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<double>? _compassSubscription;
  StreamSubscription<PlaybackState>? _playbackSubscription;

  final Distance _distanceCalculator = const Distance();

  /// KoemyakuのIDで初期化
  Future<void> initializeWithId(String koemyakuId) async {
    state = state.copyWith(status: FinderWebStatus.loading);

    try {
      // Firestoreからデータを取得
      final koemyakuService = _ref.read(koemyakuServiceProvider);
      final koemyaku = await koemyakuService.getKoemyakuById(koemyakuId);

      if (koemyaku == null) {
        state = state.copyWith(
          status: FinderWebStatus.error,
          errorMessage: 'Koemyaku not found',
        );
        return;
      }

      // 音声があるマーカーのみをフィルター
      final markersWithVoice = koemyaku.markers
          .where((m) => m.voicePath != null && m.voicePath!.isNotEmpty)
          .toList();

      if (markersWithVoice.isEmpty) {
        state = state.copyWith(
          status: FinderWebStatus.error,
          errorMessage: 'No voice markers found',
        );
        return;
      }

      state = state.copyWith(
        koemyaku: koemyaku,
        allMarkers: markersWithVoice,
        status: FinderWebStatus.waitingPermission,
      );

      // コンパスサービスを確認
      final compassService = _ref.read(webCompassServiceProvider);
      if (!compassService.isSupported) {
        // コンパス非対応でも位置情報のみで続行
        debugPrint('Compass not supported on this device');
      }
    } catch (e) {
      debugPrint('Finder web initialization error: $e');
      state = state.copyWith(
        status: FinderWebStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// コンパス権限をリクエスト（iOS Safari用、ユーザージェスチャーから呼び出す）
  Future<void> requestCompassPermission() async {
    final compassService = _ref.read(webCompassServiceProvider);
    final permissionStatus = await compassService.requestPermission();

    state = state.copyWith(compassPermissionStatus: permissionStatus);

    // 権限取得後、位置情報トラッキングを開始
    await _startTracking();
  }

  /// 位置情報とコンパスのトラッキングを開始
  Future<void> _startTracking() async {
    state = state.copyWith(status: FinderWebStatus.initializing);

    try {
      // Web用位置情報の権限チェック
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied ||
            requestedPermission == LocationPermission.deniedForever) {
          state = state.copyWith(
            status: FinderWebStatus.error,
            errorMessage: 'Location permission denied',
          );
          return;
        }
      }

      // 現在位置を取得
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _updatePosition(position);

      // ナビゲーション用位置情報ストリームを開始（ポーリング付き）
      final locationService = _ref.read(locationServiceProvider);
      _positionSubscription = locationService
          .getNavigationPositionStream(
            accuracy: LocationAccuracy.high,
            distanceFilter: 3,
            intervalMs: 2000, // 2秒間隔
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
      final compassService = _ref.read(webCompassServiceProvider);
      if (compassService.isSupported &&
          state.compassPermissionStatus == WebCompassPermissionStatus.granted) {
        _compassSubscription = compassService.getHeadingStream().listen(
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
    } catch (e) {
      debugPrint('Start tracking error: $e');
      state = state.copyWith(
        status: FinderWebStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void _updatePosition(Position position) {
    final currentLatLng = LatLng(position.latitude, position.longitude);

    state = state.copyWith(
      currentLatitude: position.latitude,
      currentLongitude: position.longitude,
    );

    // Web版では位置情報からのheadingも使用（コンパスが利用できない場合のフォールバック）
    if (state.compassPermissionStatus != WebCompassPermissionStatus.granted &&
        position.heading >= 0) {
      state = state.copyWith(userHeading: position.heading);
    }

    // 初期化中なら最初のターゲットを設定
    if (state.status == FinderWebStatus.initializing) {
      _findNearestMarker(currentLatLng);
      state = state.copyWith(status: FinderWebStatus.navigating);
    } else if (state.status == FinderWebStatus.navigating ||
        state.status == FinderWebStatus.arrived) {
      // navigating中またはarrived中も位置情報を更新
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
      state = state.copyWith(
        currentTarget: nearest,
        distanceToTarget: nearestDistance,
        bearingToTarget: bearing,
      );
    } else {
      // すべて訪問済み
      state = state.copyWith(status: FinderWebStatus.completed);
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

    debugPrint(
      'Navigation update: distance=${distance.toStringAsFixed(1)}m, radius=${target.radius}m, status=${state.status}',
    );

    state = state.copyWith(
      distanceToTarget: distance,
      bearingToTarget: bearing,
    );

    // 到着判定（navigating状態の場合のみ）
    if (state.status == FinderWebStatus.navigating &&
        distance <= target.radius) {
      debugPrint(
        'Triggering arrival: distance $distance <= radius ${target.radius}',
      );
      _onArrived();
    }
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180;
    final lat2 = to.latitude * math.pi / 180;
    final deltaLon = (to.longitude - from.longitude) * math.pi / 180;

    final y = math.sin(deltaLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

    var bearing = math.atan2(y, x) * 180 / math.pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  void _onArrived() {
    final target = state.currentTarget;
    if (target == null) return;

    debugPrint(
      'Arrived at marker: ${target.id}, voicePath: ${target.voicePath}',
    );

    state = state.copyWith(status: FinderWebStatus.arrived);

    // 音声を再生
    if (target.voicePath != null && target.voicePath!.isNotEmpty) {
      _playAudio(target.voicePath!);
    } else {
      debugPrint('No voice path for marker: ${target.id}');
      // 音声がない場合は少し待ってから次へ
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _onPlaybackComplete();
        }
      });
    }
  }

  Future<void> _playAudio(String path) async {
    debugPrint('Playing audio: $path');
    try {
      final audioService = _ref.read(audioPlaybackServiceProvider);
      final loaded = await audioService.loadAudio(path);
      if (!loaded) {
        debugPrint('Failed to load audio: $path');
        // ロード失敗時は少し待ってから次へ進む（ユーザーが到着を認識できるように）
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _onPlaybackComplete();
          }
        });
        return;
      }
      final played = await audioService.play();
      if (!played) {
        debugPrint('Failed to play audio: $path');
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _onPlaybackComplete();
          }
        });
      }
    } catch (e) {
      debugPrint('Audio playback error: $e');
      // エラー時も少し待ってから次へ
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _onPlaybackComplete();
        }
      });
    }
  }

  void _onPlaybackStateChanged(PlaybackState playbackState) {
    if (playbackState == PlaybackState.completed &&
        state.status == FinderWebStatus.arrived) {
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
    final currentPosition = LatLng(
      state.currentLatitude,
      state.currentLongitude,
    );
    _findNearestMarker(currentPosition);

    if (state.currentTarget != null &&
        !newVisitedIds.contains(state.currentTarget!.id)) {
      state = state.copyWith(status: FinderWebStatus.navigating);
    } else {
      state = state.copyWith(status: FinderWebStatus.completed);
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
    _ref.read(webCompassServiceProvider).dispose();
  }

  @override
  void dispose() {
    stopAndCleanup();
    super.dispose();
  }
}
