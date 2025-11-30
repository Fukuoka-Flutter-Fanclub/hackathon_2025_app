import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Finder画面のイントロオーバーレイ
/// 最低3秒、最大でローディング完了まで表示される
class FinderIntroOverlay extends StatefulWidget {
  const FinderIntroOverlay({
    super.key,
    required this.title,
    required this.message,
    required this.isLoading,
    required this.onDismissed,
  });

  /// タイトル
  final String title;

  /// メッセージ
  final String message;

  /// ローディング中かどうか
  final bool isLoading;

  /// オーバーレイが消えた時のコールバック
  final VoidCallback onDismissed;

  @override
  State<FinderIntroOverlay> createState() => _FinderIntroOverlayState();
}

class _FinderIntroOverlayState extends State<FinderIntroOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blurAnimation;

  bool _minimumTimePassed = false;
  bool _shouldDismiss = false;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _blurAnimation = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isDismissed) {
        _isDismissed = true;
        widget.onDismissed();
      }
    });

    // 最低3秒待つ
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _minimumTimePassed = true;
        });
        _checkAndDismiss();
      }
    });
  }

  @override
  void didUpdateWidget(FinderIntroOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      _shouldDismiss = true;
      _checkAndDismiss();
    }
  }

  void _checkAndDismiss() {
    if (_minimumTimePassed && (_shouldDismiss || !widget.isLoading)) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        if (_isDismissed) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Material(
              color: Colors.transparent,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: theme.colorScheme.surface.withValues(alpha: 0.85),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // アイコン（波紋アニメーション付き）
                            _PulseIcon(
                              icon: Icons.explore,
                              color: theme.colorScheme.primary,
                            ),
                            SizedBox(height: 48.h),

                            // タイトル
                            Text(
                              widget.title,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),

                            // メッセージ
                            if (widget.message.isNotEmpty)
                              Text(
                                widget.message,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),

                            SizedBox(height: 64.h),

                            // ローディングインジケーター
                            _LoadingDots(color: theme.colorScheme.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 波紋アニメーション付きアイコン
class _PulseIcon extends StatefulWidget {
  const _PulseIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  State<_PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<_PulseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 波紋エフェクト
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 120.w * (1 + _pulseAnimation.value * 0.5),
                height: 120.w * (1 + _pulseAnimation.value * 0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        widget.color.withValues(alpha: 1 - _pulseAnimation.value),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          // アイコン背景
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.1),
            ),
            child: Icon(
              widget.icon,
              size: 48.sp,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// ローディングドットアニメーション
class _LoadingDots extends StatefulWidget {
  const _LoadingDots({required this.color});

  final Color color;

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value + delay) % 1.0;
            final scale = 0.5 + 0.5 * (1 - (2 * value - 1).abs());

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: scale),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
