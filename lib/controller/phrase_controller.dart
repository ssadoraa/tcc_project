import 'dart:async';
import 'dart:math';
import '../services/phrase_service.dart';

class PhraseController {
  final PhraseService service;
  List<String> phrases = [];
  String currentPhrase = "";
  Timer? _timer;
  final Random _random = Random();

  PhraseController({required this.service});

  Future<void> loadPhrases(Function(String) onUpdate) async {
    phrases = await service.fetchPhrases();

    if (phrases.isNotEmpty) {
      _changePhrase(onUpdate);

      _timer = Timer.periodic(Duration(seconds: 15), (_) {
        _changePhrase(onUpdate);
      });
    }
  }

  void _changePhrase(Function(String) onUpdate) {
    if (phrases.isEmpty) return;

    String newPhrase;
    do {
      newPhrase = phrases[_random.nextInt(phrases.length)];
    } while (newPhrase == currentPhrase && phrases.length > 1);

    currentPhrase = newPhrase;
    onUpdate(currentPhrase);
  }

  void dispose() {
    _timer?.cancel();
  }
}
