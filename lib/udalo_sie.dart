import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NFC.dart';
import 'main.dart'; // Załóżmy, że tutaj jest zdefiniowana klasa NfcSendExample
// Jeśli NfcSendExample jest w innym pliku, zaimportuj ten plik zamiast main.dart

class HelloScreen extends StatelessWidget {
  final String docId; // ID dokumentu do wyświetlenia

  const HelloScreen({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Witaj'),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: DatabaseService().getDocument(docId),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Wystąpił błąd: ${snapshot.error}");
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text("Brak danych");
              }
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Text("Witaj, ${data['imie']} ${data['nazwisko']}!"); // Upewnij się, że klucz 'imie' jest zgodny z Firestore
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return const Text("Brak danych");
          },
        ),
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
}
