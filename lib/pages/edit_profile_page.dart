import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_project/model/usuario.dart';
import 'package:tcc_project/services/auth_service.dart';
import 'package:tcc_project/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nomeController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final paisController = TextEditingController();
  final nascimentoController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    final dados = doc.data()!;
    nomeController.text = dados["nome"];
    cidadeController.text = dados["cidade"];
    estadoController.text = dados["estado"];
    paisController.text = dados["pais"];
    nascimentoController.text = dados["dataNascimento"];

    setState(() => isLoading = false);
  }

  InputDecoration _decor(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.secondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      labelStyle: TextStyle(color: AppColors.primary),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("Editar Perfil", style: TextStyle(fontSize: 18)),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Informações do Perfil",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 20),

                      TextField(
                        controller: nomeController,
                        decoration: _decor("Nome completo"),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        controller: cidadeController,
                        decoration: _decor("Cidade"),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        controller: estadoController,
                        decoration: _decor("Estado"),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        controller: paisController,
                        decoration: _decor("País"),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        controller: nascimentoController,
                        decoration: _decor("Data de nascimento"),
                      ),

                      SizedBox(height: 25),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final usuarioAtualizado = Usuario(
                            id: FirebaseAuth.instance.currentUser!.uid,
                            nome: nomeController.text,
                            cidade: cidadeController.text,
                            estado: estadoController.text,
                            pais: paisController.text,
                            dataNascimento: nascimentoController.text,
                          );

                          try {
                            await context.read<AuthService>().updateUserProfile(
                              usuarioAtualizado,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Perfil atualizado!")),
                            );

                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        child: Text(
                          "Salvar Alterações",
                          style: TextStyle(fontSize: 16),
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
