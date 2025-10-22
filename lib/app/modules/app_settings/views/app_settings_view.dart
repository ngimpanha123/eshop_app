import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/app_settings_controller.dart';

class AppSettingsView extends GetView<AppSettingsController> {
  const AppSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppSettingsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AppSettingsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
