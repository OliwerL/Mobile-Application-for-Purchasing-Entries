import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pay/pay.dart';
import 'payment_configurations.dart';

class BuyingPassScreen extends StatelessWidget {
  final String passName;
  final List<PaymentItem> _paymentItems = [];

  BuyingPassScreen({Key? key, required this.passName}) : super(key: key) {
    _paymentItems.add(
      PaymentItem(
        label: passName,
        amount: getPassPrice(passName).toStringAsFixed(2),
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

  Future<void> _handlePaymentSuccess(BuildContext context) async {
    try {
      String? userid = FirebaseAuth.instance.currentUser?.uid;
      if (passName == 'Karnet 1h') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update({'Karnet_1h': 1});
      }
      else if (passName == 'Karnet 4h') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update({'Karnet_4h': 4});
      }
      else if (passName == 'Karnet 8h') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update({'Karnet_8h': 8});
      }
      else if (passName == 'Karnet Open') {
        await FirebaseFirestore.instance.collection('users').doc(userid).update({'Karnet_Open': 1});
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid) // Replace with actual user ID
          .update({passName.replaceAll(' ', '_'): 1});

      // Show success dialog
      showDialog(
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
      showDialog(
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String description;
    switch (passName) {
      case 'Karnet 1h':
        description = '1 godzina dowolnych zajęć\n + 1h swobodnej jazdy na Skateparku MasterHouse';
      case 'Karnet 4h':
        description = 'Motywacja i oszczędność 50zł\n + 2h swobodnej jazdy na Skateparku MasterHouse';
      case 'Karnet 8h':
        description = 'Motywacja i oszczędność 150zł\n + 4h swobodnej jazdy na Skateparku MasterHouse';
      case 'Karnet Open':
        description = 'Progres i swoboda wyboru\n + 8h swobodnej jazdy na Skateparku MasterHouse';
      default:
        description = passName;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(passName),
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
                const Text('Co otrzymujesz?',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    '$passName:\n $description',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
