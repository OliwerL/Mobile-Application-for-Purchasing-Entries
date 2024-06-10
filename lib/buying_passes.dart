import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pay/pay.dart';
import 'payment_configurations.dart';

class BuyingPassScreen extends StatefulWidget {
  final String passName;

  BuyingPassScreen({Key? key, required this.passName}) : super(key: key);

  @override
  _BuyingPassScreenState createState() => _BuyingPassScreenState();
}

class _BuyingPassScreenState extends State<BuyingPassScreen> {
  final List<PaymentItem> _paymentItems = [];
  late double passPrice;

  @override
  void initState() {
    super.initState();
    passPrice = getPassPrice(widget.passName);
    _paymentItems.add(
      PaymentItem(
        label: widget.passName,
        amount: passPrice.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  double getPassPrice(String passName) {
    switch (passName) {
      case 'Karnet 1h':
        return 0.02;
      case 'Karnet 4h':
        return 0.02;
      case 'Karnet 8h':
        return 0.02;
      case 'Karnet Open':
        return 0.02;
      default:
        return 0.00;
    }
  }

  Future<bool> _checkIfPassOwned(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        switch (widget.passName) {
          case 'Karnet 1h':
            return userData['Karnet_1h'] != null && userData['Karnet_1h'] > 0;
          case 'Karnet 4h':
            return userData['Karnet_4h'] != null && userData['Karnet_4h'] > 0;
          case 'Karnet 8h':
            return userData['Karnet_8h'] != null && userData['Karnet_8h'] > 0;
          case 'Karnet Open':
            return userData['Karnet_Open'] != null && userData['Karnet_Open'] > 0;
          default:
            return false;
        }
      }
      return false;
    } catch (e) {
      print("Error checking if pass is owned: $e");
      return false;
    }
  }

  Future<void> _handlePaymentSuccess(BuildContext context) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Proceed with purchase and update Firestore
      switch (widget.passName) {
        case 'Karnet 1h':
          await FirebaseFirestore.instance.collection('users').doc(userId).update({'Karnet_1h': 1});
          break;
        case 'Karnet 4h':
          await FirebaseFirestore.instance.collection('users').doc(userId).update({'Karnet_4h': 4});
          break;
        case 'Karnet 8h':
          await FirebaseFirestore.instance.collection('users').doc(userId).update({'Karnet_8h': 8});
          break;
        case 'Karnet Open':
          await FirebaseFirestore.instance.collection('users').doc(userId).update({'Karnet_Open': 1});
          break;
      }

      // Refresh the screen
      setState(() {});

      // Show success dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Informacja"),
            content: const Text("Zakup zakończony pomyślnie!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Błąd"),
            content: const Text("Wystąpił błąd podczas zakupu."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String description;
    switch (widget.passName) {
      case 'Karnet 1h':
        description = '1 godzina dowolnych zajęć\n + 1h swobodnej jazdy na Skateparku MasterHouse';
        break;
      case 'Karnet 4h':
        description = 'Motywacja i oszczędność 50zł\n + 2h swobodnej jazdy na Skateparku MasterHouse';
        break;
      case 'Karnet 8h':
        description = 'Motywacja i oszczędność 150zł\n + 4h swobodnej jazdy na Skateparku MasterHouse';
        break;
      case 'Karnet Open':
        description = 'Progres i swoboda wyboru\n + 8h swobodnej jazdy na Skateparku MasterHouse';
        break;
      default:
        description = widget.passName;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.passName),
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
            child: FutureBuilder<bool>(
              future: _checkIfPassOwned(FirebaseAuth.instance.currentUser?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Wystąpił błąd.'));
                } else {
                  bool passOwned = snapshot.data ?? false;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Co otrzymujesz?',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          '${widget.passName}:\n $description',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Cena: ${passPrice.toStringAsFixed(2)} PLN',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      if (!passOwned) ...[
                        GooglePayButton(
                          paymentConfiguration: PaymentConfiguration.fromJsonString(
                              defaultGooglePay),
                          paymentItems: _paymentItems,
                          type: GooglePayButtonType.buy,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: (data) {
                            _handlePaymentSuccess(context);
                          },
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        ApplePayButton(
                          paymentConfiguration: PaymentConfiguration.fromJsonString(
                              defaultApplePay),
                          paymentItems: _paymentItems,
                          style: ApplePayButtonStyle.black,
                          type: ApplePayButtonType.buy,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: (data) {
                            _handlePaymentSuccess(context);
                          },
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Masz już zakupiony ten karnet.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
