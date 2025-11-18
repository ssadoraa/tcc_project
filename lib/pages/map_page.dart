import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:typed_data';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  mapbox.MapboxMap? mapboxMap;
  mapbox.PointAnnotationManager? pointAnnotationManager;
  mapbox.PointAnnotation? userMarker;
  StreamSubscription<Position>? positionStream;
  Uint8List? userMarkerImage;

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapbox.MapWidget(
        styleUri: mapbox.MapboxStyles.OUTDOORS,
        onMapCreated: (controller) {
          mapboxMap = controller;
          _loadMarkerImage().then((_) {
            _initLocationTracking();
          });
        },
      ),
    );
  }

  Future<void> _loadMarkerImage() async {
    final ByteData bytes = await DefaultAssetBundle.of(
      context,
    ).load('assets/images/pino.png');
    userMarkerImage = bytes.buffer.asUint8List();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    pointAnnotationManager = await mapboxMap!.annotations
        .createPointAnnotationManager();

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((position) {
          _updateUserLocation(position);
        });
  }

  Future<void> _updateUserLocation(Position position) async {
    if (mapboxMap == null ||
        pointAnnotationManager == null ||
        userMarkerImage == null)
      return;

    await mapboxMap!.setCamera(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(position.longitude, position.latitude),
        ),
        zoom: 16.0,
      ),
    );

    final options = mapbox.PointAnnotationOptions(
      geometry: mapbox.Point(
        coordinates: mapbox.Position(position.longitude, position.latitude),
      ),
      image: userMarkerImage,
      iconSize: 0.3,
    );

    if (userMarker == null) {
      userMarker = await pointAnnotationManager!.create(options);
    } else {
      await pointAnnotationManager!.delete(userMarker!);
      userMarker = await pointAnnotationManager!.create(options);
    }
  }
}
