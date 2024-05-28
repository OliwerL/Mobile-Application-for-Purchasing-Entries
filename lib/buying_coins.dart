import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pay/pay.dart';
import 'coin_data.dart';
import 'payment_configurations.dart';

class BuyingCoinsScreen extends StatelessWidget {
  final int coinAmount;
  final List<PaymentItem> _paymentItems = [];

  BuyingCoinsScreen({Key? key, required this.coinAmount}) : super(key: key) {
    _paymentItems.add(
      PaymentItem(
        label: 'MasterCoins',
        amount: (coinAmount * 1.99).toString(), // Set your coin price here
        status: PaymentItemStatus.final_price,
      ),
    );
  }

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
                Text('Ilość MasterCoins do kupienia: $coinAmount',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: const Text(
                    'DOpis co to są MasterCoins pewnie będzie dłuższy więc napisze jakieś głupoty żeby bardziej oddawało wizualnie. Litwo ojczyzno moja ty jesteś jak zdrowie ile cie trzeba cenić ten tylko sie dowie kto cie stracił',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
  void _handlePaymentSuccess(BuildContext context) async {
    await Provider.of<CoinData>(context, listen: false).addCoins(coinAmount);
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
  }
}
