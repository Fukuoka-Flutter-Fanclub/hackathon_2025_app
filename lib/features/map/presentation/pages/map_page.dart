import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackathon_2025_app/core/services/location_service.dart';
import 'package:hackathon_2025_app/core/widgets/map_loading_widget.dart';
import 'package:hackathon_2025_app/features/map/presentation/widgets/current_location_marker.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});
  static const String routeName = '/map';
  static const String name = 'map';

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  static const _initialZoom = 15.0;

  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<double>? _compassStreamSubscription;

  LatLng? _currentPosition;
  double _heading = 0.0;
  bool _isLocationEnabled = false;
  bool _isCompassAvailable = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _compassStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocationService() async {
    final locationService = ref.read(locationServiceProvider);

    // 権限を確認してリクエスト
    final hasPermission = await locationService.ensureLocationPermission();
    if (!hasPermission) {
      return;
    }

    setState(() {
      _isLocationEnabled = true;
    });

    // 現在位置を取得
    final position = await locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _heading = position.heading;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    // 位置情報のストリームを開始
    _positionStreamSubscription = locationService.getPositionStream().listen((
      Position position,
    ) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        // コンパスが利用不可の場合はGPSのheadingを使用
        if (!_isCompassAvailable) {
          _heading = position.heading;
        }
      });
    });

    // コンパスのストリームを開始（利用可能な場合のみ）
    _isCompassAvailable = await locationService.isCompassAvailable();
    if (_isCompassAvailable) {
      _compassStreamSubscription = locationService.getCompassStream().listen((
        double heading,
      ) {
        setState(() {
          _heading = heading;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ローディング中はインジケータを表示
    if (_isLoading) {
      return const MapLoadingWidget();
    }

    // 現在位置が取得できなかった場合のフォールバック（東京駅）
    final center = _currentPosition ?? const LatLng(35.6812, 139.7671);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: center, initialZoom: _initialZoom),
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              userAgentPackageName: 'com.example.hackathon_2025_app',
            ),
            if (_currentPosition != null && _isLocationEnabled)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 60,
                    height: 60,
                    child: CurrentLocationMarker(heading: _heading),
                  ),
                ],
              ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPosition != null) {
            _mapController.move(_currentPosition!, _initialZoom);
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
