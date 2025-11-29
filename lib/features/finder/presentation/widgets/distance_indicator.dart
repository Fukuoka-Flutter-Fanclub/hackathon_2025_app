import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hackathon_2025_app/core/utils/distance_formatter.dart';

/// 距離表示ウィジェット
class DistanceIndicator extends StatelessWidget {
  const DistanceIndicator({
    super.key,
    required this.distanceInMeters,
  });

  /// 距離（メートル）
  final double distanceInMeters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = DistanceFormatter.formatValue(distanceInMeters);
    final unit = DistanceFormatter.formatUnit(distanceInMeters);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          unit,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// アニメーション付き距離表示
class AnimatedDistanceIndicator extends StatelessWidget {
  const AnimatedDistanceIndicator({
    super.key,
    required this.distanceInMeters,
    this.duration = const Duration(milliseconds: 300),
  });

  final double distanceInMeters;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: distanceInMeters, end: distanceInMeters),
      duration: duration,
      builder: (context, animatedValue, child) {
        final animatedValueStr = DistanceFormatter.formatValue(animatedValue);
        final animatedUnit = DistanceFormatter.formatUnit(animatedValue);

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              animatedValueStr,
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              animatedUnit,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );
      },
    );
  }
}
