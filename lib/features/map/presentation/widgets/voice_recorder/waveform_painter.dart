import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 録音時の波形表示用ペインター
class WaveformPainter extends CustomPainter {
  WaveformPainter({
    required this.amplitudes,
    required this.color,
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.minBarHeight = 4.0,
  });

  /// 振幅データのリスト（0.0〜1.0）
  final List<double> amplitudes;

  /// 波形の色
  final Color color;

  /// バーの幅
  final double barWidth;

  /// バー間のスペース
  final double barSpacing;

  /// バーの最小高さ
  final double minBarHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final maxHeight = size.height;
    final centerY = size.height / 2;
    final totalBarWidth = barWidth + barSpacing;
    final startX = size.width - (amplitudes.length * totalBarWidth);

    for (int i = 0; i < amplitudes.length; i++) {
      final amplitude = amplitudes[i].clamp(0.0, 1.0);
      final barHeight = math.max(
        minBarHeight,
        amplitude * (maxHeight - minBarHeight) + minBarHeight,
      );

      final x = startX + (i * totalBarWidth);
      if (x < 0) continue;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, centerY),
          width: barWidth,
          height: barHeight,
        ),
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return amplitudes != oldDelegate.amplitudes || color != oldDelegate.color;
  }
}

/// 再生時の波形表示用ペインター
class PlaybackWaveformPainter extends CustomPainter {
  PlaybackWaveformPainter({
    required this.amplitudes,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.minBarHeight = 4.0,
  });

  /// 振幅データのリスト（0.0〜1.0）
  final List<double> amplitudes;

  /// 再生進捗（0.0〜1.0）
  final double progress;

  /// 再生済み部分の色
  final Color activeColor;

  /// 未再生部分の色
  final Color inactiveColor;

  /// バーの幅
  final double barWidth;

  /// バー間のスペース
  final double barSpacing;

  /// バーの最小高さ
  final double minBarHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final maxHeight = size.height;
    final centerY = size.height / 2;
    final totalBarWidth = barWidth + barSpacing;
    final totalWidth = amplitudes.length * totalBarWidth;
    final startX = (size.width - totalWidth) / 2;
    final progressIndex = (amplitudes.length * progress).floor();

    for (int i = 0; i < amplitudes.length; i++) {
      final amplitude = amplitudes[i].clamp(0.0, 1.0);
      final barHeight = math.max(
        minBarHeight,
        amplitude * (maxHeight - minBarHeight) + minBarHeight,
      );

      final x = startX + (i * totalBarWidth);
      final paint = i <= progressIndex ? activePaint : inactivePaint;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, centerY),
          width: barWidth,
          height: barHeight,
        ),
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PlaybackWaveformPainter oldDelegate) {
    return amplitudes != oldDelegate.amplitudes ||
        progress != oldDelegate.progress ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor;
  }
}
