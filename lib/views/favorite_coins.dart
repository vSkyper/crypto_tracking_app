import 'dart:async';

import 'package:crypto_tracking/database/app.dart';
import 'package:crypto_tracking/models/coins.api.dart';
import 'package:crypto_tracking/models/coins.dart';
import 'package:crypto_tracking/views/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart' as realm_package;

class FavoriteCoins extends StatefulWidget {
  const FavoriteCoins({super.key});

  @override
  State<FavoriteCoins> createState() => _FavoriteCoinsState();
}

class _FavoriteCoinsState extends State<FavoriteCoins> {
  late List<CoinsModel> _favoriteCoins;
  late Future _dataFuture;
  late final realm_package.Realm _realm;
  late final StreamSubscription<realm_package.RealmResultsChanges<FavoriteCoinsDatabase>> _subscription;

  _FavoriteCoinsState() {
    final realm_package.Configuration config = realm_package.Configuration.local([FavoriteCoinsDatabase.schema]);
    _realm = realm_package.Realm(config);

    _subscription = _realm.all<FavoriteCoinsDatabase>().changes.listen((changes) {
      if (changes.deleted.isNotEmpty || changes.inserted.isNotEmpty) {
        setState(() {
          _dataFuture = _fetchData();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _dataFuture = _fetchData();
  }

  @override
  void dispose() {
    super.dispose();

    _subscription.cancel();
    _realm.close();
  }

  Future<void> _fetchData() async {
    try {
      final List favoriteCoins = _realm.all<FavoriteCoinsDatabase>().map((data) => data.id).toList();

      if (favoriteCoins.isEmpty) {
        _favoriteCoins = [];
        return;
      }
      _favoriteCoins = await CoinsApi.getCoins(ids: favoriteCoins.join(','));
    } catch (e) {
      rethrow;
    }
  }

  void _refreshCoins() {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCoins,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Something went wrong :('));
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (_favoriteCoins.isEmpty) {
                return const Align(
                  alignment: Alignment.topCenter,
                  child: Text('You don\'t have any favorite coins :('),
                );
              }
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
        },
      ),
    );
  }
}
