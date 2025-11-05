import 'package:flutter/material.dart';
import 'package:tcc_project/theme/app_theme.dart';
import 'package:tcc_project/widgets/auth_check.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DesenGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AuthCheck(),
    );
  }
}