import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/app_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final c = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
                  AppInput(label: 'Email', controller: email, type: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  AppInput(label: 'Password (min 6)', controller: password, obscure: true),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: c.loading.value ? null : () {
                        if (email.text.isEmpty || password.text.length < 6) {
                          Get.snackbar('Validation', 'Enter email & 6+ char password');
                          return;
                        }
                        c.register(email.text.trim(), password.text);
                      },
                      icon: const Icon(Icons.person_add),
                      label: c.loading.value ? const Text('Please wait...') : const Text('Create account'),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
