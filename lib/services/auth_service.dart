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
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  register(String email, String senha, Usuario dadosUsuario) async {
    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final usuario = Usuario(
        id: newUser.user?.uid ?? '',
        nome: dadosUsuario.nome,
        dataNascimento: dadosUsuario.dataNascimento,
        pais: dadosUsuario.pais,
        estado: dadosUsuario.estado,
        cidade: dadosUsuario.cidade,
      ).toMap();

      await _firestore.collection('users').doc(newUser.user?.uid).set(usuario);

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado.');
      } else {
        throw AuthException('Erro ao cadastrar: ${e.message}');
      }
    }
  }
  
  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
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

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}