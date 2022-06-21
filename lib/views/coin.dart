import 'package:crypto_tracking_app/models/coin.api.dart';
import 'package:crypto_tracking_app/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoinWidget extends StatefulWidget {
  final String id;
  final String name;
  final String image;

  const CoinWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  State<CoinWidget> createState() => _CoinWidgetState();
}

class _CoinWidgetState extends State<CoinWidget> {
  late Coin _coin;
  bool _isFav = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    _coin = await CoinApi.getCoin(widget.id);

    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteCoins = prefs.getStringList('favoriteCoins');

    if (favoriteCoins != null) {
      _isFav = favoriteCoins.contains(widget.id);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteCoins = prefs.getStringList('favoriteCoins');

    favoriteCoins ??= [];

    if (favoriteCoins.contains(widget.id)) {
      favoriteCoins.remove(widget.id);
    } else {
      favoriteCoins.add(widget.id);
    }

    prefs.setStringList('favoriteCoins', favoriteCoins);

    setState(() {
      _isFav = !_isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red),
            onPressed: () {
              _toggleFavorite();
            },
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(widget.image, width: 30, height: 30),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Text(_coin.price.toString()),
            ),
    );
  }
}
