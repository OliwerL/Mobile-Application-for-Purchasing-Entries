import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buying_coins.dart';

class TicketsPurchaseScreen extends StatelessWidget {
  const TicketsPurchaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Karnety"),
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
                const Text('Kup MasterCoin',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  children: <Widget>[
                    _createButton(
                        context, '1 MasterCoin', const BuyingCoinsScreen(coinAmount: 1)),
                    _createButton(
                        context, '4 MasterCoin', const BuyingCoinsScreen(coinAmount: 4)),
                    _createButton(
                        context, '8 MasterCoin', const BuyingCoinsScreen(coinAmount: 8)),
                    _createButton(
                        context, '16 MasterCoin', const BuyingCoinsScreen(coinAmount: 16)),
                  ],
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
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
