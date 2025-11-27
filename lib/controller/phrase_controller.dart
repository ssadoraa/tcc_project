import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../services/phrase_service.dart';

class PhraseController extends ChangeNotifier {
  final PhraseService service;
  List<String> phrases = [];
  String currentPhrase = "";
  Timer? _timer;
  final Random _random = Random();

  PhraseController({required this.service}) {
    loadPhrases();
  }

  Future<void> loadPhrases() async {
    phrases = await service.fetchPhrases();
    if (phrases.isNotEmpty) {
      _changePhrase();
      _timer = Timer.periodic(Duration(seconds: 15), (_) => _changePhrase());
    }
  }

  void _changePhrase() {
    if (phrases.isEmpty) return;
    String newPhrase;
    do {
      newPhrase = phrases[_random.nextInt(phrases.length)];
    } while (newPhrase == currentPhrase && phrases.length > 1);

    currentPhrase = newPhrase;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}