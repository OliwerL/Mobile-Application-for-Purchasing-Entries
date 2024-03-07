import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhapp/rejestracja.dart';
import 'package:mhapp/udalo_sie.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void login(BuildContext context, String identifier, String password) async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        // Sprawdzenie, czy podany identyfikator pasuje do pola `login` lub `email`
        final QuerySnapshot result = await firestore
            .collection('guests')
            .where('login', isEqualTo: identifier)
            .get();

        // Jeśli nie znaleziono pasującego loginu, sprawdź e-mail
        if (result.docs.isEmpty) {
          final QuerySnapshot emailResult = await firestore
              .collection('guests')
              .where('email', isEqualTo: identifier)
              .get();

          if (emailResult.docs.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Błędne dane logowania')),
            );
            return;
          }

          // Sprawdzenie hasła dla e-maila
          final Map<String, dynamic> emailData = emailResult.docs.first.data() as Map<String, dynamic>;
          if (emailData['haslo'] == password) {
            // Zalogowano pomyślnie przez e-mail
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HelloScreen(docId: emailResult.docs.first.id)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Błędne dane logowania')),
            );
          }
          return;
        }

        // Sprawdzenie hasła dla loginu
        final Map<String, dynamic> data = result.docs.first.data() as Map<String, dynamic>;
        if (data['haslo'] == password) {
          // Zalogowano pomyślnie przez login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HelloScreen(docId: result.docs.first.id)),
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