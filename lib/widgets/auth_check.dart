import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/widgets/main_change.dart';
import 'package:tcc_project/pages/login_page.dart';
import 'package:tcc_project/services/auth_service.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (authService.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    if (authService.usuario == null) {
      return LoginPage();
    }

    return HomePage();
  }
}
