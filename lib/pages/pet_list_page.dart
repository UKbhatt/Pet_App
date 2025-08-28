import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/pet_controller.dart';
import '../data/api_client.dart';
import '../models/pet.dart';

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

    Future<void> _editDialog(Pet p) async {
      final name = TextEditingController(text: p.name);
      final type = TextEditingController(text: p.type);
      final age  = TextEditingController(text: p.age.toString());
      final notes= TextEditingController(text: p.notes);

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (sheetCtx) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 16,
            left: 16, right: 16, top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit Pet', style: Theme.of(sheetCtx).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetCtx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final a = int.tryParse(age.text.trim());
                        if (name.text.trim().isEmpty ||
                            type.text.trim().isEmpty ||
                            a == null || a < 0) {
                          Get.snackbar('Validation', 'Fill name/type and valid age');
                          return;
                        }
                        Navigator.pop(sheetCtx);
                        pets.editPet(
                          p,
                          name: name.text.trim(),
                          type: type.text.trim(),
                          age: a,
                          notes: notes.text.trim(),
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }

    Future<void> _tapMenu(Pet p) async {
      final choice = await showModalBottomSheet<String>(
        context: context,
        builder: (sheetCtx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () => Navigator.pop(sheetCtx, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () => Navigator.pop(sheetCtx, 'delete'),
              ),
              const Divider(height: 0),
              ListTile(
                title: const Center(child: Text('Cancel')),
                onTap: () => Navigator.pop(sheetCtx, 'cancel'),
              ),
            ],
          ),
        ),
      );

      if (choice == 'edit') {
        await _editDialog(p);
      } else if (choice == 'delete') {
        final ok = await showDialog<bool>(
          context: context,
          builder: (dCtx) => AlertDialog(
            title: const Text('Delete pet?'),
            content: Text('Remove "${p.name}" permanently?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dCtx, false), child: const Text('No')),
              FilledButton(onPressed: () => Navigator.pop(dCtx, true), child: const Text('Yes')),
            ],
          ),
        );
        if (ok == true) await pets.deletePet(p.id);
      }
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
        final token = ApiClient.authToken();

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: pets.pets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final p = pets.pets[i];
            final url = fullUrl(p.photoUrl);
            final img = (url != null)
                ? NetworkImage(url, headers: token != null ? {'Authorization': 'Bearer $token'} : null)
                : null;

            return Dismissible(
              key: ValueKey(p.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (dCtx) => AlertDialog(
                    title: const Text('Delete pet?'),
                    content: Text('Remove "${p.name}" permanently?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dCtx, false), child: const Text('No')),
                      FilledButton(onPressed: () => Navigator.pop(dCtx, true), child: const Text('Yes')),
                    ],
                  ),
                );
              },
              onDismissed: (_) => pets.deletePet(p.id),
              child: Card(
                child: ListTile(
                  onTap: () => _tapMenu(p),
                  leading: img != null
                      ? CircleAvatar(backgroundImage: img)
                      : CircleAvatar(child: Text(p.name[0].toUpperCase())),
                  title: Text('${p.name} • ${p.type}'),
                  subtitle: Text('Age: ${p.age}\n${p.notes.isEmpty ? "—" : p.notes}'),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                        onPressed: () => _editDialog(p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              title: const Text('Delete pet?'),
                              content: Text('Remove "${p.name}" permanently?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(dCtx, false), child: const Text('No')),
                                FilledButton(onPressed: () => Navigator.pop(dCtx, true), child: const Text('Yes')),
                              ],
                            ),
                          );
                          if (ok == true) await pets.deletePet(p.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
