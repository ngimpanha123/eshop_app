
import 'package:get/get.dart';
import 'package:pos/app/services/storage_service.dart';

import 'data/providers/api_provider.dart';


class DependencyInjection {
  static Future<void> init() async {
    // Initialize StorageService first
    await Get.putAsync(() => StorageService().init(), permanent: true);
    
    // Then initialize API provider
    Get.put(APIProvider(), permanent: true);
  }
}