import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../../i18n/strings.g.dart';
import 'radius_slider.dart';
import 'voice_recorder/voice_recorder.dart';

class MarkerBottomSheet extends StatefulWidget {
  const MarkerBottomSheet({
    super.key,
    required this.latLng,
    required this.onSave,
    required this.onDelete,
    required this.onRadiusChanged,
    this.isEditing = false,
    this.onVoiceRecorded,
    this.initialRadius = 10.0,
    this.initialVoicePath,
    this.initialAmplitudes,
  });

  final LatLng latLng;
  final void Function(String? voicePath, double radius, List<double> amplitudes) onSave;
  final VoidCallback onDelete;
  final void Function(double radius) onRadiusChanged;
  final bool isEditing;
  final void Function(String path, List<double> amplitudes)? onVoiceRecorded;
  final double initialRadius;
  final String? initialVoicePath;
  final List<double>? initialAmplitudes;

  static Future<void> show({
    required BuildContext context,
    required LatLng latLng,
    required void Function(String? voicePath, double radius, List<double> amplitudes) onSave,
    required VoidCallback onDelete,
    required void Function(double radius) onRadiusChanged,
    VoidCallback? onDismiss,
    bool isEditing = false,
    void Function(String path, List<double> amplitudes)? onVoiceRecorded,
    double initialRadius = 5.0,
    String? initialVoicePath,
    List<double>? initialAmplitudes,
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
          initialRadius: initialRadius,
          initialVoicePath: initialVoicePath,
          initialAmplitudes: initialAmplitudes,
          onRadiusChanged: onRadiusChanged,
          onSave: (voicePath, radius, amplitudes) {
            Navigator.pop(context);
            onSave(voicePath, radius, amplitudes);
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
  List<double> _recordedAmplitudes = [];
  late double _radius;

  @override
  void initState() {
    super.initState();
    _radius = widget.initialRadius;
    _recordedVoicePath = widget.initialVoicePath;
    _recordedAmplitudes = widget.initialAmplitudes ?? [];
  }

  void _onVoiceRecorded(String path, List<double> amplitudes) {
    setState(() {
      _recordedVoicePath = path;
      _recordedAmplitudes = amplitudes;
    });
    widget.onVoiceRecorded?.call(path, amplitudes);
  }

  void _onVoiceDeleted() {
    setState(() {
      _recordedVoicePath = null;
      _recordedAmplitudes = [];
    });
  }

  void _onRadiusChanged(double value) {
    setState(() {
      _radius = value;
    });
    widget.onRadiusChanged(value);
    HapticFeedback.selectionClick();
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
            initialPath: widget.initialVoicePath,
            initialAmplitudes: widget.initialAmplitudes,
          ),
          // 録音データがある場合のみ半径スライダーを表示
          if (_recordedVoicePath != null) ...[
            SizedBox(height: 16.h),
            RadiusSlider(radius: _radius, onChanged: _onRadiusChanged),
          ],
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
                  onPressed: _recordedVoicePath != null
                      ? () => widget.onSave(_recordedVoicePath, _radius, _recordedAmplitudes)
                      : null,
                  child: Text(context.t.map.markerBottomSheet.save),
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
