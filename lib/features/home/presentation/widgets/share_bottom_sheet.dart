import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:hackathon_2025_app/core/constants/env_constants.dart';
import 'package:hackathon_2025_app/features/finder/presentation/pages/finder_web_page.dart';
import 'package:hackathon_2025_app/i18n/strings.g.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({
    super.key,
    required this.koemyakuId,
    required this.title,
  });

  final String koemyakuId;
  final String title;

  static Future<void> show(
    BuildContext context, {
    required String koemyakuId,
    required String title,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareBottomSheet(
        koemyakuId: koemyakuId,
        title: title,
      ),
    );
  }

  String get _shareUrl {
    final baseUrl = EnvConstants().webBaseUrl;
    return '$baseUrl${FinderWebPage.routeName}/$koemyakuId';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ドラッグハンドル
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 24.h),

              // タイトル
              Text(
                t.share.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),

              // こえみゃく名
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 24.h),

              // QRコード
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 200.w,
                  height: 200.w,
                  child: PrettyQrView.data(
                    data: _shareUrl,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // URL表示
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _shareUrl,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 16.h),

              // コピーボタン
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _copyToClipboard(context),
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(t.share.copyLink),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // 閉じるボタン
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(t.share.close),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final t = Translations.of(context);
    Clipboard.setData(ClipboardData(text: _shareUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.share.linkCopied),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
