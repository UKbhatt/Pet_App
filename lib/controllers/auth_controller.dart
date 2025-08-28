import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../data/storage.dart';
import '../routes.dart';

class AuthController extends GetxController {
  final _auth = AuthService();
  var loading = false.obs;

  Future<void> register(String email, String password) async {
    try {
      loading.value = true;
      await _auth.register(email, password);
      Get.snackbar('Success', 'Registered, please log in');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      loading.value = true;
      final token = await _auth.login(email, password);
      await writeToken(token);
      Get.offAllNamed(AppRoutes.pets);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    await clearToken();
    Get.offAllNamed(AppRoutes.login);
  }
}
