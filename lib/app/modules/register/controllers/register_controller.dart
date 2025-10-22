import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {

  final photo = Rxn<File>(); // allows null safely
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      photo.value = File(image.path); // update reactive variable
    }
  }

}
