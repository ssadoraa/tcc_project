import 'package:flutter/material.dart';
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

    controller.clearControllers();

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
                    SizedBox(height: 20),
                    Text('Email', style: TextStyle(fontSize: 13)),
                    SizedBox(height: 6),
                    TextFormField(
                      controller: controller.email,
                      decoration: _inputDecoration(),
                    ),
                    SizedBox(height: 20),
                    Text('Senha', style: TextStyle(fontSize: 13)),
                    SizedBox(height: 6),
                    TextFormField(
                      controller: controller.senha,
                      obscureText: true,
                      decoration: _inputDecoration(),
                    ),
                    if (!controller.isLogin) ...[
                      SizedBox(height: 20),
                      Text('Confirmar senha', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.confirmarSenha,
                        obscureText: true,
                        decoration: _inputDecoration(),
                      ),
                      SizedBox(height: 20),
                      Text('Nome completo', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.nome,
                        decoration: _inputDecoration(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data de nascimento',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.dataNascimento,
                        decoration: _inputDecoration(),
                      ),
                      SizedBox(height: 20),
                      Text('País', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.pais,
                        decoration: _inputDecoration(),
                      ),
                      SizedBox(height: 20),
                      Text('Estado', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.estado,
                        decoration: _inputDecoration(),
                      ),
                      SizedBox(height: 20),
                      Text('Cidade', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: controller.cidade,
                        decoration: _inputDecoration(),
                      ),
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
                              borderRadius: BorderRadius.circular(12),
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
                    SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          controller.setFormAction(!controller.isLogin);
                        },
                        child: Text(
                          controller.toggleButton,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.secondary,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
