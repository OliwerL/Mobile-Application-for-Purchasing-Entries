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
