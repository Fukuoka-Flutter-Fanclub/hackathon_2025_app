import 'package:flutter/material.dart';

/// マップ読み込み中に表示するローディングウィジェット
class MapLoadingWidget extends StatelessWidget {
  const MapLoadingWidget({
    super.key,
    this.message = '現在地を取得中...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
