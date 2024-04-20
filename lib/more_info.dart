import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informacje"),
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
          // Center the column to ensure the text is visible
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Więcej informacji",
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
