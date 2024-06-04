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
            String? userId = FirebaseAuth.instance.currentUser?.uid;
            final FirebaseFirestore _firestore = FirebaseFirestore.instance;
            if (user != null && userId != null) {
              // Sprawdź, czy użytkownik jest zalogowany i czy pole 'emailver' jest ustawione na true
              //DatabaseService().getDocument(userId!).then((documentSnapshot) {
                //bool islogged = documentSnapshot.get('logger') ?? false;
                if (FirebaseAuth.instance.currentUser != null) {
                  return MainScreen(); // Przekieruj do ekranu głównego, jeśli email jest zweryfikowany
                } else {
                  return const LoginScreen(); // Pokaż ekran logowania, jeśli email nie jest zweryfikowany
                };
              //}
             // );
            } else {
              return const LoginScreen(); // Użytkownik nie jest zalogowany, pokaż ekran logowania
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}





