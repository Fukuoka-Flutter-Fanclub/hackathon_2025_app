import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// コンパスサークルの状態
enum CompassCircleState {
  /// 矢印表示（ナビゲーション中）
  navigating,

  /// 波形表示（再生中）
  playing,
}

/// コンパスサークルウィジェット
/// AirTagのような円形UIで、矢印または波形を表示
class CompassCircle extends StatelessWidget {
  const CompassCircle({
    super.key,
    required this.state,
    this.arrowAngle = 0,
    this.amplitudes = const [],
    this.playbackProgress = 0,
    this.size,
  });

  /// 現在の状態
  final CompassCircleState state;

  /// 矢印の角度（度数法、0が上、時計回りで増加）
  final double arrowAngle;

  /// 波形の振幅データ（0.0-1.0）
  final List<double> amplitudes;

  /// 再生の進捗（0.0-1.0）
  final double playbackProgress;

  /// サイズ（nullの場合はデフォルト）
  final double? size;

  @override
  Widget build(BuildContext context) {
    final circleSize = size ?? 250.w;

    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: CustomPaint(
        painter: _CompassCirclePainter(
          state: state,
          arrowAngle: arrowAngle,
          amplitudes: amplitudes,
          playbackProgress: playbackProgress,
          primaryColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}

class _CompassCirclePainter extends CustomPainter {
  _CompassCirclePainter({
    required this.state,
    required this.arrowAngle,
    required this.amplitudes,
    required this.playbackProgress,
    required this.primaryColor,
    required this.backgroundColor,
  });

  final CompassCircleState state;
  final double arrowAngle;
  final List<double> amplitudes;
  final double playbackProgress;
  final Color primaryColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 外側の円（縁）
    final outerCirclePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius - 2, outerCirclePaint);

    // 内側の背景円
    final innerCirclePaint = Paint()
      ..color = backgroundColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius - 6, innerCirclePaint);

    // 状態に応じて描画
    switch (state) {
      case CompassCircleState.navigating:
        _drawArrow(canvas, center, radius);
        break;
      case CompassCircleState.playing:
        _drawWaveform(canvas, center, radius);
        break;
    }
  }

  void _drawArrow(Canvas canvas, Offset center, double radius) {
    final arrowPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // 矢印のサイズ
    final arrowLength = radius * 0.6;
    final arrowWidth = radius * 0.3;

    // 角度をラジアンに変換（-90度は上向きを0度にするため）
    final angleRad = (arrowAngle - 90) * math.pi / 180;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angleRad);

    // 矢印の形状を描画
    final path = Path();
    path.moveTo(0, -arrowLength); // 先端
    path.lineTo(arrowWidth / 2, arrowLength * 0.3); // 右下
    path.lineTo(0, arrowLength * 0.1); // 中央くぼみ
    path.lineTo(-arrowWidth / 2, arrowLength * 0.3); // 左下
    path.close();

    canvas.drawPath(path, arrowPaint);

    // 矢印の影（立体感）
    final shadowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final shadowPath = Path();
    shadowPath.moveTo(0, -arrowLength);
    shadowPath.lineTo(arrowWidth / 4, arrowLength * 0.3);
    shadowPath.lineTo(0, arrowLength * 0.1);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);

    canvas.restore();
  }

  void _drawWaveform(Canvas canvas, Offset center, double radius) {
    if (amplitudes.isEmpty) return;

    final barCount = amplitudes.length.clamp(10, 30);
    final waveformWidth = radius * 1.4;
    final barWidth = waveformWidth / barCount * 0.6;
    final barSpacing = waveformWidth / barCount;
    final maxBarHeight = radius * 0.8;

    final startX = center.dx - waveformWidth / 2;

    for (var i = 0; i < barCount; i++) {
      final amplitudeIndex = (i * amplitudes.length / barCount).floor();
      final amplitude = amplitudes[amplitudeIndex.clamp(0, amplitudes.length - 1)];

      // 再生済みかどうかで色を変える
      final isPlayed = i / barCount <= playbackProgress;
      final barPaint = Paint()
        ..color = isPlayed
            ? primaryColor
            : primaryColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;

      final barHeight = (amplitude * maxBarHeight).clamp(4.0, maxBarHeight);
      final x = startX + i * barSpacing + barSpacing / 2;
      final topY = center.dy - barHeight / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 2, topY, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rect, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CompassCirclePainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.arrowAngle != arrowAngle ||
        oldDelegate.amplitudes != amplitudes ||
        oldDelegate.playbackProgress != playbackProgress;
  }
}
