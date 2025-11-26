import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/controller/login_controller.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:tcc_project/widgets/top_header.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

    final arg = ModalRoute.of(context)!.settings.arguments as bool?;
    if (arg != null) controller.setFormAction(arg);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 180),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text('Email', style: TextStyle(fontSize: 13)),
                    SizedBox(height: 6),
                    TextFormField(
                      controller: controller.email,
                      decoration: _inputDecoration(hint: 'Digite seu email'),
                    ),
                    SizedBox(height: 20),
                    Text('Senha', style: TextStyle(fontSize: 13)),
                    SizedBox(height: 6),
                    TextFormField(
                      controller: controller.senha,
                      obscureText: true,
                      decoration: _inputDecoration(hint: 'Digite sua senha'),
                    ),
                    if (!controller.isLogin) ...[
                      SizedBox(height: 20),
                      Text('Confirmar senha', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.confirmarSenha,
                        obscureText: true,
                        decoration: _inputDecoration(
                          hint: 'Confirme sua senha',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Nome completo', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.nome,
                        decoration: _inputDecoration(
                          hint: 'Digite seu nome completo',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data de nascimento',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.dataNascimento,
                        readOnly: true,
                        decoration: _inputDecoration(
                          hint: 'Selecione sua data de nascimento',
                          suffixIcon: const Icon(Icons.calendar_month),
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            controller.dataNascimento.text = DateFormat(
                              'dd/MM/yyyy',
                            ).format(pickedDate);
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Text('País', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.pais,
                        readOnly: true,
                        decoration: _inputDecoration(hint: 'Selecione um país'),
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            onSelect: (country) {
                              controller.pais.text = country.name;

                              if (country.name == 'Brazil') {
                                controller.carregarEstados();
                              } else {
                                controller.estados = [];
                                controller.cidades = [];
                                controller.estadoSelecionado = null;
                                controller.cidadeSelecionada = null;
                                controller.notifyListeners();
                              }
                            },
                          );
                        },
                      ),
                      if (controller.pais.text == 'Brazil') ...[
                        SizedBox(height: 20),
                        Text('Estado', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          value: controller.estadoSelecionado,
                          decoration: _inputDecoration(
                            hint: 'Selecione um estado',
                          ),
                          items: controller.estados.map((estado) {
                            return DropdownMenuItem<int>(
                              value: estado['id'],
                              child: Text(estado['sigla']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.estadoSelecionado = value;
                            controller.carregarCidades(value);
                            controller.cidadeSelecionada = null;
                          },
                        ),
                        SizedBox(height: 20),
                        Text('Cidade', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          value: controller.cidadeSelecionada,
                          decoration: _inputDecoration(
                            hint: 'Selecione uma cidade',
                          ),
                          items: controller.cidades.map((cidade) {
                            return DropdownMenuItem<int>(
                              value: cidade['id'],
                              child: Text(cidade['nome']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.cidadeSelecionada = value;
                          },
                        ),
                      ],
                    ],
                    SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.isLogin
                                  ? controller.login(context)
                                  : controller.register(context);
                            }
                          },
                          child: controller.loading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(controller.botao),
                        ),
                      ),
                    ),
                    SizedBox(height: 75),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.setFormAction(!controller.isLogin);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.primary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: controller.isLogin
                                          ? "Ainda não possui uma conta?\n"
                                          : "Já tem conta?\n",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.isLogin
                                          ? "Cadastre-se"
                                          : "Entrar",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TopHeader(title: controller.titulo),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.secondary,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintText: hint,
      hintStyle: TextStyle(fontSize: 11),
      suffixIcon: suffixIcon,
    );
  }
}
