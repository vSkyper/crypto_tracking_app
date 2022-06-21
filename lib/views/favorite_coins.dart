import 'package:crypto_tracking_app/models/coins.dart';
import 'package:crypto_tracking_app/views/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCoins extends StatefulWidget {
  final List<Coins> coins;

  const FavoriteCoins({Key? key, required this.coins}) : super(key: key);

  @override
  State<FavoriteCoins> createState() => _FavoriteCoinsState();
}

class _FavoriteCoinsState extends State<FavoriteCoins> {
  late List<Coins> _favoriteCoins;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteCoins = prefs.getStringList('favoriteCoins');

    favoriteCoins ??= [];

    _favoriteCoins =
        widget.coins.where((item) => favoriteCoins!.contains(item.id)).toList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: _favoriteCoins.isEmpty
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: Text('You don\'t have any favorite coins :('))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _favoriteCoins.length,
                      itemBuilder: (context, index) {
                        return CoinCard(
                            id: _favoriteCoins[index].id,
                            name: _favoriteCoins[index].name,
                            symbol: _favoriteCoins[index].symbol,
                            currentPrice: _favoriteCoins[index].currentPrice,
                            priceChangePercentage24h:
                                _favoriteCoins[index].priceChangePercentage24h,
                            image: _favoriteCoins[index].image);
                      },
                    ),
            ),
    );
  }
}
