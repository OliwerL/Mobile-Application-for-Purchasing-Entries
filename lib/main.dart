import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void login(BuildContext context, String login, String password) async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        final QuerySnapshot result = await firestore
            .collection('guests')
            .where('login', isEqualTo: login)
            .limit(1)
            .get();

        if (result.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Błędne dane logowania')),
          );
          return;
        }

        final Map<String, dynamic> data = result.docs.first.data() as Map<String, dynamic>;
        if (data['haslo'] == password) {
          // Zalogowano pomyślnie
          Navigator.pushReplacement( // Możesz użyć pushReplacement lub push w zależności od potrzeb
            context,
            MaterialPageRoute(builder: (context) => HelloScreen(docId: result.docs.first.id)), // Przekazanie docId do HelloScreen
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Błędne dane logowania')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił błąd: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ekran logowania'),
              const SizedBox(height: 20),
              TextField(
                controller: loginController,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                  hintText: 'Wpisz swój login',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Hasło',
                  border: OutlineInputBorder(),
                  hintText: 'Wpisz swoje hasło',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => login(context, loginController.text, passwordController.text),
                child: const Text('Zaloguj się'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                  );
                },
                child: const Text('Nie masz konta? Zarejestruj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    );
  }
}
