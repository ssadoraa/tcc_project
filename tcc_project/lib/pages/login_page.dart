import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String botao;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
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
    });
  }

  login() async {
    setState(() => loading = true);
    try{
      await context.read<AuthService>().login(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
  
  register() async {
    setState(() => loading = true);
    try{
      await context.read<AuthService>().register(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
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
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
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
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isLogin) {
                          login();
                        }
                        else {
                          register();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                      ? [
                        Padding(
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
                        Icon(Icons.check),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            botao,
                            style: TextStyle(fontSize: 20),
                          ),
                        )
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Image.asset(
                        'assets/images/google.jpg',
                        width: 48,
                        height: 48,
                      ),
                    ),
                    SizedBox(width: 16), // Espaço entre os botões
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Image.asset(
                        'assets/images/outlook.png', // Coloque a imagem correta aqui
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setFormAction(!isLogin);
                  },
                  child: Text(
                    toggleButton
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
