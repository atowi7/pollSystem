import 'package:flutter/material.dart';
import 'package:poll_system/app_routes.dart';
import 'package:poll_system/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: userProvider.signupFormKey,
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
                TextFormField(
                  controller: userProvider.displayNameController,
                  validator: (value) => userProvider.validateDisplayName(value),
                  decoration: InputDecoration(
                      hintText: "User Name",
                      hintStyle: Theme.of(context).textTheme.displayMedium,
                      labelText: "User Name",
                      labelStyle: Theme.of(context).textTheme.displayMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      fillColor: Colors.blue.withOpacity(0.4),
                      filled: true),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: userProvider.emailController,
                  validator: (value) => userProvider.validateEmail(value),
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
                TextFormField(
                  controller: userProvider.passwordController,
                  validator: (value) => userProvider.validatePassword(value),
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
                userProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          await userProvider.signup(context);
                        },
                        style: ElevatedButton.styleFrom(
                          // shape: const CircleBorder(),
                          backgroundColor: Colors.blue,
                          // padding: const EdgeInsets.symmetric(horizontal: 16)
                        ),
                        child: Text(
                          "SignUp",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                // if (userProvider.errorMessage != null)
                //   Text(userProvider.errorMessage!,
                //       style: Theme.of(context).textTheme.displaySmall!.copyWith(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.red)),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Text("Already have an account? Login",
                        style: Theme.of(context).textTheme.displaySmall))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
