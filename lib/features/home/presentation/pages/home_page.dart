import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon_2025_app/features/home/data/repositories/koemyaku_repository.dart';
import 'package:hackathon_2025_app/features/home/domain/providers/koemyaku_list_provider.dart';
import 'package:hackathon_2025_app/features/home/presentation/widgets/koemyaku_list_item.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';
import 'package:hackathon_2025_app/features/map/presentation/pages/map_edit_page.dart';
import 'package:hackathon_2025_app/i18n/strings.g.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home';
  static const String name = 'home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    final koemyakuListAsync = ref.watch(koemyakuListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.home.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: koemyakuListAsync.when(
        skipLoadingOnRefresh: true,
        data: (koemyakuList) {
          if (koemyakuList.isEmpty) {
            return _buildEmptyState(context, t, colorScheme);
          }

          return ListView.builder(
            padding: EdgeInsets.only(top: 8.h, bottom: 100.h),
            itemCount: koemyakuList.length,
            itemBuilder: (context, index) {
              final koemyaku = koemyakuList[index];
              return KoemyakuListItem(
                koemyaku: koemyaku,
                onTap: () => _onKoemyakuTap(koemyaku),
                onDelete: () => _onDelete(koemyaku),
                onEdit: () => _onEdit(koemyaku),
                onPlay: () => _onPlay(koemyaku),
                onShare: () => _onShare(koemyaku),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          // デバッグ用にエラーをログ出力
          debugPrint('Koemyaku list error: $error');
          return _buildErrorState(context, t, error);
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    Translations t,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 80.sp,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 24.h),
            Text(
              t.home.emptyTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              t.home.emptyMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Translations t, Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              t.home.errorLoading,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(koemyakuListStreamProvider);
              },
              child: Text(t.home.retry),
            ),
          ],
        ),
      ),
    );
  }

  void _onKoemyakuTap(KoemyakuData koemyaku) {
    // TODO: Implement tap action (e.g., navigate to detail page)
  }

  Future<void> _onDelete(KoemyakuData koemyaku) async {
    final t = Translations.of(context);
    try {
      final repository = ref.read(koemyakuRepositoryProvider);
      await repository.deleteKoemyaku(koemyaku.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.home.deleteSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.home.deleteError)),
        );
      }
    }
  }

  void _onEdit(KoemyakuData koemyaku) {
    context.push(MapEditPage.routeName, extra: koemyaku);
  }

  void _onPlay(KoemyakuData koemyaku) {
    // TODO: Implement play action
  }

  void _onShare(KoemyakuData koemyaku) {
    final t = Translations.of(context);
    final shareText = '${koemyaku.title}\n${koemyaku.message}';
    SharePlus.instance.share(ShareParams(text: shareText, subject: t.home.shareSubject));
  }
}
