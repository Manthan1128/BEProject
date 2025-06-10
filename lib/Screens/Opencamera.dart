import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_design_1/Screens/Profile.dart';
import 'package:ui_design_1/Screens/Result.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? imagePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      setState(() {
        imagePath = File(image.path);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Capture Photo"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildImage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCapturePhotoBtn(context),
                    SizedBox(
                      width: 25,
                    ),
                    buildGenerateQRBtn(context),
                  ],
                ),
                SizedBox(height: 50),
                if (imagePath != null) ...[
                  Text('Captured Image'),
                  SizedBox(height: 20),
                  Container(
                    child: Image.file(imagePath!, fit: BoxFit.cover),
                    width: double.infinity,
                    height: 200,
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage() => CircleAvatar(
        backgroundImage: AssetImage(
          "assets/images/QR.jpg", // You can replace this with any other image you want to show
        ),
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        radius: 150,
      );

  Widget buildCapturePhotoBtn(BuildContext context) => Hero(
        tag: "Capture Photo",
        child: Container(
          width: ((MediaQuery.of(context).size.width) / 2) - 45,
          height: 50,
          child: ElevatedButton(
            child: Text(
              "Capture Photo",
              style: TextStyle(fontSize: 17),
            ),
            onPressed: () {
              setImage();
            },
          ),
        ),
      );

  Widget buildGenerateQRBtn(BuildContext context) => Container(
        width: ((MediaQuery.of(context).size.width) / 2) - 45,
        height: 50,
        child: ElevatedButton(
          child: Text(
            "Generate QR",
            style: TextStyle(fontSize: 17),
          ),
          onPressed: () {
            if (imagePath != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(imagePath: imagePath!),
                ),
              );
            }
          },
        ),
      );
}
