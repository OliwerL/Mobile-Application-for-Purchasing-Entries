import 'package:flutter/material.dart';
import 'package:mhapp/udalo_sie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'logowanie.dart';
import 'rejestracja.dart'; // Import nowego pliku
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getDocument(String docId) async {
    return await _db.collection('Test1').doc(docId).get();
  }

  Stream<QuerySnapshot> streamDocuments() {
    return _db.collection('Test1').snapshots();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}




