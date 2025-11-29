import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../../i18n/strings.g.dart';
import 'voice_recorder/voice_recorder.dart';

class MarkerBottomSheet extends StatefulWidget {
  const MarkerBottomSheet({
    super.key,
    required this.latLng,
    required this.onSave,
    required this.onDelete,
    this.isEditing = false,
    this.onVoiceRecorded,
  });

  final LatLng latLng;
  final void Function(String? voicePath) onSave;
  final VoidCallback onDelete;
  final bool isEditing;
  final ValueChanged<String>? onVoiceRecorded;

  static Future<void> show({
    required BuildContext context,
    required LatLng latLng,
    required void Function(String? voicePath) onSave,
    required VoidCallback onDelete,
    VoidCallback? onDismiss,
    bool isEditing = false,
    ValueChanged<String>? onVoiceRecorded,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      builder: (context) {
        return MarkerBottomSheet(
          latLng: latLng,
          isEditing: isEditing,
          onVoiceRecorded: onVoiceRecorded,
          onSave: (voicePath) {
            Navigator.pop(context);
            onSave(voicePath);
          },
          onDelete: () {
            Navigator.pop(context);
            onDelete();
          },
        );
      },
    ).whenComplete(() {
      onDismiss?.call();
    });
  }

  @override
  State<MarkerBottomSheet> createState() => _MarkerBottomSheetState();
}

class _MarkerBottomSheetState extends State<MarkerBottomSheet> {
  String? _recordedVoicePath;

  void _onVoiceRecorded(String path) {
    setState(() {
      _recordedVoicePath = path;
    });
    widget.onVoiceRecorded?.call(path);
  }

  void _onVoiceDeleted() {
    setState(() {
      _recordedVoicePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ドラッグハンドル
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // タイトル
          Text(
            widget.isEditing
                ? context.t.map.markerBottomSheet.editPinConfirmation
                : context.t.map.markerBottomSheet.addPinConfirmation,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          // 座標情報
          Text(
            '${context.t.map.markerBottomSheet.latitude}: ${widget.latLng.latitude.toStringAsFixed(6)}\n${context.t.map.markerBottomSheet.longitude}: ${widget.latLng.longitude.toStringAsFixed(6)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          // ボイスレコーダー
          VoiceRecorderWidget(
            onRecordingComplete: _onVoiceRecorded,
            onDelete: _onVoiceDeleted,
          ),
          SizedBox(height: 20.h),
          // アクションボタン
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onDelete,
                  child: Text(context.t.map.markerBottomSheet.delete),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: FilledButton(
                  onPressed: () => widget.onSave(_recordedVoicePath),
                  child: Text(
                    widget.isEditing
                        ? context.t.map.markerBottomSheet.close
                        : context.t.map.markerBottomSheet.save,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
