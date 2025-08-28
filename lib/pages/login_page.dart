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
  final c = Get.find<AuthController>();
  final RegExp _emailRe =
  RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');

  String? _emailError;
  bool _hidePassword = true;

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
    c.login(e, p);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW =
            constraints.maxWidth < 480 ? constraints.maxWidth - 32 : 480.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                24,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Obx(
                            () => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Welcome back',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                    Text('Sign in to continue',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                            color: theme
                                                .colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                            const SizedBox(height: 16),
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
                              label: 'Password',
                              controller: password,
                              obscure: _hidePassword,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: Icon(_hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                label: Text(_hidePassword
                                    ? 'Show password'
                                    : 'Hide password'),
                                onPressed: () =>
                                    setState(() => _hidePassword = !_hidePassword),
                              ),
                            ),

                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: c.loading.value ? null : _submit,
                                icon: const Icon(Icons.login),
                                label: c.loading.value
                                    ? const Text('Please wait...')
                                    : const Text('Log in'),
                              ),
                            ),

                            const SizedBox(height: 8),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No account?',
                                    style: theme.textTheme.bodyMedium),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(AppRoutes.register),
                                  child: const Text('Register'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
