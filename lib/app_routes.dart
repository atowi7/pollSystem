import 'package:flutter/material.dart';
import 'package:poll_system/views/create_poll_screen.dart';
import 'package:poll_system/views/home_screen.dart';
import 'package:poll_system/views/login_screen.dart';
import 'package:poll_system/views/signup_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const createpolls = '/createpolls';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    home: (context) => const HomeScreen(),
    createpolls: (context) => const CreatePollScreen(),
  };
  // static final router = GoRouter(routes: [
  //   GoRoute(
  //     path: '/',
  //     builder: (_, __) => LoginScreen(),
  //   ),
  //   GoRoute(
  //     path: signup,
  //     builder: (_, __) => SignUpScreen(),
  //   ),
  //   GoRoute(
  //     path: home,
  //     builder: (_, __) => const HomeScreen(),
  //   ),
  //   GoRoute(
  //     path: home,
  //     builder: (_, __) => CreatePollScreen(),
  //   ),
  // ]);
}
