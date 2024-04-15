import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NfcSendExample extends StatefulWidget {
  @override
  _NfcSendExampleState createState() => _NfcSendExampleState();
}


class _NfcSendExampleState extends State<NfcSendExample> {


  String _message = 'Poprawnie przesłano';
  String? _userId;  // Dodaj zmienną do przechowywania userId

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _userId = user.uid;
          _message = _userId!; // Uaktualnij _message gdy użytkownik się zmienia
        });
      }
    });
    _startNfcSession();
  }
  void _fetchUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;  // Przypisz userId do zmiennej
      _message = _userId!; // Ustaw _message na userId
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
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Send Example'),
      ),
      body: Center(
        child: Text('Przyłóż urządzenie NFC do taga, aby przesłać wiadomość.'),
      ),
    );
  }
}
