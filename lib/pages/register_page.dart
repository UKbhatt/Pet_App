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

  final RegExp _emailRe =
  RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');

  String? _emailError;

  @override
  void initState() {
    super.initState();
    email.addListener(() {
      if (_emailError != null && _emailRe.hasMatch(email.text.trim())) {
        setState(() => _emailError = null);
      }
    });
  }

  void _submit() {
    final e = email.text.trim();
    final p = password.text;

    if (e.isEmpty || p.length < 6) {
      Get.snackbar('Validation', 'Enter email & 6+ char password');
      return;
    }
    if (!_emailRe.hasMatch(e)) {
      setState(() => _emailError = 'Please enter a valid email address');
      Get.snackbar('Invalid email', 'Please enter a valid email address');
      return;
    }
    c.register(e, p);
  }

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
                  AppInput(
                    label: 'Email',
                    controller: email,
                    type: TextInputType.emailAddress,
                  ),
                  if (_emailError != null) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  AppInput(
                    label: 'Password (min 6)',
                    controller: password,
                    obscure: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: c.loading.value ? null : _submit,
                      icon: const Icon(Icons.person_add),
                      label: c.loading.value
                          ? const Text('Please wait...')
                          : const Text('Create account'),
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
