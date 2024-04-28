import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinData with ChangeNotifier {
  int _myMastercoin = 0;

  int get myMastercoin => _myMastercoin;

  void addCoins(int coins) {
    _myMastercoin += coins;
    notifyListeners();  // Powiadamiając obserwujące widgety o zmianie
  }
}
