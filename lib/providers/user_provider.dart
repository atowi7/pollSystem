import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_system/models/user_model.dart';
import 'package:poll_system/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool checkUserAuth() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? true : false;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userModel = await _userService.login(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.code;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userModel = await _userService.signup(email, password, displayName);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.code;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _userService.logout();
    _userModel = null;
    notifyListeners();
  }
}
