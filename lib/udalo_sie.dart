import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhapp/zmiana_danych.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'NFC.dart';
import 'logowanie.dart';
import 'main.dart'; // Załóżmy, że tutaj jest zdefiniowana klasa NfcSendExample
// Jeśli NfcSendExample jest w innym pliku, zaimportuj ten plik zamiast main.dart

class HelloScreen extends StatelessWidget {
  final String docId; // ID dokumentu do wyświetlenia

  const HelloScreen({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<int>(
          icon: Icon(Icons.menu), // This creates the hamburger icon
          onSelected: (item) => onSelected(context, item),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Text('Ustawienia konta'),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text('Więcej o nas'),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: Text('Wyloguj'),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center( // This centers the button container in its parent
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3, // Makes the button's width 1/3 of the screen's width
              height: MediaQuery.of(context).size.height / 4,
              child: MaterialButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketsPurchaseScreen()),
                  );
                },
                child: Text('Wejścia na skatepark', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center( // This centers the button container in its parent
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3, // Makes the button's width 1/3 of the screen's width
          height: MediaQuery.of(context).size.height / 4,
          child: MaterialButton(
            color: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TicketsPurchaseScreen()),
              );
            },
            child: Text('Karnety na zajęcia', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NfcSendExample()),
          );
        },
        child: Icon(Icons.nfc),
        tooltip: 'Prześlij przez NFC',
      ),
    );
  }
  // Define the onSelected method inside the class
  void onSelected(BuildContext context, int item) async { // Make the function async
    switch (item) {
      case 0: // Przejście do ustawień konta
        navigateToAccountSettings(context);
        break;
      case 1: // Option to open a webpage
      // Convert your URL string to a Uri object
        final Uri url = Uri.parse('https://rollmasters.pl');
        await launchUrl(url); // Use launchUrl with the Uri object
        break;
      case 2: // Logout case
      // Handle your logout logic here
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(), // Replace with your login screen class
        ));
        break;
    // Handle other cases as needed
    }
  }

  void navigateToAccountSettings(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountSettingsScreen(userId: userId),
        ),
      );
    } else {
      // Użytkownik nie jest zalogowany lub błąd przy uzyskiwaniu identyfikatora użytkownika
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: Nie udało się uzyskać identyfikatora użytkownika')),
      );
    }
  }
}

class TicketsPurchaseScreen extends StatelessWidget {
  const TicketsPurchaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakup Wejściówek'),
      ),
      body: Center(
        child: Text('Tutaj możesz zakupić wejściówki.'),
      ),
    );
  }
}