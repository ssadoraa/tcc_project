import 'package:flutter/material.dart';
import 'package:tcc_project/theme/app_colors.dart';

class TopHeader extends StatelessWidget {
  final String title;

  TopHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.secondaryStrong(context),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary(context).withOpacity(0.25),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 24.0, bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.primary(context),
          shadows: [
            Shadow(
              color: AppColors.black(context).withOpacity(0.15),
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
