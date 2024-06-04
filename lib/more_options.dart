import 'package:cloud_firestore/cloud_firestore.dart';
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
      String? userid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('users').doc(userid).update({'logger': false});
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

final FirebaseFirestore _db = FirebaseFirestore.instance;

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
            onPressed: () async {
              Navigator.of(context).pop();
              await deleteUserAccount(context);
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

Future<void> deleteUserAccount(BuildContext context) async {
  final Logger log = Logger();
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Re-authenticate user
    await _reauthenticateAndDelete(context);

    // Delete Firestore data
    await _deleteUserData(userId);

    log.d('User document deleted from Firestore');

    // Delete user from Firebase Authentication
    await FirebaseAuth.instance.currentUser!.delete();
    log.d('User deleted from Firebase Authentication');

  } catch (e) {
    log.e(e);
    // Handle exceptions
  }
}

Future<void> _deleteUserData(String userId) async {
  final Logger log = Logger();
  final userDocRef = _db.collection('users').doc(userId);

  final doc = await userDocRef.get();
  if (doc.exists) {
    log.d('Deleting document: ${doc.id}');
    await userDocRef.delete();
    log.d('User document deleted from Firestore');
  } else {
    log.d('No user document found for userId: $userId');
  }
}

Future<void> _reauthenticateAndDelete(BuildContext context) async {
  final Logger log = Logger();
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final password = await _showPasswordInputDialog(context);
      if (password != null && password.isNotEmpty) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        log.d('User reauthenticated');
      } else {
        log.e('Password not provided');
        throw FirebaseAuthException(
          code: 'password-not-provided',
          message: 'Password is required for re-authentication',
        );
      }
    } else {
      log.e('No user is currently signed in');
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in',
      );
    }
  } catch (e) {
    log.e(e);
    // Handle exceptions
  }
}

Future<String?> _showPasswordInputDialog(BuildContext context) async {
  TextEditingController passwordController = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Wymagane jest ponowne podanie hasłą'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: 'Password'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop(passwordController.text);
            },
          ),
        ],
      );
    },
  );
}