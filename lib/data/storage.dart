import 'package:get_storage/get_storage.dart';

const _kBox = 'app_box';
const _kToken = 'token';

late GetStorage _box;

Future<void> initStorage() async {
  await GetStorage.init(_kBox);
  _box = GetStorage(_kBox);
}

String? readToken() => _box.read<String>(_kToken);
Future<void> writeToken(String token) async => _box.write(_kToken, token);
Future<void> clearToken() async => _box.remove(_kToken);
