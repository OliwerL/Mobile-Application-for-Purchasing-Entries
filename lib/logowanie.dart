import 'package:flutter/material.dart';
import 'package:mhapp/rejestracja.dart';
import 'package:mhapp/udalo_sie.dart';
import 'package:mhapp/weryfikacja_mail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void loginUser(BuildContext context, String email, String password) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;

        if (user != null) {
          await user.reload(); // Odśwież informacje o użytkowniku, aby upewnić się, że mamy najnowsze dane
          user = FirebaseAuth.instance.currentUser; // Ponownie pobierz informacje o aktualnym użytkowniku

          if (user?.emailVerified != true) {
            // Jeśli e-mail nie został zweryfikowany, przenieś użytkownika na ekran informujący o konieczności weryfikacji
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
            );
          } else {
            // Jeśli e-mail został zweryfikowany, przenieś użytkownika do kolejnego ekranu
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Wystąpił błąd podczas logowania.';
        if (e.code == 'user-not-found') {
          message = 'Nie znaleziono użytkownika.';
        } else if (e.code == 'wrong-password') {
          message = 'Błędne hasło.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        // Inny rodzaj błędu, na przykład brak połączenia z internetem
        print(e); // Dobrą praktyką jest zalogowanie błędu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił nieoczekiwany błąd.')),
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
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'Wpisz swój email',
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
                onPressed: () => loginUser(context, emailController.text, passwordController.text),
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
