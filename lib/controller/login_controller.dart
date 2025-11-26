import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_project/model/usuario.dart';
import 'package:tcc_project/services/auth_service.dart';

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController nome = TextEditingController();
  TextEditingController dataNascimento = TextEditingController();
  TextEditingController pais = TextEditingController();
  TextEditingController confirmarSenha = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  late AuthService _authService;

  List<Map<String, dynamic>> estados = [];
  List<Map<String, dynamic>> cidades = [];
  int? estadoSelecionado;
  int? cidadeSelecionada;

  void updateAuthService(AuthService authService) {
    _authService = authService;
  }

  String get titulo => isLogin ? 'Entrar' : 'Registre-se';
  String get botao => isLogin ? 'Entrar' : 'Registrar';
  String get toggleButton => isLogin ? 'Ainda não possui uma conta? Registre-se' : 'Já tem conta? Login';

  void setFormAction(bool login) {
    isLogin = login;
    clearControllers();
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
        estado: estadoSelecionado != null
            ? estados
                .firstWhere((e) => e['id'] == estadoSelecionado)['sigla']
            : '',
        cidade: cidadeSelecionada != null
            ? cidades
                .firstWhere((c) => c['id'] == cidadeSelecionada)['nome']
            : '',
      );

      await _authService.register(email.text, senha.text, usuario);
      clearControllers();
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
    confirmarSenha.clear();
    estados = [];
    cidades = [];
    estadoSelecionado = null;
    cidadeSelecionada = null;
    notifyListeners();
  }

  Future<void> carregarEstados() async {
    estados = await getEstados();
    notifyListeners();
  }

  Future<void> carregarCidades(int? estadoId) async {
    if (estadoId != null) {
      cidades = await getCidades(estadoId);
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getEstados() async {
    String url =
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> estados = data.map((e) {
        return {'id': e['id'], 'sigla': e['sigla']};
      }).toList();
      estados.sort((a, b) => a['sigla'].compareTo(b['sigla']));
      return estados;
    } else {
      throw Exception('Falha ao carregar os estados!');
    }
  }

  Future<List<Map<String, dynamic>>> getCidades(int? estadoSelecionado) async {
    String url =
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados/$estadoSelecionado/municipios";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> cidades = data.map((c) {
        return {'id': c['id'], 'nome': c['nome']};
      }).toList();
      cidades.sort((a, b) => a['nome'].compareTo(b['nome']));
      return cidades;
    } else {
      throw Exception('Falha ao carregar as cidades!');
    }
  }
}
