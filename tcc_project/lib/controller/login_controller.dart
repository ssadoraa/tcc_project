import 'package:flutter/material.dart';
import 'package:tcc_project/model/usuario.dart';
import 'package:tcc_project/services/auth_service.dart';

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController nome = TextEditingController();
  TextEditingController dataNascimento = TextEditingController();
  TextEditingController pais = TextEditingController();
  TextEditingController estado = TextEditingController();
  TextEditingController cidade = TextEditingController();
  TextEditingController confirmarSenha = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  late AuthService _authService;

  void updateAuthService(AuthService authService) {
    _authService = authService;
  }

  String get titulo => isLogin ? 'Login' : 'Registro';
  String get botao => isLogin ? 'Entrar' : 'Registrar';
  String get toggleButton =>
      isLogin ? 'Não tem conta? Registre-se' : 'Já tem conta? Login';

  void setFormAction(bool login) {
    isLogin = login;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    loading = true;
    notifyListeners();

    try {
      await _authService.login(email.text, senha.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is Exception ? e.toString() : 'Erro desconhecido')),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    loading = true;
    notifyListeners();

    try {
      Usuario usuario = Usuario(
        id: '',
        nome: nome.text,
        dataNascimento: dataNascimento.text,
        pais: pais.text,
        estado: estado.text,
        cidade: cidade.text,
      );

      await _authService.register(email.text, senha.text, usuario);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is Exception ? e.toString() : 'Erro desconhecido')),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void clearControllers() {
    email.clear();
    senha.clear();
    nome.clear();
    dataNascimento.clear();
    pais.clear();
    estado.clear();
    cidade.clear();
    confirmarSenha.clear();
  }
}
