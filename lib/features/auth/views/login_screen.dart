import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/shared/app_colors.dart';
import 'package:sl/widgets/buttons/my_button.dart';
import 'package:sl/widgets/inputs/my_text_field.dart';

import '../../../routes/app_routes.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AuthController controller = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Form(
        key: _formKey,
        child: SafeArea(
          bottom: false,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFFFF3F2),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Login with Mobile Number",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Please enter your Mobile Number to Login",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    controller: phoneController,
                    hintText: "Ex.+912345263785",
                    labelText: "Mobile Number",
                    maxLength: 10,
                    textInputType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Mobile number is required";
                      }
                      if (value.length != 10) {
                        return "Mobile number should be 10 digits long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    text: "Login",
                    borderRadius: BorderRadius.circular(8),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final result = await controller.sendOTP(
                          phoneController.text,
                        );
                        if (result != null) {
                          
                          context.push(AppRoutes.otpVerification);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.register),
                      child: const Text.rich(
                        TextSpan(
                          text: "Not Registered? ",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                color: AppColors.kcPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
