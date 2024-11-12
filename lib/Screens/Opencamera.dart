// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:encryption/AESEncryption/AES.dart';
// import 'package:encryption/QR%20Generator/QRGenerator.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   AESEncryption encryption = AESEncryption();
//   late List<CameraDescription> cameras;
//   late CameraController controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     cameras = await availableCameras();
//     controller = CameraController(
//       cameras.first,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = controller.initialize();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Capture Photo"),
//       ),
//       body: Container(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               buildImage(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   buildCapturePhotoBtn(context),
//                   SizedBox(
//                     width: 25,
//                   ),
//                   buildGenerateQRBtn(context),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildImage() => CircleAvatar(
//         backgroundImage: AssetImage(
//           "assets/images/QR.jpg", // You can replace this with any other image you want to show
//         ),
//         foregroundColor: Colors.transparent,
//         backgroundColor: Colors.transparent,
//         radius: 150,
//       );

//   Widget buildCapturePhotoBtn(BuildContext context) => Hero(
//         tag: "Capture Photo",
//         child: Container(
//           width: ((MediaQuery.of(context).size.width) / 2) - 45,
//           height: 50,
//           child: ElevatedButton(
//             child: Text(
//               "Capture Photo",
//               style: TextStyle(fontSize: 17),
//             ),
//             onPressed: () async {
//               await _initializeControllerFuture;
//               final image = await controller.takePicture();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DisplayPhotoPage(imagePath: image.path),
//                 ),
//               );
//             },
//           ),
//         ),
//       );

//   Widget buildGenerateQRBtn(BuildContext context) => Container(
//         width: ((MediaQuery.of(context).size.width) / 2) - 45,
//         height: 50,
//         child: ElevatedButton(
//           child: Text(
//             "Generate QR",
//             style: TextStyle(fontSize: 17),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => QRGenerator()),
//             );
//           },
//         ),
//       );
// }

// class DisplayPhotoPage extends StatelessWidget {
//   final String imagePath;
//   DisplayPhotoPage({required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Captured Photo')),
//       body: Center(
//         child: Image.file(
//           File(imagePath), // Display captured image here
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
