import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTicketsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moje karnety"),
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Zapewnia wyśrodkowanie wertykalne
            crossAxisAlignment: CrossAxisAlignment.center, // Zapewnia wyśrodkowanie horyzontalne
            children: [
              Text(
                "Tu wyświetlą się Twoje karnety po kupnie",
                textAlign: TextAlign.center, // Dodano wyśrodkowanie tekstu w obrębie Text widget
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24), // Makes text white and larger
              ),
            ],
          ),
        ),
      ),
    );
  }
}
