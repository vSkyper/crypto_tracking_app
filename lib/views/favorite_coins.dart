import 'package:crypto_tracking_app/models/coins.api.dart';
import 'package:crypto_tracking_app/models/coins.dart';
import 'package:crypto_tracking_app/models/favorite_coins_list_model.dart';
import 'package:crypto_tracking_app/views/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCoins extends StatefulWidget {
  const FavoriteCoins({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoriteCoins> createState() => _FavoriteCoinsState();
}

class _FavoriteCoinsState extends State<FavoriteCoins> {
  late List<Coins> _favoriteCoins;

  Future<void> fetchData(model) async {
    _favoriteCoins =
        await CoinsApi.getCoins(ids: model.favoriteCoins.join(','));
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<FavoriteCoinsListModel>();

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: fetchData(model),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_favoriteCoins.isEmpty) {
              return const Align(
                alignment: Alignment.topCenter,
                child: Text('You don\'t have any favorite coins :('),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(left: 15, right: 15),
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
                    image: _favoriteCoins[index].image,
                    rank: _favoriteCoins[index].rank,
                  );
                },
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
