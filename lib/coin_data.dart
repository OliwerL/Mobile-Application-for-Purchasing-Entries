import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinData with ChangeNotifier {
  int _myMastercoin = 0;
  List<String> purchasedTickets = [];

  int get myMastercoin => _myMastercoin;

  void addCoins(int coins) {
    _myMastercoin += coins;
    notifyListeners();  // Powiadamiając obserwujące widgety o zmianie
  }
  void buyTicket(String ticketName) {
    purchasedTickets.add(ticketName);
    // Tutaj możesz także zaktualizować stan mastercoin, jeśli taki jest mechanizm
    notifyListeners();
  }
}
