import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCoinsListModel extends ChangeNotifier {
  List<String> _favoriteCoins = [];

  FavoriteCoinsListModel() {
    SharedPreferences.getInstance().then((prefs) {
      _favoriteCoins = prefs.getStringList('favoriteCoins') ?? [];
      notifyListeners();
    });
  }

  Future<void> _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteCoins', _favoriteCoins);
  }

  Future<void> toggleFavorite(id) async {
    if (_favoriteCoins.contains(id)) {
      _favoriteCoins.remove(id);
    } else {
      _favoriteCoins.add(id);
    }

    _setPrefItems();
    notifyListeners();
  }

  List<String> get favoriteCoins => _favoriteCoins;
}
