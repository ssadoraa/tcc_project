import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.titulo,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: TextFormField(
                          controller: controller.email,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, insira seu e-mail corretamente.';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                        child: TextFormField(
                          controller: controller.password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe sua senha.';
                            } else if (value.length < 6) {
                              return 'Sua senha deve conter pelo menos 6 caracteres.';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              if (controller.isLogin) {
                                controller.login(context);
                              } else {
                                controller.register(context);
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (controller.loading)
                                ? [
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    const Icon(Icons.check),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        controller.botao,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/google.jpg',
                              width: 48,
                              height: 48,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/outlook.png',
                              width: 48,
                              height: 48,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          controller.setFormAction(!controller.isLogin);
                        },
                        child: Text(controller.toggleButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
