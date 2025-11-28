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
      backgroundColor: AppColors.background(context),
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
                    _label(context, "Email"),
                    TextFormField(
                      controller: controller.email,
                      style: TextStyle(color: AppColors.textPrimary(context)),
                      decoration: _inputDecoration(
                        context,
                        hint: 'Digite seu email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o email';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _label(context, "Senha"),
                    TextFormField(
                      controller: controller.senha,
                      obscureText: true,
                      style: TextStyle(color: AppColors.textPrimary(context)),
                      decoration: _inputDecoration(
                        context,
                        hint: 'Digite sua senha',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter no mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    if (!controller.isLogin) ...[
                      SizedBox(height: 20),
                      _label(context, "Confirmar senha"),
                      TextFormField(
                        controller: controller.confirmarSenha,
                        obscureText: true,
                        style: TextStyle(color: AppColors.textPrimary(context)),
                        decoration: _inputDecoration(
                          context,
                          hint: 'Confirme sua senha',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirme sua senha';
                          }
                          if (value != controller.senha.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _label(context, "Nome completo"),
                      TextFormField(
                        controller: controller.nome,
                        style: TextStyle(color: AppColors.textPrimary(context)),
                        decoration: _inputDecoration(
                          context,
                          hint: 'Digite seu nome completo',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe seu nome';
                          }
                          if (value.length < 3) {
                            return 'Nome muito curto';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _label(context, "Data de nascimento"),
                      TextFormField(
                        controller: controller.dataNascimento,
                        readOnly: true,
                        style: TextStyle(color: AppColors.textPrimary(context)),
                        decoration: _inputDecoration(
                          context,
                          hint: 'Selecione sua data de nascimento',
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColors.primaryStrong(context),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione sua data de nascimento';
                          }
                          return null;
                        },
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
                      _label(context, "País"),
                      TextFormField(
                        controller: controller.pais,
                        readOnly: true,
                        style: TextStyle(color: AppColors.textPrimary(context)),
                        decoration: _inputDecoration(
                          context,
                          hint: 'Selecione um país',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione um país';
                          }
                          return null;
                        },
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
                        _label(context, "Estado"),
                        DropdownButtonFormField<int>(
                          value: controller.estadoSelecionado,
                          decoration: _inputDecoration(
                            context,
                            hint: 'Selecione um estado',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um estado';
                            }
                            return null;
                          },
                          items: controller.estados.map((estado) {
                            return DropdownMenuItem<int>(
                              value: estado['id'],
                              child: Text(
                                estado['sigla'],
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.estadoSelecionado = value;
                            controller.carregarCidades(value);
                            controller.cidadeSelecionada = null;
                          },
                        ),
                        SizedBox(height: 20),
                        _label(context, "Cidade"),
                        DropdownButtonFormField<int>(
                          value: controller.cidadeSelecionada,
                          decoration: _inputDecoration(
                            context,
                            hint: 'Selecione uma cidade',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione uma cidade';
                            }
                            return null;
                          },
                          items: controller.cidades.map((cidade) {
                            return DropdownMenuItem<int>(
                              value: cidade['id'],
                              child: Text(
                                cidade['nome'],
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.cidadeSelecionada = value;
                          },
                        ),
                      ],
                    ],
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary(context),
                          foregroundColor: AppColors.background(context),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: AppColors.primary(
                            context,
                          ).withOpacity(0.3),
                          elevation: 4,
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
                                  color: AppColors.background(context),
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    controller.isLogin
                                        ? Icons.login
                                        : Icons.person_add,
                                    color: AppColors.background(context),
                                  ),
                                  SizedBox(width: 8),
                                  Text(controller.botao),
                                ],
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
                            color: AppColors.secondary(
                              context,
                            ).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textPrimary(context),
                              ),
                              children: [
                                TextSpan(
                                  text: controller.isLogin
                                      ? "Ainda não possui uma conta?\n"
                                      : "Já tem conta?\n",
                                ),
                                TextSpan(
                                  text: controller.isLogin
                                      ? "Cadastre-se"
                                      : "Entrar",
                                  style: TextStyle(
                                    color: AppColors.lightGreen(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _label(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.lightOrangeOpacity(context).withOpacity(0.3),
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textSecondary(context).withOpacity(0.8),
        fontSize: 11,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
    );
  }
}
