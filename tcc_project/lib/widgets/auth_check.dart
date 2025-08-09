import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/widgets/main_change.dart';
import 'package:tcc_project/pages/login_page.dart';
import 'package:tcc_project/services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);

    if (authService.isLoading) {
      return loading();
    } else if (authService.usuario == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}