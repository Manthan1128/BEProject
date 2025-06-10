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

  final Color backgroundColor = Color(0xFFE8F5E9);
  final Color primaryColor = Color(0xFF1B5E20);

  Future<void> setImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      setState(() {
        imagePath = File(image.path);
        log(imagePath.toString());
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Capture Photo", style: TextStyle(color: primaryColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildImage(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCapturePhotoBtn(context),
                  SizedBox(width: 25),
                  buildGenerateQRBtn(context),
                ],
              ),
              SizedBox(height: 50),
              if (imagePath != null) ...[
                Text('Captured Image',
                    style: TextStyle(fontSize: 16, color: primaryColor)),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imagePath!, fit: BoxFit.cover),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() => CircleAvatar(
        backgroundImage: AssetImage("assets/images/QR.jpg"),
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        radius: 150,
      );

  Widget buildCapturePhotoBtn(BuildContext context) => Hero(
        tag: "Capture Photo",
        child: SizedBox(
          width: ((MediaQuery.of(context).size.width) / 2) - 45,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Capture Photo",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            onPressed: () {
              setImage();
              log("Image path:  " + imagePath.toString());
            },
          ),
        ),
      );

  Widget buildGenerateQRBtn(BuildContext context) => SizedBox(
        width: ((MediaQuery.of(context).size.width) / 2) - 45,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Generate QR",
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          onPressed: () {
            if (imagePath != null) {
              log("Image path:  " + imagePath.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(imagePath: imagePath!),
                ),
              );
            } else {
              log("-else-----------------------Image path:  ------------------------" +
                  imagePath.toString());
            }
          },
        ),
      );
}
