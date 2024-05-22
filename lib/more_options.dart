import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhapp/konkakt.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mhapp/zmiana_danych.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'logowanie.dart';
class MoreOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Opcje"),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Ensure the image is added in pubspec.yaml
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY, // This will cover the entire background
          ),
        ),
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text('Ustawienia konta'),
                onTap: () {
                  onSelected(context, 0);  // Call onSelected for account settings
                },
                textColor: Colors.white,
              ),
              ListTile(
                title: Text('Więcej o nas'),
                onTap: () {
                  onSelected(context, 1);  // Call onSelected to open a webpage
                },
                textColor: Colors.white,
              ),
              ListTile(
                title: Text('Wyloguj'),
                onTap: () {
                  onSelected(context, 2);  // Call onSelected for logout
                },
                textColor: Colors.white,
              ),
              ListTile(
                title: Text('Kontakt'),
                onTap: () {
                  onSelected(context, 3);  // Call onSelected for logout
                },
                textColor: Colors.white,
              ),
              ListTile(
                title: Text('FAQ'),
                onTap: () {
                  onSelected(context, 4);  // Call onSelected for logout
                },
                textColor: Colors.white,
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}

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
    case 3:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ContactScreen(),
        ),
      );
      break;
    case 4:
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
