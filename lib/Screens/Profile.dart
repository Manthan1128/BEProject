import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constraints.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color backgroundColor = Color(0xFFE8F5E9); // Light green
  final Color primaryColor = Color(0xFF1B5E20); // Dark green

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  Stream<QuerySnapshot> _fetchUserResults() {
    final user = _auth.currentUser;
    return _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('results')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Profile", style: aHeadLine.copyWith(color: primaryColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: primaryColor));
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(
                child: Text("User data not found",
                    style: aBodyText.copyWith(color: primaryColor)));
          }

          final userData = userSnapshot.data!;
          final name = userData['name'] ?? 'N/A';
          final email = userData['email'] ?? 'N/A';
          final phone = userData['phone'] ?? 'N/A';
          final age = userData['age']?.toString() ?? 'N/A';
          final bmi = userData['BMI']?.toString() ?? 'N/A';
          final goal = userData['goals'] ?? 'N/A';
          final conditions = userData['conditions'] ?? 'N/A';
          final preferences = userData['preferneces'] ?? 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: $name",
                    style: aBodyText.copyWith(color: primaryColor)),
                SizedBox(height: 8),
                Text("Email: $email",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 8),
                Text("Phone: $phone",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 8),
                Text("Age: $age",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 8),
                Text("BMI: $bmi",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 8),
                Text("Goal: $goal",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 8),
                Text("Conditions: $conditions",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 8),
                Text("Preferences: $preferences",
                    style: aBodyText2.copyWith(color: primaryColor)),
                SizedBox(height: 20),
                Text("Results", style: aHeadLine.copyWith(color: primaryColor)),
                SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: _fetchUserResults(),
                  builder: (context, resultsSnapshot) {
                    if (resultsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator(color: primaryColor));
                    }

                    if (!resultsSnapshot.hasData ||
                        resultsSnapshot.data!.docs.isEmpty) {
                      return Text("No results found.",
                          style: aBodyText.copyWith(color: primaryColor));
                    }

                    final results = resultsSnapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final result =
                            results[index].data() as Map<String, dynamic>;
                        final ocr = result['ocr'] ?? 'N/A';
                        final ans = result['ans'] ?? 'N/A';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: primaryColor.withOpacity(0.3)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("OCR: $ocr",
                                    style: aBodyText.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("Result: $ans",
                                    style: aBodyText2.copyWith(
                                        color: primaryColor.withOpacity(0.8))),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
