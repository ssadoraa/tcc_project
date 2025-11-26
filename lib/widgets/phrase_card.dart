import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:tcc_project/controller/phrase_controller.dart';
import 'package:tcc_project/theme/app_colors.dart';
import '../services/phrase_service.dart';

class PhraseCard extends StatefulWidget {
  PhraseCard({Key? key}) : super(key: key);

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
        ? Center(child: CircularProgressIndicator(color: AppColors.primary))
        : _buildCard();
  }

  Widget _buildCard() {
    return Card(
      color: AppColors.background,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.border, width: 1.3),
      ),
      shadowColor: AppColors.primary.withOpacity(0.25),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lightbulb_outline, size: 26, color: AppColors.primary),
            SizedBox(height: 12),
            AnimatedTextKit(
              key: ValueKey(currentPhrase),
              animatedTexts: [
                TypewriterAnimatedText(
                  currentPhrase,
                  textStyle: TextStyle(
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  speed: Duration(milliseconds: 40),
                  textAlign: TextAlign.center,
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration.zero,
            ),
          ],
        ),
      ),
    );
  }
}
