import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sl/model/user_model.dart';
import 'package:sl/routes/app_routes.dart';
import 'package:sl/shared/app_colors.dart';
import 'package:sl/widgets/inputs/my_text_field.dart';

import '../../../widgets/buttons/my_button.dart';
import '../controller/auth_controller.dart';

enum GenderEnum {
  male,
  female
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
   int currentStep = 0;
  final redColor = const Color(0xFFB10606);
  GenderEnum genderGroup = GenderEnum.male;
  final _picker = ImagePicker();
  XFile? frontImage;
  XFile? backImage;

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
  final documentNumberController = TextEditingController();

  String? selectedDocumentType;
void nextStep() async {
    if (_formKeys[currentStep].currentState?.validate() ?? false) {
      if (currentStep < 2) {
        setState(() => currentStep++);
      } else {
        final user = UserModel(
          firstname: firstNameController.text,
          middlename: middleNameController.text,
          lastname: lastNameController.text,
          gender: genderGroup.name,
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
          documentsName: [selectedDocumentType ?? ''],
          documentsDetails: [documentNumberController.text],
          isVerified: true,
          isDeleted: false,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );

        await controller.register(user).then((value) {
          context.push(AppRoutes.home);
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        });
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
              color: currentStep >= index ? AppColors.kcPrimaryColor : Colors.grey.shade300,
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
    documentNumberController.dispose();
    super.dispose();
  }
  // int currentStep = 0;
  // final redColor = const Color(0xFFB10606);
  // GenderEnum genderGroup = GenderEnum.male;
  // AuthController controller = Get.isRegistered<AuthController>()
  //     ? Get.find<AuthController>()
  //     : Get.put(AuthController());

  // final _formKeys = [
  //   GlobalKey<FormState>(),
  //   GlobalKey<FormState>(),
  //   GlobalKey<FormState>(),
  // ];

  // void nextStep() async{
  //   if (_formKeys[currentStep].currentState?.validate() ?? false) {
  //     if (currentStep < 2) {
  //       setState(() {
  //         currentStep++;
  //       });
  //     } else {
  //       // Call the register API using the controller
  //      await controller.register(UserModel(
  //         firstName: _formKeys[0].currentState?.fields['firstName']?.value,
  //         middleName: _formKeys[0].currentState?.fields['middleName']?.value,
  //         lastName: _formKeys[0].currentState?.fields['lastName']?.value,
  //      )).then(
  //         (value) {
  //            ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text(error.toString())),
  //           );
  //               context.push(AppRoutes.home); 
  //         }
  //       );
       
  //     }
  //   }
  // }

  // void prevStep() {
  //   if (currentStep > 0) {
  //     setState(() {
  //       currentStep--;
  //     });
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }

  // Widget stepIndicator() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: List.generate(3, (index) {
  //       return Expanded(
  //         child: Container(
  //           height: 3,
  //           margin: const EdgeInsets.symmetric(horizontal: 4),
  //           decoration: BoxDecoration(
  //             color: currentStep >= index ? AppColors.kcPrimaryColor : Colors.grey.shade300,
  //             borderRadius: BorderRadius.circular(2),
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }

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
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black),
                    onPressed: prevStep,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text("Create a New Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(
                currentStep == 0
                    ? "Personal Details\nStep 1/3"
                    : currentStep == 1
                        ? "Address Details\nStep 2/3"
                        : "Document Details\nStep 3/3",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
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
                onPressed: ()async {
                  if (currentStep == 2) {
                    nextStep();
                  } else {
                    currentStep++;
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

   Widget buildTextField(String label, String hint, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyTextField(
        controller: controller,
        hintText: hint,
        labelText: label,
        textInputType: type,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
  Widget buildPersonalDetailsForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTextField("First Name", "Ex. ABC", firstNameController),
          buildTextField("Middle Name", "Ex. Kumar", middleNameController),
          buildTextField("Last Name", "Ex. SL Chemicals", lastNameController),
               Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Gender:"),
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
                        CircleAvatar(
                          child: Icon(Icons.male, color: Colors.blue, size: 20,),
                        ),
                        Text("Male"),
                        Radio(value: GenderEnum.male,   activeColor: AppColors.kcPrimaryColor, groupValue: genderGroup, onChanged: (val){
                        setState(() {
                          genderGroup = val!;
                        });
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15,),
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
                         CircleAvatar(
                            child: Icon(Icons.female, color: Colors.blue, size: 20,),
                       ),
                        Text("Female"),
                        Radio(value: GenderEnum.female, 
                        activeColor: AppColors.kcPrimaryColor,
                        groupValue: genderGroup, onChanged: (val){
                          setState(() {
                            genderGroup = val!;
                          });
                        }),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
      
          buildTextField("Date of Birth", "Ex. 14 Aug, 1995", dobController),
          buildTextField("Phone Number", "Ex. +91 9876543210", mobileController, type: TextInputType.phone),
          buildTextField("Email Address", "example@gmail.com", emailController, type: TextInputType.emailAddress),
        ],
      ),
    );
  }
  Widget buildAddressDetailsForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTextField("Address Line 1", "Ex. 53 Brentwood Drive", address1Controller),
          buildTextField("Address Line 2", "Ex. Queensland(Q), 81 Duff Street", address2Controller),
          buildTextField("Address Line 3", "Ex. 81 Duff Street.", address3Controller),
          buildTextField("State", "Ex. Haryana", stateController),
          buildTextField("City", "Ex. Faridabad", cityController),
          buildTextField("Post Code", "000000", pincodeController, type: TextInputType.number),
          buildTextField("Country", "Ex. India", countryController),
        ],
      ),
    );
  }
Widget buildDocumentDetailsForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Document",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              value: selectedDocumentType,
              items: ['PAN Card', 'Aadhar Card'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                setState(() {
                  selectedDocumentType = value;
                });
              },
            ),
          ),
          if (selectedDocumentType != null)
            buildTextField(
              selectedDocumentType == 'PAN Card' ? "PAN Number" : "Aadhar Number",
              selectedDocumentType == 'PAN Card' ? "Ex. XXXXX3256X" : "Ex. 123456789012",
              documentNumberController,
              type: selectedDocumentType == 'PAN Card' ? TextInputType.text : TextInputType.number,
            ),
        ],
      ),
    );
  }
}
