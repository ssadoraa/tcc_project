import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_project/controller/login_controller.dart';
import 'package:tcc_project/model/usuario.dart';
import 'package:tcc_project/services/auth_service.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:tcc_project/widgets/top_header.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final controller = Provider.of<LoginController>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    final usuario = await context.read<AuthService>().getUser(user!.uid);

    controller.nome.text = usuario.nome;
    controller.pais.text = usuario.pais;
    controller.dataNascimento.text = usuario.dataNascimento;

    if (usuario.pais == 'Brazil') {
      await controller.carregarEstados();
      final estado = controller.estados.firstWhere(
        (e) => e['sigla'] == usuario.estado,
        orElse: () => {},
      );
      if (estado.isNotEmpty) {
        controller.estadoSelecionado = estado['id'];
        await controller.carregarCidades(estado['id']);

        final cidade = controller.cidades.firstWhere(
          (c) => c['nome'] == usuario.cidade,
          orElse: () => {},
        );
        if (cidade.isNotEmpty) controller.cidadeSelecionada = cidade['id'];
      }
    }

    setState(() => isLoading = false);
  }

  InputDecoration _inputDecoration({String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.lightOrangeOpacity(context),
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textSecondary(context)),
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: 180),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Nome completo"),
                        TextFormField(
                          controller: controller.nome,
                          style: TextStyle(color: AppColors.textPrimary(context)),
                          decoration: _inputDecoration(),
                        ),
                        SizedBox(height: 20),

                        _label("Data de nascimento"),
                        TextFormField(
                          controller: controller.dataNascimento,
                          readOnly: true,
                          style: TextStyle(color: AppColors.textPrimary(context)),
                          decoration: _inputDecoration(
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: AppColors.primary(context),
                            ),
                          ),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors.primary(context),
                                      onPrimary: AppColors.background(context),
                                      onSurface: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              controller.dataNascimento.text = DateFormat(
                                'dd/MM/yyyy',
                              ).format(pickedDate);
                            }
                          },
                        ),
                        SizedBox(height: 20),

                        _label("País"),
                        TextFormField(
                          controller: controller.pais,
                          readOnly: true,
                          style: TextStyle(color: AppColors.textPrimary(context)),
                          decoration: _inputDecoration(
                            hint: "Selecione um país",
                          ),
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              onSelect: (country) async {
                                controller.pais.text = country.name;
                                if (country.name == 'Brazil') {
                                  await controller.carregarEstados();
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
                        SizedBox(height: 20),

                        if (controller.pais.text == 'Brazil') ...[
                          _label("Estado"),
                          DropdownButtonFormField<int>(
                            value: controller.estadoSelecionado,
                            decoration: _inputDecoration(),
                            dropdownColor: AppColors.background(
                              context,
                            ),
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
                            onChanged: (value) async {
                              controller.estadoSelecionado = value;
                              await controller.carregarCidades(value);
                              controller.cidadeSelecionada = null;
                            },
                          ),
                          SizedBox(height: 20),

                          _label("Cidade"),
                          DropdownButtonFormField<int>(
                            value: controller.cidadeSelecionada,
                            decoration: _inputDecoration(),
                            dropdownColor: AppColors.background(
                              context,
                            ),
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
                        SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary(context),
                              foregroundColor: AppColors.background(context),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final usuarioAtualizado = Usuario(
                                id: FirebaseAuth.instance.currentUser!.uid,
                                nome: controller.nome.text,
                                pais: controller.pais.text,
                                estado: controller.estadoSelecionado != null
                                    ? controller.estados.firstWhere(
                                        (e) =>
                                            e['id'] ==
                                            controller.estadoSelecionado,
                                      )['sigla']
                                    : '',
                                cidade: controller.cidadeSelecionada != null
                                    ? controller.cidades.firstWhere(
                                        (c) =>
                                            c['id'] ==
                                            controller.cidadeSelecionada,
                                      )['nome']
                                    : '',
                                dataNascimento: controller.dataNascimento.text,
                              );
                              try {
                                await context
                                    .read<AuthService>()
                                    .updateUserProfile(usuarioAtualizado);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text("Perfil atualizado!", 
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textThird(context),
                                      )),
                                    ), 
                                    backgroundColor: AppColors.lightOrange(context),
                                  ),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Salvar Alterações",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                TopHeader(title: "Editar Perfil"),
              ],
            ),
    );
  }
}
