import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapEditPage extends ConsumerStatefulWidget {
  const MapEditPage({super.key});
  static const String routeName = '/map_edit';
  static const String name = 'map_edit';

  @override
  ConsumerState<MapEditPage> createState() => _MapEditPageState();
}

class _MapEditPageState extends ConsumerState<MapEditPage> {
  @override
  void initState() {
    super.initState();
    // ウィジェットの構築が完了してからプロバイダーを初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ここで必要に応じて初期化処理を行う
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(child: Container()),
    );
  }
}
