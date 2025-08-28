import 'package:get/get.dart';
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

  Future<void> addPet(String name, String type, int age, String notes) async {
    try {
      loading.value = true;
      final pet = await _svc.addPet(name, type, age, notes);
      _pets.insert(0, pet);
      Get.back(); // close add page
      Get.snackbar('Success', 'Pet added');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }
}
