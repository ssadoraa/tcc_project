import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/pages/edit_profile_page.dart';
import 'package:tcc_project/services/auth_service.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart' as url_launcher;

class ConfigPage extends StatefulWidget {
  ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool darkMode = false;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionCard(
              title: "Conta",
              color: AppColors.lightOrangeOpacity,
              children: [
                _buildOptionTile(
                  icon: Icons.person,
                  title: "Editar perfil",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  ),
                ),
                _buildOptionTile(
                  icon: Icons.lock,
                  title: "Alterar senha",
                  onTap: () => _showChangePasswordDialog(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              title: "Preferências",
              color: AppColors.lightGreen.withOpacity(0.8),
              children: [
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: "Modo escuro",
                  value: darkMode,
                  onChanged: (val) => setState(() => darkMode = val),
                ),
                _buildSwitchTile(
                  icon: Icons.notifications_active,
                  title: "Notificações",
                  value: notifications,
                  onChanged: (val) => setState(() => notifications = val),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSectionCard(
              title: "Sobre",
              color: AppColors.lightOrangeOpacity,
              children: [
                _buildOptionTile(
                  icon: Icons.info_outline,
                  title: "Sobre o app",
                  onTap: () => _showAboutDialog(context),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialIcon(
                      'assets/images/instagram.png',
                      'https://www.instagram.com/parqueestadualdodesengano/',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.facebook,
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                      onPressed: () => url_launcher.launchUrlString(
                        'https://www.facebook.com/ParqueEstadualDoDesengano/?locale=pt_BR',
                      ),
                    ),
                    _socialIcon(
                      'assets/images/youtube.png',
                      'https://www.youtube.com/@amigosdoparqueestadualdode6371',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final atualController = TextEditingController();
    final novaController = TextEditingController();
    final confirmarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 24),
          title: Text("Alterar Senha"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                _buildPasswordField("Senha atual", atualController),
                SizedBox(height: 12),
                _buildPasswordField("Nova senha", novaController),
                SizedBox(height: 12),
                _buildPasswordField(
                  "Confirmar nova senha",
                  confirmarController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                if (novaController.text != confirmarController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("As senhas não coincidem")),
                  );
                  return;
                }

                try {
                  await context.read<AuthService>().changePassword(
                    atualController.text,
                    novaController.text,
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Senha alterada com sucesso!"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sobre o App"),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: AppColors.textSecondary),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              "O DesenGo é um aplicativo criado para valorizar e aproximar as pessoas do Parque Estadual do Desengano, no norte do Rio de Janeiro..."
              "\n\nDentro do app, você encontra um mapa com trilhas georreferenciadas, localização em tempo real e pontos marcados com QR Codes..."
              "\n\nA ideia é transformar a experiência no parque em algo envolvente e acessível, usando elementos de gamificação...",
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    Color? color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? AppColors.lightGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8, left: 4, top: 4),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryStrong,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: AppColors.background,
        child: Icon(icon, color: AppColors.primaryStrong),
      ),
      title: Text(title, style: TextStyle(color: AppColors.textPrimary)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: CircleAvatar(
        backgroundColor: AppColors.background,
        child: Icon(icon, color: AppColors.secondaryStrong),
      ),
      title: Text(title, style: TextStyle(color: AppColors.textPrimary)),
      value: value,
      activeColor: AppColors.primaryStrong,
      onChanged: onChanged,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        icon: Icon(Icons.logout),
        label: Text("Sair da conta"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryStrong,
          foregroundColor: AppColors.background,
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Sair da conta?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Sair"),
                ),
              ],
            ),
          );

          if (confirm == true) {
            context.read<AuthService>().logout();
          }
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _socialIcon(String assetPath, String url) {
    return InkWell(
      onTap: () => url_launcher.launchUrlString(url),
      child: Image.asset(assetPath, width: 40, height: 40),
    );
  }
}
