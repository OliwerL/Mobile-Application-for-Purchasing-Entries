import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mhapp/qrcode_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BuyingCoinsScreen extends StatelessWidget {
  const BuyingCoinsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("MasterCoins"),
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
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Czym są MasterCoins?',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.all(15.0), // Dostosuj wypełnienie według potrzeb

                  child: const Text(
                    'DOpis co to są MasterCoins pewnie będzie dl;uższy więc napisze jakieś głupoty żeby bardziej oddawało wizualnie. Litwo ojczyzno moja tyjesteś jak zdrowie ile cie trzeba cenić ten tylko sie dowie kto cie stracil',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),



                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900], // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRcodeScreen()), // Przekierowanie do klasy QRcodeScreen
                    );
                  },
                  child: const Text(
                    'Kup MasterCoin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),




              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context, String text, Widget page) {
    return Opacity(
      opacity: 0.7, // Apply opacity to the entire button
      child: MaterialButton(
        color: Colors.black45,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
