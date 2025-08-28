import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes.dart';
import 'data/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStorage();
  runApp(const PetsApp());
}

class PetsApp extends StatelessWidget {
  const PetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);
    return GetMaterialApp(
      title: 'Pets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.pages,
    );
  }
}
