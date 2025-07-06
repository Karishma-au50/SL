import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/shared/app_colors.dart';
import 'package:sl/widgets/buttons/my_button.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/utils/hex_color.dart';
import 'package:pinput/pinput.dart';

import '../../home/api/dashboard_services.dart';
import '../controller/auth_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? mobile;
  final int? otp;
  const OtpVerificationScreen({
    super.key,
    this.mobile,
    this.otp,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  late Timer _timer;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  int _start = 59;
  bool isPinValid = false;
  final AuthController controller = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _start--;
          });
        }
      }
    });

    @override
    void dispose() {
      if (_timer.isActive) {
        _timer.cancel();
      }
      _otpController.dispose();
      pinController.dispose();
      focusNode.dispose();
      super.dispose();
    }

  }

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = HexColor("#212B36");
    final fillColor = Colors.grey.shade300;
    final borderColor = HexColor("#212B36");

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    void handleOTPCompletion(String otp) {
      if (otp == '${widget.otp}') {
        setState(() {
          isPinValid = true;
        });
        FirebaseMessaging.instance.getToken().then((token) {
          print('Token: $token');
          try {
            DashboardService().updateDeviceToken(token!);
          } catch (e) {
            print(e);
          }
        });
        // Automatically navigate after OTP is verified
        // if (widget.isRegistered!) {
        //   context.go(AppRoutes.home);
        // } else {
          // context.push(
          //   AppRoutes.register,
          //   extra: {
          //     "mobile": widget.mobile,
          //     "isRegistered": widget.isRegistered
          //   },
          // );
        // }
      } else {
        setState(() {
          isPinValid = false;
        });
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // const SizedBox(height: 60),

            // White Bottom Section
            Expanded(
              child: Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
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
                      // const SizedBox(height: 20),
                      const SizedBox(height: 10),

                      // OTP Image Placeholder
                      CircleAvatar(
                        radius: 50,
                        // ignore: deprecated_member_use
                        backgroundColor: AppColors.backgroundColor.withOpacity(
                          0.1,
                        ),
                        child: const Icon(
                          Icons.email_outlined,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text(
                          'OTP Verification',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text(
                          'Enter your 4 digit verification code sent to your email',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // OTP Input
                      Pinput(
                        controller: pinController,
                        focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 8),
                        // validator: (value) {
                        //   setState(() {
                        //     isPinValid = value == '${widget.otp}';
                        //   });
                        //   return isPinValid ? null : 'Pin is incorrect';
                        // },
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 22,
                              height: 1,
                              color: focusedBorderColor,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                       onCompleted: handleOTPCompletion,
                      ),

                   
                      const SizedBox(height: 30),

                      // Verify Button
                      MyButton(
                        text: "Verify Now",
                        borderRadius: BorderRadius.circular(8),
                        disabled: !isPinValid,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            controller.verifyOtp(widget.mobile!, pinController.text)
                                .then((value) {
                                  context.push(AppRoutes.home);
                              // final int? otp = value['otp'];
                              // final bool? isRegistered = value['isRegistered'];
                              // context.push(
                              //   AppRoutes.otpVerification,
                              //   extra: {
                              //     "mobile": widget.mobile,
                              //     "otp": otp,
                              //     // "isRegistered": isRegistered,
                              //   },
                              // );
                            });
                            // FirebaseMessaging.instance.getToken().then((token) {
                            //   print('Token: $token');
                            //   try {
                            //     DashboardService().updateDeviceToken(token!);
                            //   } catch (e) {
                            //     print(e);
                            //   }
                            // });
                            // if (widget.isRegistered!) {
                            //   context.go(AppRoutes.home);
                            // } else {
                              // context.push(
                              //   AppRoutes.register,
                              //   extra: {
                              //     "mobile": widget.mobile,
                              //     "isRegistered": widget.isRegistered,
                              //   },
                              // );
                            // }
                          }
                        },
                      ),
                    

                      const SizedBox(height: 30),

                      // Resend OTP
                      Text(
                        "Didn't receive the Code?",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: _start == 0 ? () => startTimer() : null,
                        child: Text(
                          _start == 0
                              ? "Resend OTP"
                              : "Resend OTP 00:${_start.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: AppColors.kcPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
