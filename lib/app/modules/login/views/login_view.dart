import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: "0963919745");
  final emailController = TextEditingController();
  final passwordController = TextEditingController(text: "123456");
  LoginView({super.key});
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
                "Login",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Please Login to continue ",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.withOpacity(0.8),
                ),
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
              // TextFormField(
              //   controller: emailController,
              //   decoration: InputDecoration(
              //     hintText: "Username",
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter your email";
              //     }
              //
              //     if(!GetUtils.isEmail(value)){
              //       return "Enter valid email";
              //     }
              //   },
              // ),
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
                      final username = nameController.text;
                      final password = passwordController.text;
                      final platform = "Mobile".toString();
                      controller.login(username: username, password: password, platform: platform);
                    }
                  }, child: Text("Login"))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account"),
                  TextButton(onPressed: () {
                    Get.toNamed(Routes.REGISTER);
                  }, child: Text("Register"))
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
