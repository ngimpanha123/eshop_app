import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                  "Sign Up",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Sign up to continue buy your favorite product",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                (){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            backgroundImage: controller.photo.value != null
                                ? FileImage(controller.photo.value!)
                                : null,
                            child: controller.photo.value == null
                                ? Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                          IconButton(onPressed: controller.pickImage, icon: Icon(Icons.camera_alt)),
                        ],
                      ),
                    ],
                  );
                }
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }

                  if(!GetUtils.isEmail(value)){
                    return "Enter valid email";
                  }
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.offAllNamed(
                          Routes.LOGIN);
                    }
                  }, child: Text("Rigsiter"))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account"),
                  TextButton(onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  }, child: Text("Login"))
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
