import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/phrase_controller.dart';
import '../theme/app_colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class PhraseCard extends StatelessWidget {
  PhraseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PhraseController>();

    if (controller.currentPhrase.isEmpty) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

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
              key: ValueKey(controller.currentPhrase),
              animatedTexts: [
                TypewriterAnimatedText(
                  controller.currentPhrase,
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