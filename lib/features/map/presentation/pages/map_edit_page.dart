import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackathon_2025_app/core/services/location_service.dart';
import 'package:hackathon_2025_app/core/widgets/map_loading_widget.dart';
import 'package:hackathon_2025_app/features/map/data/models/marker_data.dart';
import 'package:hackathon_2025_app/features/map/presentation/widgets/current_location_marker.dart';
import 'package:hackathon_2025_app/features/map/presentation/widgets/marker_bottom_sheet.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class MapEditPage extends ConsumerStatefulWidget {
  const MapEditPage({super.key});
  static const String routeName = '/map_edit';
  static const String name = 'map_edit';

  @override
  ConsumerState<MapEditPage> createState() => _MapEditPageState();
}

class _MapEditPageState extends ConsumerState<MapEditPage>
    with TickerProviderStateMixin {
  static const _initialZoom = 15.0;
  static const _focusZoom = 17.0;
  static const _animationDuration = Duration(milliseconds: 500);

  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<double>? _compassStreamSubscription;
  AnimationController? _animationController;

  LatLng? _currentPosition;
  double _heading = 0.0;
  bool _isLocationEnabled = false;
  bool _isCompassAvailable = false;
  bool _isLoading = true;

  // タップで追加されるピンのリスト
  final List<MarkerData> _savedMarkers = [];
  // 現在選択中のピン（ボトムシート表示中）
  MarkerData? _selectedMarker;
  // 選択中のマーカーの一時的な半径（ボトムシート操作中）
  double _tempRadius = 5.0;

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _compassStreamSubscription?.cancel();
    _animationController?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// アニメーション付きでマップを移動
  void _animatedMove(LatLng destLocation, double destZoom) {
    // 前のアニメーションをキャンセル
    _animationController?.dispose();

    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    final startLocation = _mapController.camera.center;
    final startZoom = _mapController.camera.zoom;

    final latTween = Tween<double>(
      begin: startLocation.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: startLocation.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(begin: startZoom, end: destZoom);

    final animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );

    _animationController!.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    _animationController!.forward();
  }

  Future<void> _initLocationService() async {
    final locationService = ref.read(locationServiceProvider);

    // 権限を確認してリクエスト
    final hasPermission = await locationService.ensureLocationPermission();
    if (!hasPermission) {
      setState(() {
        _isLoading = false;
      });
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

  void _onMapTapped(LatLng latLng) {
    final newMarker = MarkerData.fromLatLng(
      id: const Uuid().v4(),
      latLng: latLng,
    );
    setState(() {
      _selectedMarker = newMarker;
      _tempRadius = newMarker.radius;
    });

    // ピンが画面の少し上に来るように緯度をオフセット
    final offsetLat = latLng.latitude - 0.001;
    final offsetCenter = LatLng(offsetLat, latLng.longitude);

    // アニメーション付きでズームして移動
    _animatedMove(offsetCenter, _focusZoom);

    // ボトムシートを表示
    _showMarkerBottomSheet(newMarker);
  }

  void _showMarkerBottomSheet(MarkerData marker, {bool isEditing = false}) {
    MarkerBottomSheet.show(
      context: context,
      latLng: marker.latLng,
      isEditing: isEditing,
      initialRadius: marker.radius,
      onRadiusChanged: (radius) {
        setState(() {
          _tempRadius = radius;
        });
      },
      onSave: (voicePath, radius) {
        setState(() {
          if (!isEditing) {
            _savedMarkers.add(marker.copyWith(
              voicePath: voicePath,
              radius: radius,
            ));
          } else {
            // 編集モードの場合は既存のマーカーを更新
            final index = _savedMarkers.indexWhere((m) => m.id == marker.id);
            if (index != -1) {
              _savedMarkers[index] = marker.copyWith(
                voicePath: voicePath,
                radius: radius,
              );
            }
          }
          _selectedMarker = null;
        });
        if (voicePath != null) {
          debugPrint('Voice recorded at: $voicePath');
        }
      },
      onDelete: () {
        setState(() {
          if (isEditing) {
            _savedMarkers.removeWhere((m) => m.id == marker.id);
          }
          _selectedMarker = null;
        });
      },
      onDismiss: () {
        // ボトムシートが閉じられたら選択中のマーカーをクリア
        if (_selectedMarker != null) {
          setState(() {
            _selectedMarker = null;
          });
        }
      },
    );
  }

  void _onSavedMarkerTapped(MarkerData marker) {
    setState(() {
      _selectedMarker = marker;
      _tempRadius = marker.radius;
    });

    // ピンが画面の少し上に来るように緯度をオフセット
    final offsetLat = marker.latitude - 0.001;
    final offsetCenter = LatLng(offsetLat, marker.longitude);

    // アニメーション付きでズームして移動
    _animatedMove(offsetCenter, _focusZoom);

    // 編集モードでボトムシートを表示
    _showMarkerBottomSheet(marker, isEditing: true);
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
      body: SafeArea(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: _initialZoom,
            onTap: (tapPosition, latLng) {
              _onMapTapped(latLng);
            },
          ),
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
            // 保存されたマーカーの円形エリア
            CircleLayer(
              circles: _savedMarkers
                  .where((marker) => marker.id != _selectedMarker?.id)
                  .map(
                    (marker) => CircleMarker(
                      point: marker.latLng,
                      radius: marker.radius,
                      useRadiusInMeter: true,
                      color: Colors.red.withValues(alpha: 0.2),
                      borderColor: Colors.red.withValues(alpha: 0.5),
                      borderStrokeWidth: 2,
                    ),
                  )
                  .toList(),
            ),
            // 選択中のマーカーの円形エリア
            if (_selectedMarker != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _selectedMarker!.latLng,
                    radius: _tempRadius,
                    useRadiusInMeter: true,
                    color: Colors.blue.withValues(alpha: 0.2),
                    borderColor: Colors.blue.withValues(alpha: 0.5),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            // 保存されたピン（選択中のピンは除外）
            MarkerLayer(
              markers: _savedMarkers
                  .where((marker) => marker.id != _selectedMarker?.id)
                  .map(
                    (marker) => Marker(
                      point: marker.latLng,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _onSavedMarkerTapped(marker),
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            // 選択中のピン
            if (_selectedMarker != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedMarker!.latLng,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.blue,
                      size: 50,
                    ),
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
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            if (_currentPosition != null) {
              _animatedMove(_currentPosition!, _initialZoom);
            }
          },
          child: const Icon(Icons.my_location),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
