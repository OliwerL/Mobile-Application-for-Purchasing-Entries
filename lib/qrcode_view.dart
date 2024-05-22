import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRcodeScreen extends StatelessWidget {
  final String ticket_data;

  const QRcodeScreen({Key? key, required this.ticket_data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  return QrImageView(
                    data: "User ID: ${snapshot.data!.uid} Type: $ticket_data",
                    version: QrVersions.auto,
                    size: 200,
                    gapless: true,
                    backgroundColor: Colors.white,
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
