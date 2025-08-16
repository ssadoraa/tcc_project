import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/services/auth_service.dart';

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  String titulo = '';
  String botao = '';
  String toggleButton = '';

  LoginController() {
    setFormAction(true);
  }

  void setFormAction(bool acao) {
    isLogin = acao;

    if (isLogin) {
      titulo = 'Bem vindo(a)!';
      botao = 'Entrar';
      toggleButton = 'Ainda não possui uma conta? Cadastre-se agora.';
    } else {
      titulo = 'Crie sua conta';
      botao = 'Cadastrar';
      toggleButton = 'Voltar para o login';
    }

    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      await context.read<AuthService>().login(email.text, password.text);
    } on AuthException catch (e) {
      loading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> register(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      await context.read<AuthService>().register(email.text, password.text);
    } on AuthException catch (e) {
      loading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
