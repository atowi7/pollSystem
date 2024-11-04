import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_system/app_routes.dart';
import 'package:poll_system/models/user_model.dart';
import 'package:poll_system/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  final _loginFormKey = GlobalKey<FormState>(); // Form key for login screen
  final _signupFormKey = GlobalKey<FormState>(); // Form key for signup screen
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  GlobalKey<FormState> get signupFormKey => _signupFormKey;
  TextEditingController get displayNameController => _displayNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool checkUserAuth() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? true : false;
  }

  String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a user name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();

      try {
        _userModel = await _userService.login(
            _emailController.text, _passwordController.text);

        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      } on FirebaseAuthException catch (e) {
        // print(e.code);

        switch (e.code) {
          case 'user-not-found':
            _errorMessage = 'No user found with that email.';
            break;
          case 'wrong-password':
            _errorMessage = 'Incorrect password.';
            break;
          default:
            _errorMessage =
                'something went wrong please check your email or password.';
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.white70,
              duration: const Duration(seconds: 1),
              content: Text(
                '$_errorMessage',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              )));
        }
      } finally {
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      }
    }
  }

  Future<void> signup(BuildContext context) async {
    if (_signupFormKey.currentState!.validate()) {
      _isLoading = true;
      notifyListeners();

      try {
        _userModel = await _userService.signup(_emailController.text,
            _passwordController.text, _displayNameController.text);

        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      } on FirebaseAuthException catch (e) {
        // print(e.code);

        switch (e.code) {
          case 'weak-password':
            _errorMessage = 'Try stronger password.';
            break;
          case 'email-already-in-use':
            _errorMessage = 'The email is already in use.';
            break;
          default:
            _errorMessage = 'something went wrong please check your data.';
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.white70,
              duration: const Duration(seconds: 1),
              content: Text(
                '$_errorMessage',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              )));
        }
      } finally {
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      }
    }
  }

  Future<void> logout() async {
    displayNameController.clear();
    emailController.clear();
    passwordController.clear();

    await _userService.logout();
    _userModel = null;
    notifyListeners();
  }
}
