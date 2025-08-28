import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/pet_controller.dart';
import '../data/api_client.dart';

class PetListPage extends StatelessWidget {
  const PetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final pets = Get.put(PetController());

    String? fullUrl(String? path) {
      if (path == null || path.isEmpty) return null;
      if (path.startsWith('http')) return path;
      return '${ApiClient.baseUrl}$path';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Pets'),
        actions: [
          IconButton(onPressed: () => Get.toNamed('/pets/add'), icon: const Icon(Icons.add)),
          IconButton(onPressed: () => pets.fetchPets(), icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () => auth.logout(), icon: const Icon(Icons.logout)),
        ],
      ),
      body: Obx(() {
        if (pets.loading.value) return const Center(child: CircularProgressIndicator());
        if (pets.pets.isEmpty) return const Center(child: Text('No pets yet. Tap + to add.'));
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: pets.pets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final p = pets.pets[i];
            final url = fullUrl(p.photoUrl);
            return Card(
              child: ListTile(
                leading: url != null
                    ? CircleAvatar(backgroundImage: NetworkImage(url))
                    : CircleAvatar(child: Text(p.name[0].toUpperCase())),
                title: Text('${p.name} • ${p.type}'),
                subtitle: Text('Age: ${p.age}\n${p.notes.isEmpty ? "—" : p.notes}'),
              ),
            );
          },
        );
      }),
    );
  }
}
