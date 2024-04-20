import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'more_options.dart';


import 'NFC.dart';
import 'logowanie.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HelloScreen(), // This is your original home screen
    MoreOptionsScreen(),
    MoreOptionsScreen(), // The new screen with more options
    // Add more screens as needed
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[350],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red[900], // Optional: set selected item color
        unselectedItemColor: Colors.black, // Optional: set unselected item color
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold text for selected item
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: 'Oferta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.red[900],),
            label: 'Więcej',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: Colors.black,),
            label: 'Opcje',
          ),
          // Add more BottomNavigationBarItem as needed
        ],
      ),
    );
  }
}

class HelloScreen extends StatelessWidget {
  final String? docId;

  const HelloScreen({Key? key, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Gets the screen width
    double screenHeight = MediaQuery.of(context).size.height;
    // Return your screen content without a Scaffold
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"),
          // replace with your image path
          fit: BoxFit.fitWidth,
          // This will scale the image to fit the width of the screen
          repeat: ImageRepeat.repeatY, // This will repeat the image vertically
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight/ 18),
          Center( // This centers the button container in its parent
            child: Container(
              width: screenWidth / 1.3,
              // Makes the button's width 1/3 of the screen's width
              height: screenHeight / 4,
              child: MaterialButton(
                color: Colors.red[900],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TicketsPurchaseScreen()),
                  );
                },
                child: const Text('Wejścia na skatepark',
                    style: TextStyle(color: Colors.white,fontSize: 20,  // Increase the font size
                      fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(height: screenHeight/ 40),
          Center( // This centers the button container in its parent
            child: Container(
              width: screenWidth / 1.3,
              // Makes the button's width 1/3 of the screen's width
              height: screenHeight / 4,
              child: MaterialButton(
                color: Colors.red[900],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TicketsPurchaseScreen()),
                  );
                },
                child: const Text('Karnety na zajęcia',
                    style: TextStyle(color: Colors.white, fontSize: 20,  // Increase the font size
                      fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(height: screenHeight/ 40),
          Center( // This centers the button container in its parent
            child: Container(
              width: screenWidth / 1.3,
              // Makes the button's width 1/3 of the screen's width
              height: screenHeight / 4,
              child: MaterialButton(
                color: Colors.red[900],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NfcSendExample()),
                  );
                },
                child: const Text(
                    'RollMaster Card', style: TextStyle(color: Colors.white, fontSize: 20,  // Increase the font size
                  fontWeight: FontWeight.bold)),

              ),
            ),
          ),
        ],
      ),
    );
  }
// Define the onSelected method inside the class
}
class TicketsPurchaseScreen extends StatelessWidget {

  const TicketsPurchaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakup Wejściówek'),
      ),
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Sprawdzenie, czy dane są dostępne i czy użytkownik jest zalogowany
              if (snapshot.hasData) {
                // Użytkownik jest zalogowany, wyświetlamy jego ID
                return QrImageView(
                  data: "User ID: ${snapshot.data!.uid}",
                  version: QrVersions.auto,
                  size: 200,
                  gapless: true,
                );

              } else {
                // Użytkownik nie jest zalogowany
                return Text("No user is logged in.");
              }
            } else {
              // Wyświetlanie wskaźnika ładowania podczas oczekiwania na dane
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

