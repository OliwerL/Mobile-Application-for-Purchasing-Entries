import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CoinData with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _myMastercoin = 0;
  List<String> purchasedTickets = [];

  int get myMastercoin => _myMastercoin;

  Future<void> fetchCoins() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User is not logged in");
        return;
      }

      DocumentReference userRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        _myMastercoin = docSnapshot.get('coins');
        notifyListeners();
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching coins: $e");
    }
  }

  Future<void> fetchPurchasedTickets() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User is not logged in");
        return;
      }

      DocumentReference userRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        purchasedTickets.clear();
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        if (data['Karnet_1h'] >= 1) purchasedTickets.add('Karnet 1h');
        if (data['Karnet_4h'] >= 1) purchasedTickets.add('Karnet 4h');
        if (data['Karnet_8h'] >= 1) purchasedTickets.add('Karnet 8h');
        if (data['Karnet_Open'] >= 1) purchasedTickets.add('Karnet Open');

        notifyListeners();
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching purchased tickets: $e");
    }
  }

  Future<void> addCoins(int amount) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User is not logged in");
        return;
      }

      DocumentReference userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'coins': FieldValue.increment(amount),
      });

      await fetchCoins(); // Fetch updated coins after adding
    } catch (e) {
      print("Error adding coins: $e");
    }
  }

  void buyTicket(String ticketName) {
    purchasedTickets.add(ticketName);
    notifyListeners();
  }
}
