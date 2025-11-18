import 'package:flutter/material.dart';
import 'package:tcc_project/controller/phrase_controller.dart';
import '../services/phrase_service.dart';

class PhraseCard extends StatefulWidget {
  const PhraseCard({Key? key}) : super(key: key);

  @override
  _PhraseCardState createState() => _PhraseCardState();
}

class _PhraseCardState extends State<PhraseCard> {
  late final PhraseController controller;
  String currentPhrase = "";

  @override
  void initState() {
    super.initState();
    controller = PhraseController(service: PhraseService());

    controller.loadPhrases((phrase) {
      if (mounted) {
        setState(() {
          currentPhrase = phrase;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return currentPhrase.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Colors.black.withOpacity(0.05),
                width: 1.2,
              ),
            ),
            shadowColor: Colors.black.withOpacity(0.15),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lightbulb_outline, size: 26),
                  SizedBox(height: 12),
                  Text(
                    currentPhrase,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
