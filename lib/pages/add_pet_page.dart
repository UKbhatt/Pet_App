import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pet_controller.dart';
import '../widgets/app_input.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});
  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final name = TextEditingController();
  final type = TextEditingController();
  final age = TextEditingController(text: '0');
  final notes = TextEditingController();
  final c = Get.find<PetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
          children: [
            AppInput(label: 'Name', controller: name),
            const SizedBox(height: 12),
            AppInput(label: 'Type (e.g., dog/cat)', controller: type),
            const SizedBox(height: 12),
            AppInput(label: 'Age', controller: age, type: TextInputType.number),
            const SizedBox(height: 12),
            AppInput(label: 'Notes', controller: notes),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: c.loading.value ? null : () {
                  if (name.text.trim().isEmpty || type.text.trim().isEmpty) {
                    Get.snackbar('Validation', 'Name and Type are required');
                    return;
                  }
                  final ageVal = int.tryParse(age.text) ?? 0;
                  if (ageVal < 0) {
                    Get.snackbar('Validation', 'Age must be >= 0');
                    return;
                  }
                  c.addPet(name.text.trim(), type.text.trim(), ageVal, notes.text.trim());
                },
                icon: const Icon(Icons.check),
                label: c.loading.value ? const Text('Saving...') : const Text('Save'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
