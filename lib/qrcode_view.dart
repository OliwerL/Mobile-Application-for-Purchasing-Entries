import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRcodeScreen extends StatelessWidget {
  final String ticket_data;

  const QRcodeScreen({Key? key, required this.ticket_data}) : super(key: key);

  String getFirestoreField(String ticketData) {
    switch (ticketData) {
      case 'Karnet 1h':
        return 'Karnet_1h';
      case 'Karnet 4h':
        return 'Karnet_4h';
      case 'Karnet 8h':
        return 'Karnet_8h';
      case 'Karnet Open':
        return 'Karnet_Open';
      case 'mastercoin':
        return 'coins';
      default:
        return '';
    }
  }

  Future<int?> getRemainingHours(String userId, String firestoreField) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData[firestoreField];
      }
      return null;
    } catch (e) {
      print("Error fetching remaining hours: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height - 40 - 163;
    double width = screenWidth < screenHeight ? screenWidth : screenHeight;

    String firestoreField = getFirestoreField(ticket_data);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wejściówka"),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            // Ensure the image is added in pubspec.yaml
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY, // This will cover the entire background
          ),
        ),
        child: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Check if data is available and if the user is logged in
                if (snapshot.hasData) {
                  // User is logged in, display their ID
                  String userId = snapshot.data!.uid;

                  return FutureBuilder<int?>(
                    future: getRemainingHours(userId, firestoreField),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (futureSnapshot.hasError) {
                        return const Text("Error fetching data.");
                      } else {
                        int? remainingHours = futureSnapshot.data;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Wejście: $ticket_data',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Pozostało godzin: ${remainingHours ?? "Brak danych"}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            QrImageView(
                              data: "User ID: $userId Type: $ticket_data",
                              version: QrVersions.auto,
                              size: width * 0.9,
                              gapless: true,
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(height: 30),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                "Wchodząc na skatepark pokaż kod\naby użyć wejściówki",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                } else {
                  // User is not logged in
                  return const Text("No user is logged in.");
                }
              } else {
                // Display loading indicator while waiting for data
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
