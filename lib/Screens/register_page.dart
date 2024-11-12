import 'package:flutter/material.dart';
import '../constraints.dart';
import '../widgets/my_passwordfield.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: aBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register",
                            style: aHeadLine,
                          ),
                          Text(
                            "Create a new account to get started.",
                            style: aBodyText2,
                          ),
                          SizedBox(height: 35),
                          MyTextField(
                            hintText: 'Name',
                            inputType: TextInputType.name,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                          ),
                          MyTextField(
                            hintText: 'Phone',
                            inputType: TextInputType.phone,
                          ),
                          // Additional Fields
                          MyTextField(
                            hintText: 'Age',
                            inputType: TextInputType.number,
                          ),
                          MyTextField(
                            hintText: 'Gender',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            hintText: 'Height (e.g., 170 cm)',
                            inputType: TextInputType.number,
                          ),
                          MyTextField(
                            hintText: 'Weight (e.g., 70 kg)',
                            inputType: TextInputType.number,
                          ),
                          MyTextField(
                            hintText: 'Blood Pressure (High/Low)',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            hintText: 'Dietary Preferences',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            hintText: 'Specific Goals',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            hintText: 'Allergies or Intolerances',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            hintText: 'Pre-existing Conditions',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            hintText: 'Macronutrient Preferences',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            hintText: 'Activity Level',
                            inputType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: aBodyText,
                        ),
                        Text(
                          "Sign In",
                          style: aBodyText.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    MyTextButton(
                      buttonName: 'Register',
                      onTap: () {},
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    ),
                    SizedBox(height: 40),
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
