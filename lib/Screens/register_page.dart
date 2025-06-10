import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_design_1/Screens/Login.dart';
import 'package:ui_design_1/Screens/Opencamera.dart';
import '../constraints.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_passwordfield.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();
  final TextEditingController conditionsController = TextEditingController();
  final TextEditingController preferencesController = TextEditingController();

  Future<void> registerUser() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'age': int.tryParse(ageController.text.trim()) ?? 0,
        'BMI': double.tryParse(bmiController.text.trim()) ?? 0.0,
        'goals': goalsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'conditions': conditionsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'preferences': preferencesController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFDFF5E3); // light green
    const primaryColor = Color(0xFF1B5E20); // dark green

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "NutriScan",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Register",
                              style: aHeadLine.copyWith(color: primaryColor)),
                          Text("Create a new account to get started.",
                              style: aBodyText2.copyWith(color: primaryColor)),
                          const SizedBox(height: 35),
                          MyTextField(
                            hintText: 'Name',
                            inputType: TextInputType.name,
                            controller: nameController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                            controller: emailController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyTextField(
                            hintText: 'Phone',
                            inputType: TextInputType.phone,
                            controller: phoneController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyTextField(
                            hintText: 'Age',
                            inputType: TextInputType.number,
                            controller: ageController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyTextField(
                            hintText: 'BMI',
                            inputType:
                                TextInputType.numberWithOptions(decimal: true),
                            controller: bmiController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyTextField(
                            hintText: 'Goals (comma separated)',
                            inputType: TextInputType.text,
                            controller: goalsController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyTextField(
                            hintText: 'Conditions (comma separated)',
                            inputType: TextInputType.text,
                            controller: conditionsController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyTextField(
                            hintText: 'Preferences (comma separated)',
                            inputType: TextInputType.text,
                            controller: preferencesController,
                            borderColor: primaryColor,
                            textColor: primaryColor,
                          ),
                          MyPasswordField(
                            controller: passwordController,
                            isPasswordVisible: passwordVisibility,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                            borderColor: primaryColor,
                            textColor: primaryColor,
                            iconColor: primaryColor,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",
                            style: aBodyText.copyWith(color: primaryColor)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: aBodyText.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyTextButton(
                      buttonName: 'Register',
                      onTap: registerUser,
                      bgColor: primaryColor,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
