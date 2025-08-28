import 'package:doggzi/pages/add_pet_page.dart';
import 'package:doggzi/pages/login_page.dart';
import 'package:doggzi/pages/pet_list_page.dart';
import 'package:doggzi/pages/register_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const pets = '/pets';
  static const addPet = '/pets/add';

  static String get initial => login;

  static final pages = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: pets, page: () => const PetListPage()),
    GetPage(name: addPet, page: () => const AddPetPage()),
  ];
}
