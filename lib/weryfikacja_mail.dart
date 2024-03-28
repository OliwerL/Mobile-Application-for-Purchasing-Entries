import 'package:flutter/material.dart';
import 'package:mhapp/logowanie.dart'; // Asumując, że masz już taki plik

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weryfikacja E-maila'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Proszę sprawdzić swój e-mail i potwierdzić konto.'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                // Przekierowanie do strony logowania po potwierdzeniu
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

