import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'qrcode_view.dart';
import 'buying_passes.dart';

class PassPurchaseScreen extends StatelessWidget {
  const PassPurchaseScreen({Key? key}) : super(key: key);

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
                const Text('Zajęcia grupowe',
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
                        context, '1h zajęć',  BuyingPassScreen(passName: "Karnet 1h")),
                    _createButton(
                        context, 'Karnet 4h',  BuyingPassScreen(passName: "Karnet 4h")),
                    _createButton(
                        context, 'Karnet 8h',  BuyingPassScreen(passName: "Karnet 8h")),
                    _createButton(
                        context, 'Karnet Open',  BuyingPassScreen(passName: "Karnet Open")),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Karnety rodzinne',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                const Text('Wkrótce',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey)),
                // GridView.count(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   crossAxisCount: 2,
                //   crossAxisSpacing: 10,
                //   mainAxisSpacing: 10,
                //   padding: EdgeInsets.all(screenWidth * 0.05),
                //   children: <Widget>[
                //     _createButton(context, 'Karnet 2x 4h', const BuyingPassScreen(passName: "Karnet 2x 4h")),
                //     // Adjust as necessary
                //     _createButton(context, 'Karnet 3x 4h', const BuyingPassScreen(passName: "Karnet 3x 4h")),
                //     // Adjust as necessary
                //     _createButton(context, 'Karnet 4x 4h', const BuyingPassScreen(passName: "Karnet 4x 4h")),
                //     // Adjust as necessary
                //     _createButton(context, 'Family Open 3os.', const BuyingPassScreen(passName: "Karnet Family Open 3os.")),
                //     // Adjust as necessary
                //   ],
                // ),
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
