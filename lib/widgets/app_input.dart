import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? type;

  const AppInput({super.key, required this.label, required this.controller, this.obscure=false, this.type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
    );
  }
}
