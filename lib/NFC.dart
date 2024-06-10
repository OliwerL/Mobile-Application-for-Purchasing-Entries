import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NfcSendExample extends StatefulWidget {
  @override
  _NfcSendExampleState createState() => _NfcSendExampleState();
}

class _NfcSendExampleState extends State<NfcSendExample> {
  String _message = 'Poprawnie przesłano';
  String? _userId;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _userId = user.uid;
          _message = _userId!;
        });
      }
    });
    _startNfcSession();
  }

  void _fetchUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      _message = _userId!;
      _message = "RollMaster Card";
    }
  }

  void _startNfcSession() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          print('NFC tag is not ndef or not writable');
          return;
        }

        try {
          await ndef.write(NdefMessage([
            NdefRecord.createText(_message),
          ]));
          print('Message sent: $_message');
          _showDialog('Sukces', 'Wiadomość została przesłana.');
        } catch (e) {
          print('Failed to write to NFC tag: $e');
          _showDialog('Błąd', 'Nie udało się zapisać na tagu NFC.');
        }
      },
      onError: (e) async {
        print('Error starting NFC session: $e');
        _showDialog('Błąd NFC', 'Wystąpił błąd podczas uruchamiania sesji NFC: $e');
      },
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('RollMaster Card'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.2,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/3.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'Jeśli jesteś nowym użytkownikiem przyłóź urządzenie do karty, aby stworzyć swoją MasterCard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
