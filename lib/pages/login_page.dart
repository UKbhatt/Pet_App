import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/app_input.dart';
import '../routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final c = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Welcome', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  AppInput(label: 'Email', controller: email, type: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  AppInput(label: 'Password', controller: password, obscure: true),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: c.loading.value ? null : () {
                        if (email.text.isEmpty || password.text.length < 6) {
                          Get.snackbar('Validation', 'Enter email & 6+ char password');
                          return;
                        }
                        c.login(email.text.trim(), password.text);
                      },
                      icon: const Icon(Icons.login),
                      label: c.loading.value ? const Text('Please wait...') : const Text('Log in'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    child: const Text('No account? Register'),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
