import 'package:flutter/material.dart';
import 'package:mhapp/konkakt.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mhapp/zmiana_danych.dart';
import 'logowanie.dart';
import 'package:logger/logger.dart';

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
                  onSelected(context, 3);  // Call onSelected for contact
                },
                textColor: Colors.white,
              ),
              ListTile(
                title: Text('FAQ'),
                onTap: () {
                  onSelected(context, 4);  // Call onSelected for FAQ
                },
                textColor: Colors.white,
              ),
              ListTile(
                title: Text('Usuń konto'),
                onTap: () {
                  onSelected(context, 5);  // Call onSelected for account deletion
                },
                textColor: Colors.red, // Highlighting the delete option in red
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}

void onSelected(BuildContext context, int item) async {
  switch (item) {
    case 0:
      navigateToAccountSettings(context);
      break;
    case 1:
      final Uri url = Uri.parse('https://rollmasters.pl');
      await launchUrl(url);
      break;
    case 2:
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen(),
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
    // Handle FAQ option
      break;
    case 5:
      _showDeleteAccountDialog(context);
      break;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Błąd: Nie udało się uzyskać identyfikatora użytkownika')),
    );
  }
}

void _showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Usuń konto'),
        content: Text('Czy na pewno chcesz usunąć swoje konto? Tej operacji nie można cofnąć.'),
        actions: [
          TextButton(
            child: Text('Anuluj'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Usuń', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));

            },
          ),
        ],
      );
    },
  );
}

Future<void> _reauthenticateAndDelete(BuildContext context) async {
  final Logger log = Logger();
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

    log.d('Re-authenticating with provider: ${providerData?.providerId}');

    if (providerData != null) {
      if (AppleAuthProvider().providerId == providerData.providerId) {
        log.d('Using AppleAuthProvider for re-authentication');
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        log.d('Using GoogleAuthProvider for re-authentication');
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      } else {
        log.e('Unsupported provider: ${providerData.providerId}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nieobsługiwany dostawca logowania: ${providerData.providerId}')),
        );
        return;
      }

      log.d('Re-authentication successful, attempting to delete user again');
      await FirebaseAuth.instance.currentUser?.delete();

      log.d('User deletion successful, logging out and navigating to LoginScreen');
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
    }
  } catch (e) {
    log.e('Error during re-authentication and deletion: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wystąpił błąd podczas ponownej autoryzacji: ${e.toString()}')),
    );
  }
}

Future<void> _deleteAccount(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  final Logger log = Logger();

  if (user != null) {
    try {
      log.d('Attempting to delete user: ${user.uid}');
      await user.delete();
      log.d('User deletion attempt finished');
      log.d('Navigating to LoginScreen after deletion');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      log.e('FirebaseAuthException during account deletion: ${e.code}');
      if (e.code == 'requires-recent-login') {
        log.d('Re-authentication required, attempting re-authentication');
        await _reauthenticateAndDelete(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił błąd podczas usuwania konta: ${e.message}')),
        );
      }
    }
  } else {
    log.e('No user found to delete');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nie udało się uzyskać informacji o użytkowniku.')),
    );
  }
}
