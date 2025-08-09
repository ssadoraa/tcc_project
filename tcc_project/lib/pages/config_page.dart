import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/services/auth_service.dart';

class ConfigPage extends StatefulWidget {
  ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: OutlinedButton(
          onPressed: () {
            context.read<AuthService>().logout();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Sair",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
