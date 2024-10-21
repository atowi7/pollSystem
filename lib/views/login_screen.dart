import 'package:flutter/material.dart';
import 'package:poll_system/app_routes.dart';
import 'package:poll_system/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outlined,
                color: Colors.blue,
                size: 100,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: Theme.of(context).textTheme.displayMedium,
                    labelText: "Email",
                    labelStyle: Theme.of(context).textTheme.displayMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    fillColor: Colors.blue.withOpacity(0.4),
                    filled: true),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: Theme.of(context).textTheme.displayMedium,
                  labelText: "Password",
                  labelStyle: Theme.of(context).textTheme.displayMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  fillColor: Colors.blue.withOpacity(0.4),
                  filled: true,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              userViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        bool success = await userViewModel.login(
                            _emailController.text, _passwordController.text);
                        if (success) {
                          if (context.mounted) {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.home);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        // shape: const CircleBorder(),
                        backgroundColor: Colors.blue,
                        // padding:
                        //     const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
              if (userViewModel.errorMessage != null)
                Text(userViewModel.errorMessage!,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.red)),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.signup);
                  },
                  child: Text("Don't have an account? SignUp",
                      style: Theme.of(context).textTheme.displaySmall))
            ],
          ),
        ),
      ),
    );
  }
}
