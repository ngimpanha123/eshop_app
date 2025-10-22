import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pos/app/services/storage_service.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';
import 'package:dio/dio.dart';

class LoginController extends GetxController {
  final _api = Get.find<APIProvider>();

  void login({required String username, required String password, required String platform,}) async {
    try {

      final res = await _api.login(username: username, password: password, platform: platform,);

      print("res: $res");
      print("res.statusCode: ${res.statusCode}");
      if (res.statusCode == 200) {
        print("res ${res.data}");
        final token = res.data["token"];
        
        // Save token to GetStorage (not FlutterSecureStorage)
        final storage = Get.find<StorageService>();
        storage.saveToken(token);
        
        Get.offAllNamed(Routes.HOME);
      }else if(res.statusCode == 401){
        Get.defaultDialog(
          title: "Error",
          content: Text(res.data["message"]),
        );
      }
      else {
        Get.defaultDialog(
          title: "Login Failed",
          content: Text("Invalid username or password"),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Error",
        content: Text(e.toString()),
      );
    }
  }
}
