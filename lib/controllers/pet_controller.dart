import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class PetController extends GetxController {
  final _pets = <Pet>[].obs;
  final _svc = PetService();
  var loading = false.obs;

  List<Pet> get pets => _pets;

  @override
  void onInit() {
    super.onInit();
    fetchPets();
  }

  Future<void> fetchPets() async {
    try {
      loading.value = true;
      _pets.assignAll(await _svc.listPets());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> addPet(String name, String type, int age, String notes, {XFile? image}) async {
    try {
      loading.value = true;
      final created = await _svc.addPet(name, type, age, notes);
      Pet finalPet = created;
      if (image != null) {
        finalPet = await _svc.uploadPhoto(created.id, image);
      }
      _pets.insert(0, finalPet);
      Get.back();
      Get.snackbar('Success', 'Pet added');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> editPet(Pet pet, {String? name, String? type, int? age, String? notes}) async {
    try {
      loading.value = true;
      final updated = await _svc.updatePet(pet.id, name: name, type: type, age: age, notes: notes);
      final idx = _pets.indexWhere((p) => p.id == pet.id);
      if (idx != -1) _pets[idx] = updated;
      Get.snackbar('Updated', '${updated.name} saved');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> deletePet(String id) async {
    try {
      await _svc.deletePet(id);
      _pets.removeWhere((p) => p.id == id);
      Get.snackbar('Deleted', 'Pet removed');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
