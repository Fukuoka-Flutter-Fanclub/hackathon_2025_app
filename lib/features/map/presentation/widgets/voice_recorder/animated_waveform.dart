import 'package:flutter/material.dart';

/// スムーズなアニメーション付き波形ウィジェット（録音用）
class AnimatedWaveform extends StatelessWidget {
  const AnimatedWaveform({
    super.key,
    required this.amplitudes,
    required this.color,
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.minBarHeight = 4.0,
    this.maxBars = 60,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  final List<double> amplitudes;
  final Color color;
  final double barWidth;
  final double barSpacing;
  final double minBarHeight;
  final int maxBars;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalBarWidth = barWidth + barSpacing;
        final visibleBars = (constraints.maxWidth / totalBarWidth).floor();
        final barsToShow = amplitudes.length > visibleBars
            ? amplitudes.sublist(amplitudes.length - visibleBars)
            : amplitudes;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(barsToShow.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: barSpacing),
              child: _AnimatedBar(
                amplitude: barsToShow[index],
                color: color,
                width: barWidth,
                minHeight: minBarHeight,
                maxHeight: constraints.maxHeight,
                duration: animationDuration,
              ),
            );
          }),
        );
      },
    );
  }
}

/// 個別のアニメーションバー
class _AnimatedBar extends StatelessWidget {
  const _AnimatedBar({
    required this.amplitude,
    required this.color,
    required this.width,
    required this.minHeight,
    required this.maxHeight,
    required this.duration,
  });

  final double amplitude;
  final Color color;
  final double width;
  final double minHeight;
  final double maxHeight;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final targetHeight =
        (amplitude.clamp(0.0, 1.0) * (maxHeight - minHeight) + minHeight);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: minHeight, end: targetHeight),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, height, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(width / 2),
          ),
        );
      },
    );
  }
}

/// スムーズなアニメーション付き波形ウィジェット（再生用）
class AnimatedPlaybackWaveform extends StatelessWidget {
  const AnimatedPlaybackWaveform({
    super.key,
    required this.amplitudes,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.minBarHeight = 4.0,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  final List<double> amplitudes;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final double barWidth;
  final double barSpacing;
  final double minBarHeight;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    if (amplitudes.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalBarWidth = barWidth + barSpacing;
        final maxBars = (constraints.maxWidth / totalBarWidth).floor();

        // 表示するバーの数を制限し、均等にサンプリング
        final List<double> displayAmplitudes;
        if (amplitudes.length <= maxBars) {
          displayAmplitudes = amplitudes;
        } else {
          // 振幅データをダウンサンプリング
          displayAmplitudes = List.generate(maxBars, (i) {
            final sourceIndex = (i * amplitudes.length / maxBars).floor();
            return amplitudes[sourceIndex.clamp(0, amplitudes.length - 1)];
          });
        }

        final progressIndex = (displayAmplitudes.length * progress).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(displayAmplitudes.length, (index) {
            final isActive = index <= progressIndex;
            return Padding(
              padding: EdgeInsets.only(
                right: index < displayAmplitudes.length - 1 ? barSpacing : 0,
              ),
              child: _PlaybackBar(
                amplitude: displayAmplitudes[index],
                isActive: isActive,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                width: barWidth,
                minHeight: minBarHeight,
                maxHeight: constraints.maxHeight,
                duration: animationDuration,
              ),
            );
          }),
        );
      },
    );
  }
}

/// 再生用の個別バー（色のアニメーション付き）
class _PlaybackBar extends StatelessWidget {
  const _PlaybackBar({
    required this.amplitude,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.width,
    required this.minHeight,
    required this.maxHeight,
    required this.duration,
  });

  final double amplitude;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final double minHeight;
  final double maxHeight;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final height =
        (amplitude.clamp(0.0, 1.0) * (maxHeight - minHeight) + minHeight);

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: inactiveColor,
        end: isActive ? activeColor : inactiveColor,
      ),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, color, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(width / 2),
          ),
        );
      },
    );
  }
}

/// リアルタイム波形（録音中）用のより滑らかなバージョン
class SmoothWaveformBar extends StatefulWidget {
  const SmoothWaveformBar({
    super.key,
    required this.amplitude,
    required this.color,
    required this.width,
    required this.maxHeight,
    this.minHeight = 4.0,
  });

  final double amplitude;
  final Color color;
  final double width;
  final double maxHeight;
  final double minHeight;

  @override
  State<SmoothWaveformBar> createState() => _SmoothWaveformBarState();
}

class _SmoothWaveformBarState extends State<SmoothWaveformBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  double _currentHeight = 4.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(SmoothWaveformBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amplitude != widget.amplitude) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    final targetHeight = (widget.amplitude.clamp(0.0, 1.0) *
            (widget.maxHeight - widget.minHeight) +
        widget.minHeight);

    _heightAnimation = Tween<double>(
      begin: _currentHeight,
      end: targetHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward(from: 0).then((_) {
      _currentHeight = targetHeight;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: _heightAnimation.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.width / 2),
          ),
        );
      },
    );
  }
}
