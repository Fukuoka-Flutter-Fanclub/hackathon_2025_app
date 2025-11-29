import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../i18n/strings.g.dart';

class RadiusSlider extends StatelessWidget {
  const RadiusSlider({
    super.key,
    required this.radius,
    required this.onChanged,
    this.min = 10.0,
    this.max = 100.0,
    this.divisions = 9,
  });

  final double radius;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.t.map.markerBottomSheet.rangeLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${radius.toInt()}${context.t.map.markerBottomSheet.rangeUnit}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
            ),
            child: Slider(
              value: radius,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${min.toInt()}${context.t.map.markerBottomSheet.rangeUnit}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              Text(
                '${max.toInt()}${context.t.map.markerBottomSheet.rangeUnit}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
