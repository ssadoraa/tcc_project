import 'package:flutter/material.dart';
import '../model/guide.dart';
import '../services/guide_service.dart';

class GuideController extends ChangeNotifier {
  final GuideService service;

  List<Guide> guides = [];

  GuideController({required this.service});

  void loadGuides(List<Guide> list) {
    guides = list;
    notifyListeners();
  }
}