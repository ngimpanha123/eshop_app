import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/dependency_injection.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(
    GetMaterialApp(
      title: "POS Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
