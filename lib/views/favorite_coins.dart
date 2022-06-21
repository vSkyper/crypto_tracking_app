import 'dart:collection';
import 'package:crypto_tracking_app/models/coin.dart';
import 'package:crypto_tracking_app/models/coins.dart';
import 'package:crypto_tracking_app/views/widgets/coin_card.dart';
import 'package:flutter/material.dart';

class FavoriteCoins extends StatelessWidget {
  final List<Coins> coins;

  const FavoriteCoins({Key? key, required this.coins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: coins.length,
          itemBuilder: (context, index) {
            return CoinCard(
                id: coins[index].id,
                name: coins[index].name,
                symbol: coins[index].symbol,
                currentPrice: coins[index].currentPrice,
                priceChangePercentage24h: coins[index].priceChangePercentage24h,
                image: coins[index].image);
          },
        ),
      ),
    );
  }
}
