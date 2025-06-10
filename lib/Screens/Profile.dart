import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constraints.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      backgroundColor: aBackgroundColor,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: aBackgroundColor,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(child: Text("User data not found", style: aBodyText));
          }

          final userData = userSnapshot.data!;
          final name = userData['name'] ?? 'N/A';
          final email = userData['email'] ?? 'N/A';
          final phone = userData['phone'] ?? 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Name: $name", style: aHeadLine),
                SizedBox(height: 8),
                Text("Email: $email", style: aBodyText2),
                SizedBox(height: 8),
                Text("Phone: $phone", style: aBodyText2),
                SizedBox(height: 20),
                Text("Results", style: aHeadLine),
                SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: _fetchUserResults(),
                  builder: (context, resultsSnapshot) {
                    if (resultsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!resultsSnapshot.hasData ||
                        resultsSnapshot.data!.docs.isEmpty) {
                      return Text("No results found.", style: aBodyText);
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
                          color: Colors.grey[900],
                          child: ListTile(
                            title: Text("OCR: $ocr",
                                style: aBodyText.copyWith(color: Colors.white)),
                            subtitle: Text("Answer: $ans",
                                style:
                                    aBodyText.copyWith(color: Colors.white70)),
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
