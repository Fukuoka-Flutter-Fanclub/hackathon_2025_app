import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'compass_circle.dart';

/// アニメーション付きコンパスサークル
class AnimatedCompassCircle extends StatefulWidget {
  const AnimatedCompassCircle({
    super.key,
    required this.state,
    this.arrowAngle = 0,
    this.amplitudes = const [],
    this.playbackProgress = 0,
    this.size,
  });

  final CompassCircleState state;
  final double arrowAngle;
  final List<double> amplitudes;
  final double playbackProgress;
  final double? size;

  @override
  State<AnimatedCompassCircle> createState() => _AnimatedCompassCircleState();
}

class _AnimatedCompassCircleState extends State<AnimatedCompassCircle>
    with TickerProviderStateMixin {
  late AnimationController _arrowController;
  late AnimationController _waveController;
  late Animation<double> _arrowAnimation;

  double _previousAngle = 0;
  List<double> _animatedAmplitudes = [];

  @override
  void initState() {
    super.initState();

    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..addListener(_updateWaveform);

    _arrowAnimation = Tween<double>(
      begin: widget.arrowAngle,
      end: widget.arrowAngle,
    ).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeOutCubic,
    ));

    _animatedAmplitudes = List.from(widget.amplitudes);
  }

  @override
  void didUpdateWidget(AnimatedCompassCircle oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 矢印アングルが変わった場合
    if (oldWidget.arrowAngle != widget.arrowAngle) {
      _previousAngle = _arrowAnimation.value;

      // 最短経路で回転
      var targetAngle = widget.arrowAngle;
      var diff = targetAngle - _previousAngle;
      if (diff > 180) {
        targetAngle -= 360;
      } else if (diff < -180) {
        targetAngle += 360;
      }

      _arrowAnimation = Tween<double>(
        begin: _previousAngle,
        end: targetAngle,
      ).animate(CurvedAnimation(
        parent: _arrowController,
        curve: Curves.easeOutCubic,
      ));

      _arrowController.forward(from: 0);
    }

    // 波形が変わった場合
    if (oldWidget.amplitudes != widget.amplitudes) {
      _waveController.forward(from: 0);
    }
  }

  void _updateWaveform() {
    if (widget.amplitudes.isEmpty) return;

    setState(() {
      if (_animatedAmplitudes.length != widget.amplitudes.length) {
        _animatedAmplitudes = List.from(widget.amplitudes);
      } else {
        for (var i = 0; i < widget.amplitudes.length; i++) {
          _animatedAmplitudes[i] = _animatedAmplitudes[i] +
              (_waveController.value *
                  (widget.amplitudes[i] - _animatedAmplitudes[i]));
        }
      }
    });
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_arrowController, _waveController]),
      builder: (context, child) {
        return CompassCircle(
          state: widget.state,
          arrowAngle: _arrowAnimation.value,
          amplitudes: widget.state == CompassCircleState.playing
              ? _animatedAmplitudes
              : widget.amplitudes,
          playbackProgress: widget.playbackProgress,
          size: widget.size,
        );
      },
    );
  }
}

/// 波形のパルスアニメーション付きコンパスサークル
class PulsingWaveformCircle extends StatefulWidget {
  const PulsingWaveformCircle({
    super.key,
    required this.amplitudes,
    this.playbackProgress = 0,
    this.size,
    this.isPlaying = true,
  });

  final List<double> amplitudes;
  final double playbackProgress;
  final double? size;
  final bool isPlaying;

  @override
  State<PulsingWaveformCircle> createState() => _PulsingWaveformCircleState();
}

class _PulsingWaveformCircleState extends State<PulsingWaveformCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    if (widget.isPlaying) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingWaveformCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isPlaying && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = widget.size ?? 250.w;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        // パルス効果で振幅を変化させる
        final pulseValue = 0.8 + (_pulseController.value * 0.4);
        final pulsedAmplitudes = widget.amplitudes.map((a) {
          return (a * pulseValue).clamp(0.0, 1.0);
        }).toList();

        return SizedBox(
          width: circleSize,
          height: circleSize,
          child: CustomPaint(
            painter: _WaveformCirclePainter(
              amplitudes: pulsedAmplitudes,
              playbackProgress: widget.playbackProgress,
              primaryColor: Theme.of(context).colorScheme.primary,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        );
      },
    );
  }
}

class _WaveformCirclePainter extends CustomPainter {
  _WaveformCirclePainter({
    required this.amplitudes,
    required this.playbackProgress,
    required this.primaryColor,
    required this.backgroundColor,
  });

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

    // 波形を描画
    _drawWaveform(canvas, center, radius);
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
      final amplitude =
          amplitudes[amplitudeIndex.clamp(0, amplitudes.length - 1)];

      // 再生済みかどうかで色を変える
      final isPlayed = i / barCount <= playbackProgress;
      final barPaint = Paint()
        ..color = isPlayed ? primaryColor : primaryColor.withValues(alpha: 0.3)
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
  bool shouldRepaint(covariant _WaveformCirclePainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes ||
        oldDelegate.playbackProgress != playbackProgress;
  }
}
