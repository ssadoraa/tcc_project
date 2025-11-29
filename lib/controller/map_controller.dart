import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tcc_project/model/icons_to_byte.dart';
import 'package:tcc_project/services/map_service.dart';
import 'package:tcc_project/model/attraction_dependence.dart';

class MapController {
  final MapService mapService = MapService();

  StreamSubscription<Position>? positionStream;
  Uint8List? userIcon;
  Uint8List? fixedIcon;
  bool _initialCameraMoved = false;

  /// Lista de atrações
  List<AttractionDependence> attractions = [];

  /// Callback quando um pin é clicado
  Function(AttractionDependence)? onAttractionTap;

  Future<void> loadIcons() async {
    userIcon = await iconToBytes(
      Icons.person_pin_circle,
      size: 200,
      color: Colors.blue,
    );

    fixedIcon = await iconToBytes(
      Icons.location_on,
      size: 200,
      color: Colors.red,
    );
  }

  Future<void> initMap(
    mapbox.MapboxMap map, {
    required List<AttractionDependence> attractionList,
    required Function(AttractionDependence) onTapAttraction,
  }) async {
    attractions = attractionList;
    onAttractionTap = onTapAttraction;

    mapService.initMap(map);
    await loadIcons();
    await mapService.initAnnotationManager();

    await _addAttractionPins();
    await _startTrackingUser();
  }

  Future<void> _addAttractionPins() async {
    if (fixedIcon == null) return;

    for (var attraction in attractions) {
      await mapService.addMarker(
        lat: attraction.latitude,
        lng: attraction.longitude,
        image: fixedIcon!,
        iconSize: 0.55,
        onTap: () => onAttractionTap?.call(attraction),
      );
    }
  }

  Future<void> _startTrackingUser() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      updateUserLocation(pos);
    });
  }

  Future<void> updateUserLocation(Position pos) async {
    if (userIcon == null) return;

    await mapService.updateUserLocation(
      lat: pos.latitude,
      lng: pos.longitude,
      image: userIcon!,
    );

    if (!_initialCameraMoved) {
      _initialCameraMoved = true;

      await mapService.moveCameraWithZoom(
        pos.latitude,
        pos.longitude,
        zoom: 16,
      );
    } else {
      await mapService.moveCamera(pos.latitude, pos.longitude);
    }
  }

  void dispose() {
    positionStream?.cancel();
  }
}