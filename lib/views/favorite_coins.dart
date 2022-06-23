import 'package:crypto_tracking_app/models/coins.dart';
import 'package:crypto_tracking_app/models/favorite_coins_list_model.dart';
import 'package:crypto_tracking_app/views/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCoins extends StatelessWidget {
  final List<Coins> coins;

  const FavoriteCoins({
    Key? key,
    required this.coins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<FavoriteCoinsListModel>();

    List<Coins> favoriteCoins = coins
        .where((item) => model.getFavoriteCoins().contains(item.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
      ),
      body: favoriteCoins.isEmpty
          ? const Align(
              alignment: Alignment.topCenter,
              child: Text('You don\'t have any favorite coins :('))
          : ListView.builder(
              padding: const EdgeInsets.only(left: 15, right: 15),
              physics: const BouncingScrollPhysics(),
              itemCount: favoriteCoins.length,
              itemBuilder: (context, index) {
                return CoinCard(
                    id: favoriteCoins[index].id,
                    name: favoriteCoins[index].name,
                    symbol: favoriteCoins[index].symbol,
                    currentPrice: favoriteCoins[index].currentPrice,
                    priceChangePercentage24h:
                        favoriteCoins[index].priceChangePercentage24h,
                    image: favoriteCoins[index].image);
              },
            ),
    );
  }
}
