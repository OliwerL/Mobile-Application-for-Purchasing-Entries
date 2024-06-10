import 'package:flutter/material.dart';
import 'package:mhapp/logowanie.dart'; // Asumując, że masz już taki plik

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weryfikacja E-maila'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Proszę sprawdzić swój e-mail i potwierdzić konto.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),textAlign: TextAlign.center,),
              SizedBox(height: 40),
              ElevatedButton(
                child: Text(
                  '  OK  ',
                  style: TextStyle(color: Colors.white), // Kolor tekstu na biały
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Kolor guzika na czerwony
                ),
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
      ),
    );
  }
}
