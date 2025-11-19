import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_project/model/usuario.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? usuario;
  bool isLoading = true;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      usuario = user;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> register(
    String email,
    String senha,
    Usuario dadosUsuario,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = cred.user!.uid;
      final data = dadosUsuario.copyWith(id: uid).toMap();

      await _firestore.collection("users").doc(uid).set(data);

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw AuthException('A senha é muito fraca.');
        case 'email-already-in-use':
          throw AuthException('Este email já está cadastrado.');
        default:
          throw AuthException('Erro ao cadastrar: ${e.message}');
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se primeiro.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente.');
      } else {
        throw AuthException('Erro ao fazer login: ${e.message}');
      }
    }
  }

  Future<void> changePassword(String senhaAtual, String novaSenha) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException("Nenhum usuário logado.");

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: senhaAtual,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(novaSenha);

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw AuthException("A senha atual está incorreta.");
      } else if (e.code == 'weak-password') {
        throw AuthException("A nova senha é muito fraca.");
      } else {
        throw AuthException("Erro ao alterar senha: ${e.message}");
      }
    }
  }

  Future<void> updateUserProfile(Usuario dados) async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid == null) throw AuthException("Usuário não encontrado.");

      await _firestore.collection("users").doc(uid).update(dados.toMap());

      notifyListeners();
    } catch (e) {
      throw AuthException("Erro ao atualizar perfil: $e");
    }
  }

  Future<Usuario> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) throw Exception('Usuário não encontrado');
    return Usuario(
      id: uid,
      nome: data['nome'] ?? '',
      cidade: data['cidade'] ?? '',
      estado: data['estado'] ?? '',
      pais: data['pais'] ?? '',
      dataNascimento: data['dataNascimento'] ?? '',
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
