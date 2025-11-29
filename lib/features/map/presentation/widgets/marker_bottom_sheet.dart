import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../i18n/strings.g.dart';

class MarkerBottomSheet extends StatelessWidget {
  const MarkerBottomSheet({
    super.key,
    required this.latLng,
    required this.onSave,
    required this.onDelete,
    this.isEditing = false,
  });

  final LatLng latLng;
  final VoidCallback onSave;
  final VoidCallback onDelete;
  final bool isEditing;

  static Future<void> show({
    required BuildContext context,
    required LatLng latLng,
    required VoidCallback onSave,
    required VoidCallback onDelete,
    VoidCallback? onDismiss,
    bool isEditing = false,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      elevation: 0,
      builder: (context) {
        return MarkerBottomSheet(
          latLng: latLng,
          isEditing: isEditing,
          onSave: () {
            Navigator.pop(context);
            onSave();
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            isEditing
                ? context.t.map.markerBottomSheet.editPinConfirmation
                : context.t.map.markerBottomSheet.addPinConfirmation,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${context.t.map.markerBottomSheet.latitude}: ${latLng.latitude.toStringAsFixed(6)}\n${context.t.map.markerBottomSheet.longitude}: ${latLng.longitude.toStringAsFixed(6)}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDelete,
                  child: Text(context.t.map.markerBottomSheet.delete),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: onSave,
                  child: Text(
                    isEditing
                        ? context.t.map.markerBottomSheet.close
                        : context.t.map.markerBottomSheet.save,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
