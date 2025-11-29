import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});
  static const String routeName = '/map';
  static const String name = 'map';

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
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
