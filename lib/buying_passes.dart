import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';

class BuyingPassScreen extends StatelessWidget {
  final String passName; // Variable to store the integer value

  // Constructor with an integer parameter
  const BuyingPassScreen({Key? key, required this.passName}) : super(key: key);

  Future<void> _buyPass(BuildContext context) async {
    try {
      // Update Firestore with the purchased pass
      String? userid = FirebaseAuth.instance.currentUser?.uid;
      if (passName == 'Karnet 1h') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update({'Karnet_1h': 1});
      }
      else if (passName == 'Karnet 4h') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update({'Karnet_4h': 4});
      }
      else if (passName == 'Karnet 8h') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update(
            {'Karnet_8h': 8});
      }
      else if (passName == 'Karnet Open') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update({'Karnet_Open': 1});
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid) // Replace with actual user ID
          .update({passName: 1});

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Informacja"),
            content: const Text("Zakup zakończony pomyślnie!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Błąd"),
            content: const Text("Wystąpił błąd podczas zakupu."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(passName),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Co otrzymujesz?',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    passName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900], // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    _buyPass(context);
                  },
                  child: const Text(
                    'Kup karnet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
