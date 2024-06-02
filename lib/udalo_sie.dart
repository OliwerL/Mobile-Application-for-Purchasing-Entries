import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhapp/pass_purchase.dart';
import 'package:provider/provider.dart';

import 'coin_data.dart';
import 'more_options.dart';
import 'NFC.dart';
import 'ticket_purchase.dart';
import 'my_tickets.dart';
import 'qrcode_view.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HelloScreen(), // This is your original home screen
    MyTicketsScreen(),
    MoreOptionsScreen(), // The new screen with more options
    // Add more screens as needed
  ];

  void onTabTapped(int index) {
    setState(() {
      Provider.of<CoinData>(context, listen: false).fetchCoins();
      Provider.of<CoinData>(context, listen: false).fetchPurchasedTickets();
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
        selectedItemColor: Colors.red[900],
        // Optional: set selected item color
        unselectedItemColor: Colors.black,
        // Optional: set unselected item color
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        // Bold text for selected item
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Oferta',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.confirmation_num,
              color: Colors.red[900],
            ),
            label: 'Karnety',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
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
    double screenWidth =
        MediaQuery.of(context).size.width; // Gets the screen width
    double screenHeight = MediaQuery.of(context).size.height;
    // Return your screen content without a Scaffold
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"),
          fit: BoxFit.fitWidth,
          repeat: ImageRepeat.repeatY,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 3* screenHeight / 40),
            Center(
              // This centers the button container in its parent
              child: SizedBox(
                width: screenWidth / 1.3,
                // Makes the button's width 1/3 of the screen's width
                height: screenHeight / 4,
                child: MaterialButton(
                  color: Colors.red[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // zaokrąglone rogi o promieniu 20
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TicketsPurchaseScreen()),
                    );
                  },
                  child: const Text('Wejścia na skatepark',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          // Increase the font size
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: screenHeight / 40),
            Center(
              // This centers the button container in its parent
              child: SizedBox(
                width: screenWidth / 1.3,
                // Makes the button's width 1/3 of the screen's width
                height: screenHeight / 4,
                child: MaterialButton(
                  color: Colors.red[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // zaokrąglone rogi o promieniu 20
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PassPurchaseScreen()),
                    );
                  },
                  child: const Text('Karnety na zajęcia',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          // Increase the font size
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: screenHeight / 40),
            Center(
              // This centers the button container in its parent
              child: SizedBox(
                width: screenWidth / 1.3,
                // Makes the button's width 1/3 of the screen's width
                height: screenHeight / 4,
                child: MaterialButton(
                  color: Colors.red[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // zaokrąglone rogi o promieniu 20
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NfcSendExample()),
                    );
                  },
                  child: const Text('RollMaster Card',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          // Increase the font size
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 2*screenHeight / 40),
          ],
        ),
      ),
    );
  }
}
