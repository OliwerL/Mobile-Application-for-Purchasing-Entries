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
          await user.reload();
          user = FirebaseAuth.instance.currentUser;

          if (user?.emailVerified != true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
            );
          } else {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił nieoczekiwany błąd.')),
        );
      }
    }

    double screenHeight = MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie'),
        backgroundColor: Colors.grey[350],
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight / 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Wpisz swój email',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight / 40),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Hasło',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Wpisz swoje hasło',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: screenHeight / 20),
                MaterialButton(
                  color: Colors.red[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () => loginUser(context, emailController.text, passwordController.text),
                  child: Text(
                    'Zaloguj się',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                    );
                  },
                  child: const Text(
                    'Nie masz konta? Zarejestruj się',
                    style: TextStyle(
                      color: Colors.white
                    ),
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
