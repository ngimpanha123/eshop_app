
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  final _box = GetStorage();


  // set token
  static Future<void> write(
  {required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(
  {required String key}) async {
    return await _storage.read(key: key);
  }
  
  static Future<void> delete(
  {required String key}) async {
    await _storage.delete(key: key);
  }

  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  void saveToken(String token) => _box.write('token', token);
  String? readToken() => _box.read('token');
  void clearToken() => _box.remove('token');

}

