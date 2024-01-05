import 'package:crypto_tracking/database/app.dart';
import 'package:crypto_tracking/models/coins.api.dart';
import 'package:crypto_tracking/models/coins.dart';
import 'package:crypto_tracking/views/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart' as realm_package;

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
  late final realm_package.Realm realm;
  late final dynamic subscription;

  _FavoriteCoinsState() {
    var config = realm_package.Configuration.local([FavoriteCoinsDatabase.schema]);
    realm = realm_package.Realm(config);

    subscription = realm.all<FavoriteCoinsDatabase>().changes.listen((changes) {
      if (changes.deleted.isNotEmpty || changes.inserted.isNotEmpty) {
        setState(() {
          _dataFuture = fetchData();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _dataFuture = fetchData();
  }

  @override
  void dispose() {
    super.dispose();

    realm.close();
  }

  Future<void> fetchData() async {
    List favoriteCoins = realm.all<FavoriteCoinsDatabase>().map((data) => data.id).toList();

    if (favoriteCoins.isEmpty) {
      _favoriteCoins = [];
    } else {
      _favoriteCoins = await CoinsApi.getCoins(ids: favoriteCoins.join(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.refresh, color: Colors.grey.shade700),
            onPressed: () => setState(() {
              _dataFuture = fetchData();
            }),
          ),
        ],
      ),
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
                    priceChangePercentage24h: _favoriteCoins[index].priceChangePercentage24h,
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
