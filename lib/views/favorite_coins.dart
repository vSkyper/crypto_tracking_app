import 'package:crypto_tracking_app/database/app.dart';
import 'package:crypto_tracking_app/models/coins.api.dart';
import 'package:crypto_tracking_app/models/coins.dart';
import 'package:crypto_tracking_app/views/widgets/coin_card.dart';
import 'package:flutter/material.dart';

class FavoriteCoins extends StatefulWidget {
  const FavoriteCoins({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoriteCoins> createState() => _FavoriteCoinsState();
}

class _FavoriteCoinsState extends State<FavoriteCoins> {
  late List<Coins> _favoriteCoins;
  late Future _dataFuture;
  late final dynamic subscription;

  @override
  void initState() {
    super.initState();

    subscription = realm.all<FavoriteCoinsDatabase>().changes.listen((changes) {
      if (changes.deleted.isNotEmpty || changes.inserted.isNotEmpty) {
        setState(() {
          _dataFuture = fetchData();
        });
      }
    });

    _dataFuture = fetchData();
  }

  Future<void> fetchData() async {
    var favoriteCoins = realm.all<FavoriteCoinsDatabase>();
    var temp = [];

    for (var i in favoriteCoins) {
      temp.add(i.id);
    }

    if (temp.isEmpty) {
      _favoriteCoins = [];
    } else {
      _favoriteCoins = await CoinsApi.getCoins(ids: temp.join(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _dataFuture,
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
