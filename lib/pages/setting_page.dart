import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/controller/setting_controller.dart';
import 'package:tcc_project/pages/edit_profile_page.dart';
import 'package:tcc_project/theme/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  static String aboutText =
      "O DesenGo é um aplicativo criado para valorizar e aproximar as pessoas do Parque Estadual do Desengano, no norte do Rio de Janeiro. Ele foi desenvolvido como parte de um projeto que une tecnologia, turismo e educação ambiental para tornar a visita ao parque mais interativa, divertida e informativa.\n\n"
      "Dentro do app, você encontra um mapa com trilhas georreferenciadas, localização em tempo real e pontos marcados com QR Codes espalhados pelo parque. Ao escanear esses códigos, novas figurinhas virtuais e conteúdos educativos sobre a fauna, a flora e curiosidades locais são desbloqueados.\n\n"
      "A ideia é transformar a experiência no parque em algo envolvente e acessível, usando elementos de gamificação para incentivar a exploração consciente e o cuidado com o meio ambiente. O DesenGo foi criado para ajudar visitantes, estudantes e moradores a conhecerem melhor o Desengano, valorizando sua história, biodiversidade e importância para a região.";

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingController>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _sectionConta(context, controller),
            SizedBox(height: 16),
            _sectionPreferencias(context, controller),
            SizedBox(height: 16),
            _sectionSobre(context),
            SizedBox(height: 32),
            _logoutButton(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _sectionConta(BuildContext context, SettingController controller) {
    return _buildSectionCard(
      context,
      title: "Conta",
      color: AppColors.lightOrangeOpacity(context),
      children: [
        _buildOptionTile(
          context: context,
          icon: Icons.person,
          title: "Editar perfil",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditProfilePage()),
          ),
        ),
        _buildOptionTile(
          context: context,
          icon: Icons.lock,
          title: "Alterar senha",
          onTap: () => _openChangePasswordDialog(context, controller),
        ),
      ],
    );
  }

  Widget _sectionPreferencias(
    BuildContext context,
    SettingController controller,
  ) {
    return _buildSectionCard(
      context,
      title: "Preferências",
      color: AppColors.lightGreen(context).withOpacity(0.8),
      children: [
        _buildSwitchTile(
          context: context,
          icon: Icons.dark_mode,
          title: "Modo escuro",
          value: controller.darkMode,
          onChanged: controller.toggleDarkMode,
        ),
        _buildSwitchTile(
          context: context,
          icon: Icons.notifications_active,
          title: "Notificações",
          value: controller.notifications,
          onChanged: controller.toggleNotifications,
        ),
      ],
    );
  }

  Widget _sectionSobre(BuildContext context) {
    return _buildSectionCard(
      context,
      title: "Sobre",
      color: AppColors.lightOrangeOpacity(context),
      children: [
        _buildOptionTile(
          context: context,
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
              icon: Icon(Icons.facebook, size: 40, color: Colors.blueAccent),
              onPressed: () => launchUrlString(
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
    );
  }

  Widget _logoutButton(BuildContext context, SettingController controller) {
    return ElevatedButton.icon(
      icon: Icon(Icons.logout),
      label: Text("Sair da conta"),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryStrong(context),
        foregroundColor: AppColors.background(context),
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
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
        if (confirm == true) await controller.logout();
      },
    );
  }

  void _openChangePasswordDialog(
    BuildContext context,
    SettingController controller,
  ) {
    final atualController = TextEditingController();
    final novaController = TextEditingController();
    final confirmarController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text("Alterar Senha"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _styledPasswordField(
                context,
                atualController,
                label: "Senha atual",
              ),
              _styledPasswordField(
                context,
                novaController,
                label: "Nova senha",
              ),
              _styledPasswordField(
                context,
                confirmarController,
                label: "Confirmar senha",
              ),
              if (controller.passwordError != null)
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    controller.passwordError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (novaController.text != confirmarController.text) {
                  setState(
                    () => controller.passwordError = "As senhas não coincidem.",
                  );
                  return;
                }
                final success = await controller.changePassword(
                  atualController.text,
                  novaController.text,
                );
                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Senha alterada com sucesso!")),
                  );
                } else {
                  setState(() {});
                }
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sobre o App"),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close),
            ),
          ],
        ),
        content: SingleChildScrollView(child: Text(aboutText)),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    Color? color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? AppColors.lightGreen(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary(context).withOpacity(0.1),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: AppColors.background(context),
        child: Icon(icon, color: AppColors.primaryStrong(context)),
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColors.textPrimary(context)),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: CircleAvatar(
        backgroundColor: AppColors.background(context),
        child: Icon(icon, color: AppColors.secondaryStrong(context)),
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColors.textPrimary(context)),
      ),
      value: value,
      activeColor: AppColors.primaryStrong(context),
      onChanged: onChanged,
    );
  }

  Widget _socialIcon(String assetPath, String url) {
    return InkWell(
      onTap: () => launchUrlString(url),
      child: Image.asset(assetPath, width: 40, height: 40),
    );
  }

  Widget _styledPasswordField(
    BuildContext context,
    TextEditingController controller, {
    required String label,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryStrong(context),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
