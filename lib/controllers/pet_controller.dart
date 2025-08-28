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
}
