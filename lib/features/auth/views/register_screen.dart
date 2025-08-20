import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sl/model/user_model.dart';
import 'package:sl/routes/app_routes.dart';
import 'package:sl/shared/app_colors.dart';
import 'package:sl/widgets/inputs/my_text_field.dart';
import 'package:sl/widgets/toast/my_toast.dart';

import '../../../shared/typography.dart';
import '../../../widgets/buttons/my_button.dart';
import '../controller/auth_controller.dart';

enum GenderEnum { male, female }

class RegisterScreen extends StatefulWidget {
  final String mobile;
  const RegisterScreen({super.key, required this.mobile});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 0;
  final redColor = const Color(0xFFB10606);
  GenderEnum genderGroup = GenderEnum.male;
  final _picker = ImagePicker();

  final AuthController controller = Get.put(AuthController());

  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Text controllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController();
  final aadharNumberController = TextEditingController();
  final panNumberController = TextEditingController();

  XFile? aadharFrontImage;
  XFile? aadharBackImage;
  XFile? panFrontImage;
  XFile? panBackImage;
  void nextStep() async {
    if (_formKeys[currentStep].currentState?.validate() ?? false) {
      // Additional validation for document step
      if (currentStep == 2) {
        // Validate Aadhar details
        if (aadharNumberController.text.isEmpty) {
          MyToasts.toastError("Please enter Aadhar number");
          return;
        }
        if (aadharFrontImage == null) {
          MyToasts.toastError("Please upload Aadhar front image");
          return;
        }
        if (aadharBackImage == null) {
          MyToasts.toastError("Please upload Aadhar back image");
          return;
        }

        // Validate PAN details
        if (panNumberController.text.isEmpty) {
          MyToasts.toastError("Please enter PAN number");
          return;
        }
        if (panFrontImage == null) {
          MyToasts.toastError("Please upload PAN front image");
          return;
        }
      }

      if (currentStep < 2) {
        setState(() => currentStep++);
      } else {
        try {
          final user = UserModel(
            firstname: firstNameController.text,
            middlename: middleNameController.text,
            lastname: lastNameController.text,
            gender: genderGroup.name.capitalizeFirst,
            dob: null,
            mobile: int.tryParse(mobileController.text),
            email: emailController.text,
            address1: address1Controller.text,
            address2: address2Controller.text,
            address3: address3Controller.text,
            state: stateController.text,
            city: cityController.text,
            pincode: pincodeController.text,
            country: countryController.text,
            role: "customer",
            aadhar: {
              'number': aadharNumberController.text,
              'images': [aadharFrontImage, aadharBackImage],
            },
            pan: {
              'number': panNumberController.text,
              'images': [panFrontImage, panBackImage],
            },
            isVerified: true,
            isDeleted: false,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );

          await controller
              .register(user)
              .then((value) {
                if (value && mounted) context.go(AppRoutes.login);
              })
              .catchError((e) {
                MyToasts.toastError(e.toString());
              });
        } catch (e) {
          MyToasts.toastError("An error occurred: ${e.toString()}");
        }
      }
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Widget stepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: currentStep >= index
                  ? AppColors.kcPrimaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    emailController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    stateController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    countryController.dispose();
    aadharNumberController.dispose();
    panNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    mobileController.text = widget.mobile;
    super.initState();
  }

  Future<void> pickImage(String documentType, bool isFront) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Image Source', style: AppTypography.heading5()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickImageFromSource(
                        documentType,
                        isFront,
                        ImageSource.camera,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.kcPrimaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: AppColors.kcPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Camera', style: AppTypography.bodyMedium()),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickImageFromSource(
                        documentType,
                        isFront,
                        ImageSource.gallery,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.kcPrimaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            size: 40,
                            color: AppColors.kcPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Gallery', style: AppTypography.bodyMedium()),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(
    String documentType,
    bool isFront,
    ImageSource source,
  ) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (documentType == 'aadhar') {
            if (isFront) {
              aadharFrontImage = image;
            } else {
              aadharBackImage = image;
            }
          } else if (documentType == 'pan') {
            if (isFront) {
              panFrontImage = image;
            } else {
              panBackImage = image;
            }
          }
        });
      }
    } catch (e) {
      MyToasts.toastError('Failed to pick image: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      buildPersonalDetailsForm(),
      buildAddressDetailsForm(),
      buildDocumentDetailsForm(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
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
                    onPressed: prevStep,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Create a New Account",
                  style: AppTypography.heading4(color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                currentStep == 0
                    ? "Personal Details"
                    : currentStep == 1
                    ? "Address Details"
                    : "Document Details",
                style: AppTypography.bodyLarge(),
              ),
              const SizedBox(height: 5),
              Text(
                currentStep == 0
                    ? "Step 1/3"
                    : currentStep == 1
                    ? "Step 2/3"
                    : "Step 3/3",
                style: AppTypography.bodySmall(color: Color(0xFF747474)),
              ),
              const SizedBox(height: 10),
              stepIndicator(),
              const SizedBox(height: 20),
              Expanded(
                child: Form(
                  key: _formKeys[currentStep],
                  child: screens[currentStep],
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                text: currentStep == 2 ? "Submit" : "Next",
                onPressed: () async {
                  nextStep();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    VoidCallback? onTap,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyTextField(
        controller: controller,
        hintText: hint,
        labelText: label,
        textInputType: type,
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
        onTap: onTap,
        maxLength: maxLength,
      ),
    );
  }

  Widget buildPersonalDetailsForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextField("First Name", "Ex. ABC", firstNameController),
          buildTextField("Middle Name", "Ex. Kumar", middleNameController),
          buildTextField("Last Name", "Ex. SL Chemicals", lastNameController),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Gender:", style: AppTypography.bodyMedium()),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/icons/GendeMale.png"),
                        Text("Male", style: AppTypography.bodyMedium()),
                        Radio(
                          value: GenderEnum.male,
                          activeColor: AppColors.kcPrimaryColor,
                          groupValue: genderGroup,
                          onChanged: (val) {
                            setState(() {
                              genderGroup = val!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/icons/Gendeemale.png"),
                        Text("Female", style: AppTypography.bodyMedium()),
                        Radio(
                          value: GenderEnum.female,
                          activeColor: AppColors.kcPrimaryColor,
                          groupValue: genderGroup,
                          onChanged: (val) {
                            setState(() {
                              genderGroup = val!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          buildTextField(
            "Date of Birth",
            "Ex. 14 Aug, 1995",
            dobController,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  dobController.text = DateFormat(
                    "dd MMM, yyyy",
                  ).format(selectedDate);
                }
              });
            },
          ),
          buildTextField(
            "Phone Number",
            "Ex. +91 9876543210",
            mobileController,
            type: TextInputType.phone,
            maxLength: 10,
          ),
          buildTextField(
            "Email Address",
            "example@gmail.com",
            emailController,
            type: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget buildAddressDetailsForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTextField(
            "Address Line 1",
            "Ex. 53 Brentwood Drive",
            address1Controller,
          ),
          buildTextField(
            "Address Line 2",
            "Ex. Queensland(Q), 81 Duff Street",
            address2Controller,
          ),
          buildTextField(
            "Address Line 3",
            "Ex. 81 Duff Street.",
            address3Controller,
          ),
          buildTextField("State", "Ex. Haryana", stateController),
          buildTextField("City", "Ex. Faridabad", cityController),
          buildTextField(
            "Post Code",
            "000000",
            pincodeController,
            type: TextInputType.number,
            maxLength: 6,
          ),
          buildTextField("Country", "Ex. India", countryController),
        ],
      ),
    );
  }

  Widget buildDocumentDetailsForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Aadhar Card Section
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.credit_card, color: AppColors.kcPrimaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Aadhar Card Details",
                      style: AppTypography.bodyLarge(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildTextField(
                  "Aadhar Number",
                  "Ex. 123456789012",
                  aadharNumberController,
                  type: TextInputType.number,
                  maxLength: 12,
                ),
                const SizedBox(height: 8),
                Text(
                  "Upload Aadhar Front Image",
                  style: AppTypography.bodyMedium(),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => pickImage('aadhar', true),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: aadharFrontImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload image',
                                style: AppTypography.bodyMedium(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(aadharFrontImage!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Upload Aadhar Back Image",
                  style: AppTypography.bodyMedium(),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => pickImage('aadhar', false),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: aadharBackImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload image',
                                style: AppTypography.bodyMedium(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(aadharBackImage!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),

          // PAN Card Section
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment_ind, color: AppColors.kcPrimaryColor),
                    const SizedBox(width: 8),
                    Text("PAN Card Details", style: AppTypography.bodyLarge()),
                  ],
                ),
                const SizedBox(height: 16),
                buildTextField(
                  "PAN Number",
                  "Ex. XXXXX3256X",
                  panNumberController,
                  type: TextInputType.text,
                  maxLength: 10,
                ),
                const SizedBox(height: 8),
                Text(
                  "Upload PAN Front Image",
                  style: AppTypography.bodyMedium(),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => pickImage('pan', true),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: panFrontImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload image',
                                style: AppTypography.bodyMedium(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(panFrontImage!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Upload PAN Back Image",
                  style: AppTypography.bodyMedium(),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => pickImage('pan', false),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: panBackImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload image',
                                style: AppTypography.bodyMedium(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(panBackImage!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
