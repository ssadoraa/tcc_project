import 'dart:async';
import 'dart:typed_data';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class MapService {
  mapbox.MapboxMap? map;
  mapbox.PointAnnotationManager? annotationManager;

  mapbox.PointAnnotation? userMarker;

  double? _userLat;
  double? _userLng;

  final Map<String, Function()> tapCallbacks = {};

  void initMap(mapbox.MapboxMap m) {
    map = m;
  }

  Future<void> initAnnotationManager() async {
    if (map == null) return;

    annotationManager =
        await map!.annotations.createPointAnnotationManager();

    annotationManager!.addOnPointAnnotationClickListener(
      PointClickListener(tapCallbacks),
    );
  }

  Future<void> moveCamera(double lat, double lng) async {
    if (map == null) return;

    await map!.setCamera(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(lng, lat),
        ),
      ),
    );
  }

  Future<void> moveCameraWithZoom(double lat, double lng,
      {double zoom = 16}) async {
    if (map == null) return;

    await map!.setCamera(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(lng, lat),
        ),
        zoom: zoom,
      ),
    );
  }

  Future<mapbox.PointAnnotation?> addMarker({
    required double lat,
    required double lng,
    required Uint8List image,
    double iconSize = 0.3,
    Function()? onTap,
  }) async {
    if (annotationManager == null) return null;

    final options = mapbox.PointAnnotationOptions(
      geometry: mapbox.Point(
        coordinates: mapbox.Position(lng, lat),
      ),
      image: image,
      iconSize: iconSize,
    );

    final marker = await annotationManager!.create(options);

    if (onTap != null) {
      tapCallbacks[marker.id] = onTap;
    }

    return marker;
  }

  Future<void> updateUserLocation({
    required double lat,
    required double lng,
    required Uint8List image,
    double iconSize = 0.4,
  }) async {
    if (annotationManager == null) return;

    if (userMarker != null) {
      await annotationManager!.delete(userMarker!);
    }

    final options = mapbox.PointAnnotationOptions(
      geometry: mapbox.Point(
        coordinates: mapbox.Position(lng, lat),
      ),
      image: image,
      iconSize: iconSize,
    );

    userMarker = await annotationManager!.create(options);

    _userLat = lat;
    _userLng = lng;
  }
}

class PointClickListener extends mapbox.OnPointAnnotationClickListener {
  final Map<String, Function()> callbacks;
  PointClickListener(this.callbacks);

  @override
  bool onPointAnnotationClick(mapbox.PointAnnotation annotation) {
    final fn = callbacks[annotation.id];
    if (fn != null) fn();
    return true;
  }
}
