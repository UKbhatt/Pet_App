import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  final picker = ImagePicker();
  XFile? image;

  Future<void> pickImage() async {
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x != null) setState(() => image = x);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Pet')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxW = constraints.maxWidth < 520
                ? (constraints.maxWidth - 32).clamp(280, 520)
                : 520;

            return Obx(() => SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                24,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW.toDouble()),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AppInput(label: 'Name', controller: name),
                          const SizedBox(height: 12),
                          AppInput(label: 'Type (e.g., dog/cat)', controller: type),
                          const SizedBox(height: 12),
                          AppInput(label: 'Age', controller: age, type: TextInputType.number),
                          const SizedBox(height: 12),
                          AppInput(label: 'Notes', controller: notes),
                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: c.loading.value ? null : pickImage,
                                icon: const Icon(Icons.photo),
                                label: const Text('Add photo (optional)'),
                              ),
                              if (image != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(image!.path),
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: c.loading.value
                                  ? null
                                  : () {
                                if (name.text.trim().isEmpty || type.text.trim().isEmpty) {
                                  Get.snackbar('Validation', 'Name and Type are required');
                                  return;
                                }
                                final ageVal = int.tryParse(age.text) ?? 0;
                                if (ageVal < 0) {
                                  Get.snackbar('Validation', 'Age must be >= 0');
                                  return;
                                }
                                c.addPet(
                                  name.text.trim(),
                                  type.text.trim(),
                                  ageVal,
                                  notes.text.trim(),
                                  image: image,
                                );
                              },
                              icon: const Icon(Icons.check),
                              label: c.loading.value
                                  ? const Text('Saving...')
                                  : const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}
