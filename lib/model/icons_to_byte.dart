import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<Uint8List> iconToBytes(
  IconData icon, {
  double size = 72,
  Color color = Colors.red,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final painter = TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: icon.fontFamily,
        color: color,
      ),
    ),
  );

  painter.layout();
  painter.paint(canvas, Offset.zero);

  final picture = recorder.endRecording();
  final img = await picture.toImage(
    painter.width.toInt(),
    painter.height.toInt(),
  );

  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
