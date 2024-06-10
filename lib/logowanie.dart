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

    void resetPassword(BuildContext context) async {
      String email = emailController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proszę podać prawidłowy adres e-mail.')),
        );
        return;
      }
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Link do resetu hasla został wysłany na adres mailowy.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Wystąpił błąd podczas wysyłania linka do resetu hasła.')),
        );
      }
    }

    void loginUser(BuildContext context, String email, String password) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
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
              MaterialPageRoute(
                  builder: (context) => EmailVerificationScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message =
            "Wystąpił błąd podczas logowania."; // Domyślny komunikat błędu
        if (e.code == 'invalid-email') {
          message =
              'Nie znaleziono użytkownika.'; // Specyficzny błąd gdy użytkownik nie istnieje
        } else if (e.code == 'invalid-credential') {
          message = 'Błędne hasło.'; // Specyficzny błąd gdy hasło jest błędne
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wystąpił nieoczekiwany błąd.')),
        );
      }
    }

    //double screenHeight =
      //  MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(

      appBar: AppBar(
        title: const Text('Logowanie'),
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 190,
                    child: Image.asset(
                      "assets/login_logo.png",
                      fit: BoxFit.cover, // Dostosuj obraz do rozmiaru SizedBox
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey[800]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Wpisz swój email',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Kolor obwódki, gdy TextField jest w fokusie
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    cursorColor: Colors.black45,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Hasło',
                      labelStyle: TextStyle(color: Colors.grey[800]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Wpisz swoje hasło',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Kolor obwódki, gdy TextField jest w fokusie
                        borderRadius: BorderRadius.circular(20),
                      ),

                    ),
                    cursorColor: Colors.black45,
                    obscureText: true,
                  ),

                  SizedBox(height: 15),
                  MaterialButton(
                    color: Colors.red[900],
                    onPressed: () => loginUser(
                        context, emailController.text, passwordController.text),
                    child: const Text(
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
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()),
                      );
                    },
                    child: const Text(
                      'Nie masz konta? Zarejestruj się',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => resetPassword(context),
                    child: const Text(
                      'Zresetuj hasło',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
