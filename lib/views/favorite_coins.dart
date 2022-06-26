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
  late List<Coins> _coins;
  late Stream _streamFetchData;

  @override
  void initState() {
    super.initState();

    _streamFetchData = fetchData();
  }

  Stream fetchData() async* {
    _coins = await CoinsApi.getCoins();
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<FavoriteCoinsListModel>();

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: _streamFetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Coins> favoriteCoins = _coins
                .where((item) => model.favoriteCoins.contains(item.id))
                .toList();

            if (favoriteCoins.isEmpty) {
              return const Align(
                alignment: Alignment.topCenter,
                child: Text('You don\'t have any favorite coins :('),
              );
            } else {
              return ListView.builder(
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
                      image: favoriteCoins[index].image,
                      rank: favoriteCoins[index].rank,
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
