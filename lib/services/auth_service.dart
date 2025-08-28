import '../data/api_client.dart';

class AuthService {
  Future<Map<String, dynamic>> register(String email, String password) async {
    return await ApiClient.post('/auth/register', {"email": email, "password": password});
  }

  Future<String> login(String email, String password) async {
    final res = await ApiClient.post('/auth/login', {"email": email, "password": password});
    return res['token'] as String;
  }
}
