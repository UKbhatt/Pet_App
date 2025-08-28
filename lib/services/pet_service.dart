import '../data/api_client.dart';
import '../models/pet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class PetService {
  Future<List<Pet>> listPets() async {
    final data = await ApiClient.get('/pets', auth: true) as List<dynamic>;
    return data.map((e) => Pet.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Pet> addPet(String name, String type, int age, String notes) async {
    final j = await ApiClient.post('/pets', {"name": name, "type": type, "age": age, "notes": notes}
        , auth: true);
    return Pet.fromJson(j);
  }

  Future<Pet> uploadPhoto(String petId, XFile file) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/pets/$petId/photo');
    final req = http.MultipartRequest('POST', uri);
    final token = ApiClient.authToken();
    if (token != null) req.headers['Authorization'] = 'Bearer $token';

    final mime = file.mimeType ?? 'image/jpeg';
    req.files.add(
      await http.MultipartFile.fromPath('file', file.path, contentType: MediaType.parse(mime)),
    );

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Pet.fromJson(ApiClient.decode(res.body) as Map<String, dynamic>);
    }
    throw Exception(ApiClient.errorFrom(res));
  }

}
