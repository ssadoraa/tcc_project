import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/controller/login_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: TextFormField(
            controller: controller.confirmarSenha,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar senha',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirme sua senha.';
              } else if (value != controller.senha.text) {
                return 'As senhas não coincidem.';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: TextFormField(
            controller: controller.nome,
            decoration: const InputDecoration(
              labelText: 'Nome completo',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe seu nome completo.';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: TextFormField(
            controller: controller.dataNascimento,
            decoration: const InputDecoration(
              labelText: 'Data de nascimento',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe sua data de nascimento.';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: TextFormField(
            controller: controller.pais,
            decoration: const InputDecoration(
              labelText: 'País',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o país.';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: TextFormField(
            controller: controller.estado,
            decoration: const InputDecoration(
              labelText: 'Estado',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o estado.';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: TextFormField(
            controller: controller.cidade,
            decoration: const InputDecoration(
              labelText: 'Cidade',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a cidade.';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
