import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_design_1/Screens/Opencamera.dart';
import 'package:ui_design_1/Screens/register_page.dart';
import '../constraints.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_passwordfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisibility = true;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Invalid credentials.',
        );
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFE8F5E9); // light green
    const primaryColor = Color(0xFF1B5E20); // dark green

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: 30),
                Text("Login",
                    style: aHeadLine.copyWith(color: primaryColor)),
                Text("Welcome back! Please login to continue.",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 35),
                MyTextField(
                  hintText: 'Email',
                  inputType: TextInputType.emailAddress,
                  controller: emailController,
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: aBodyText.copyWith(color: primaryColor)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "Register",
                        style: aBodyText.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                MyTextButton(
                  buttonName: 'Login',
                  onTap: loginUser,
                  bgColor: primaryColor,
                  textColor: const Color.fromARGB(255, 247, 247, 249),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
