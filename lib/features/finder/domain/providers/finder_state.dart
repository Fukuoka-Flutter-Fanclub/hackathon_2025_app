import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hackathon_2025_app/features/map/data/models/marker/marker_data.dart';

part 'finder_state.freezed.dart';

/// Finderの状態
enum FinderStatus {
  /// 初期化中
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

@freezed
abstract class FinderState with _$FinderState {
  const factory FinderState({
    /// 現在のステータス
    @Default(FinderStatus.initializing) FinderStatus status,

    /// 全マーカーリスト
    @Default([]) List<MarkerData> allMarkers,

    /// 訪問済みマーカーのID
    @Default({}) Set<String> visitedMarkerIds,

    /// 現在のターゲットマーカー
    MarkerData? currentTarget,

    /// 現在地からターゲットまでの距離（メートル）
    @Default(0) double distanceToTarget,

    /// 現在地からターゲットへの方角（度数法、北が0度）
    @Default(0) double bearingToTarget,

    /// ユーザーが向いている方角（コンパス）
    @Default(0) double userHeading,

    /// 現在の緯度
    @Default(0) double currentLatitude,

    /// 現在の経度
    @Default(0) double currentLongitude,

    /// エラーメッセージ
    String? errorMessage,
  }) = _FinderState;

  const FinderState._();

  /// 相対角度（ユーザーが向いている方向を基準にした矢印の角度）
  double get relativeAngle {
    var angle = bearingToTarget - userHeading;
    // 0-360の範囲に正規化
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
}
