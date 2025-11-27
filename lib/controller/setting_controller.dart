import 'package:flutter/material.dart';
import 'package:tcc_project/services/auth_service.dart';

class SettingController extends ChangeNotifier {
  final AuthService authService;

  bool darkMode = false;
  bool notifications = true;

  String? passwordError;
  bool loading = false;

  SettingController({required this.authService});

  // Switches
  void toggleDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    notifications = value;
    notifyListeners();
  }

  // Troca de senha
  Future<bool> changePassword(String atual, String nova) async {
    loading = true;
    passwordError = null;
    notifyListeners();

    try {
      await authService.changePassword(atual, nova);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      passwordError = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await authService.logout();
  }
}
