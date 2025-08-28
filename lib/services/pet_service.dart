import '../data/api_client.dart';
import '../models/pet.dart';

class PetService {
  Future<List<Pet>> listPets() async {
    final data = await ApiClient.get('/pets', auth: true) as List<dynamic>;
    return data.map((e) => Pet.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Pet> addPet(String name, String type, int age, String notes) async {
    final j = await ApiClient.post('/pets', {"name": name, "type": type, "age": age, "notes": notes}, auth: true)
    as Map<String, dynamic>;
    return Pet.fromJson(j);
  }
}
