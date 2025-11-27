import 'package:flutter/material.dart';
import 'package:tcc_project/model/event.dart';
import '../services/event_service.dart';

class EventController extends ChangeNotifier {
  final EventService _service;
  List<Event> _futureEvents = [];
  List<Event> _pastEvents = [];

  EventController(this._service);

  List<Event> get allEvents => [..._futureEvents, ..._pastEvents];
  EventService get service => _service;

  void loadEvents(List<Event> events) {
    final now = DateTime.now();
    _futureEvents = events.where((e) => e.data == null || e.data!.isAfter(now)).toList();
    _pastEvents = events.where((e) => e.data != null && e.data!.isBefore(now)).toList();
    notifyListeners();
  }
}