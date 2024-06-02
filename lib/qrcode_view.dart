import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRcodeScreen extends StatelessWidget {
  final String ticket_data;

  const QRcodeScreen({Key? key, required this.ticket_data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height - 40 - 163;
    double width;
    if (screenWidth < screenHeight) {
      width = screenWidth;
    } else {
      width = screenHeight;
    }

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
            repeat:
                ImageRepeat.repeatY, // This will cover the entire background
          ),
        ),
        child: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Sprawdzenie, czy dane są dostępne i czy użytkownik jest zalogowany
                if (snapshot.hasData) {
                  // Użytkownik jest zalogowany, wyświetlamy jego ID
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
                      const SizedBox(height: 30),
                      QrImageView(
                        data:
                            "User ID: ${snapshot.data!.uid} Type: $ticket_data",
                        version: QrVersions.auto,
                        size: width*0.9,
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
                } else {
                  // Użytkownik nie jest zalogowany
                  return const Text("No user is logged in.");
                }
              } else {
                // Wyświetlanie wskaźnika ładowania podczas oczekiwania na dane
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
