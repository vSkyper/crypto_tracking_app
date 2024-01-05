import 'dart:async';
import 'package:crypto_tracking/database/app.dart';
import 'package:crypto_tracking/models/coin.api.dart';
import 'package:crypto_tracking/models/coin.dart';
import 'package:crypto_tracking/views/widgets/ohlc_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart' as realm_package;
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Coin extends StatefulWidget {
  final String id;
  final String name;
  final String image;

  const Coin({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  State<Coin> createState() => _CoinState();
}

class _CoinState extends State<Coin> {
  late bool _isFav;
  late CoinModel _coin;
  late int _highLowPercentage;
  late Future _dataFuture;
  late final realm_package.Realm _realm;
  late final StreamSubscription<realm_package.RealmResultsChanges<FavoriteCoinsDatabase>> _subscription;

  _CoinState() {
    final realm_package.Configuration config = realm_package.Configuration.local([FavoriteCoinsDatabase.schema]);
    _realm = realm_package.Realm(config);

    _subscription = _realm.all<FavoriteCoinsDatabase>().changes.listen((changes) {
      if (changes.deleted.isNotEmpty || changes.inserted.isNotEmpty) {
        setState(() {
          _isFav = _realm.all<FavoriteCoinsDatabase>().query(r'id == $0', [widget.id]).isNotEmpty;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _isFav = _realm.all<FavoriteCoinsDatabase>().query(r'id == $0', [widget.id]).isNotEmpty;
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
      _coin = await CoinApi.getCoin(widget.id);

      _highLowPercentage = (100 * ((_coin.price - _coin.low) / (_coin.high - _coin.low))).round();
      if (_highLowPercentage > 100) {
        _highLowPercentage = 100;
      }
      if (_highLowPercentage < 0) {
        _highLowPercentage = 0;
      }
    } catch (e) {
      rethrow;
    }
  }

  void _refreshCoin() {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat('\$###,###,##0.00#########');
    final NumberFormat compactFormatter = NumberFormat.compactCurrency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCoin,
          ),
          IconButton(
            icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              if (_isFav) {
                _realm.write(
                    () => _realm.deleteMany(_realm.all<FavoriteCoinsDatabase>().query(r'id == $0', [widget.id])));
                return;
              }
              _realm.write(() => _realm.add(FavoriteCoinsDatabase(widget.id)));
            },
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(widget.image, width: 25, height: 25),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
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
              return ListView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Price',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(formatter.format(_coin.price)),
                          const SizedBox(height: 5),
                          Text(
                            '${_coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: (_coin.priceChangePercentage24h < 0 ? Colors.red : Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Market Capitalization',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(compactFormatter.format(_coin.marketCap)),
                          const SizedBox(height: 5),
                          Text(
                            '${_coin.marketCapChangePercentage24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: (_coin.marketCapChangePercentage24h < 0 ? Colors.red : Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rank',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(_coin.rank.toString()),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '24h Trading Volume',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(compactFormatter.format(_coin.totalVolume)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StepProgressIndicator(
                    totalSteps: 100,
                    currentStep: _highLowPercentage,
                    size: 8,
                    padding: 0,
                    unselectedColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                    roundedEdges: const Radius.circular(10),
                    selectedGradientColor: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.yellow.shade700, Colors.green.shade700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatter.format(_coin.low)),
                      const Text('24h Range'),
                      Text(formatter.format(_coin.high)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Ohlc(id: widget.id),
                  const SizedBox(height: 20),
                ],
              );
          }
        },
      ),
    );
  }
}
