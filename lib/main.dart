import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/dependency_injection.dart';
import 'app/routes/app_pages.dart';
import 'app/config/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(
    GetMaterialApp(
      title: "ESHOP Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.light,
    ),
  );
}
