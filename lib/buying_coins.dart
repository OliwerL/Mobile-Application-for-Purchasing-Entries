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
        amount: (coinAmount * 0.02).toString(), // Set your coin price here
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double totalPrice = coinAmount * 0.02;
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
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(25.0),
                  child: const Text(
                    'MasterCoin umożliwiają wejście na kryty skatepark MasterHouse zlokalizowany w Olsztynie przy ulicy Sokolej 6c. Jeden MasterCoin umożliwia wejście na 1 godzinę jazdy swobodnej na skateparku. W przypadku chęci dłuższego pozostania na obiekcie użytkownik zobowiązany jest do wymiany liczby MasterCoin odpowiadającej liczbie godzin spędzonych na skateparku.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Cena: ${totalPrice.toStringAsFixed(2)} PLN',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
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
