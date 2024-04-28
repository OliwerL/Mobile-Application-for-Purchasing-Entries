import 'package:flutter/material.dart';
import 'package:mhapp/udalo_sie.dart';
import 'package:provider/provider.dart';
import 'coin_data.dart';
import 'logowanie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
        create: (context) => CoinData(),
        child: const MyApp(),
      ),
  );
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const LoginScreen(); // Użytkownik nie jest zalogowany, pokazuje ekran logowania
            }
            return MainScreen(); // Użytkownik jest zalogowany, pokazuje inny ekran
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Ekran ładowania podczas oczekiwania na dane autentykacji
            ),
          );
        },
      ),
    );
  }
}




