import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';
import 'package:hackathon_2025_app/i18n/strings.g.dart';
import 'package:intl/intl.dart';

class KoemyakuListItem extends StatelessWidget {
  const KoemyakuListItem({
    super.key,
    required this.koemyaku,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.onPlay,
    required this.onShare,
  });

  final KoemyakuData koemyaku;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onPlay;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    return Dismissible(
      key: Key(koemyaku.id),
      background: _buildSwipeBackground(
        alignment: Alignment.centerLeft,
        color: colorScheme.primary,
        icon: Icons.edit,
      ),
      secondaryBackground: _buildSwipeBackground(
        alignment: Alignment.centerRight,
        color: colorScheme.error,
        icon: Icons.delete,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // 右から左へスワイプ: 削除確認
          return await _showDeleteConfirmDialog(context, t);
        } else if (direction == DismissDirection.startToEnd) {
          // 左から右へスワイプ: 編集
          onEdit();
          return false; // 削除しない
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title and Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        koemyaku.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _formatDate(koemyaku.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Message
                if (koemyaku.message.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      koemyaku.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Footer: Marker count and action buttons
                Row(
                  children: [
                    // Marker count
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16.sp,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${koemyaku.markers.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Play button
                    if (_hasVoice)
                      IconButton(
                        onPressed: onPlay,
                        icon: Icon(
                          Icons.play_circle_filled,
                          color: colorScheme.primary,
                        ),
                        tooltip: t.home.play,
                        visualDensity: VisualDensity.compact,
                      ),

                    // Share button
                    IconButton(
                      onPressed: onShare,
                      icon: Icon(
                        Icons.share,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      tooltip: t.home.share,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasVoice {
    return koemyaku.markers.any(
      (marker) => marker.voicePath != null && marker.voicePath!.isNotEmpty,
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Icon(
        icon,
        color: Colors.white,
        size: 28.sp,
      ),
    );
  }

  Future<bool> _showDeleteConfirmDialog(
      BuildContext context, Translations t) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.home.deleteConfirmTitle),
        content: Text(t.home.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(t.home.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat.Hm().format(date);
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(date);
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
}
