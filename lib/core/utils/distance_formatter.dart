/// 距離をフォーマットするユーティリティ
class DistanceFormatter {
  DistanceFormatter._();

  /// メートル単位の距離を人間が読みやすい形式に変換
  /// 1km以上: "1.2 km"
  /// 1km未満: "350 m"
  static String format(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      if (km >= 10) {
        return '${km.toStringAsFixed(0)} km';
      }
      return '${km.toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  /// 距離を短い形式でフォーマット（UI用）
  /// 例: "1.2km", "350m"
  static String formatCompact(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      if (km >= 10) {
        return '${km.toStringAsFixed(0)}km';
      }
      return '${km.toStringAsFixed(1)}km';
    }
    return '${meters.toStringAsFixed(0)}m';
  }

  /// 距離の数値部分のみを取得
  static String formatValue(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      if (km >= 10) {
        return km.toStringAsFixed(0);
      }
      return km.toStringAsFixed(1);
    }
    return meters.toStringAsFixed(0);
  }

  /// 距離の単位部分のみを取得
  static String formatUnit(double meters) {
    if (meters >= 1000) {
      return 'km';
    }
    return 'm';
  }
}
