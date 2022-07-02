import 'package:crypto_tracking_app/database/app.dart';
import 'package:crypto_tracking_app/models/coin.api.dart';
import 'package:crypto_tracking_app/models/coin.dart';
import 'package:crypto_tracking_app/views/widgets/ohlc_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart' as realm_package;
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
  late bool _isFav;
  late Coin _coin;
  late int _highLowPercentage;
  late Future _dataFuture;
  late final realm_package.Realm realm;
  late final dynamic subscription;

  _CoinWidgetState() {
    var config =
        realm_package.Configuration.local([FavoriteCoinsDatabase.schema]);
    realm = realm_package.Realm(config);

    subscription = realm.all<FavoriteCoinsDatabase>().changes.listen((changes) {
      if (changes.deleted.isNotEmpty || changes.inserted.isNotEmpty) {
        setState(() {
          _isFav = realm
              .all<FavoriteCoinsDatabase>()
              .query(r'id == $0', [widget.id]).isNotEmpty;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _isFav = realm
        .all<FavoriteCoinsDatabase>()
        .query(r'id == $0', [widget.id]).isNotEmpty;

    _dataFuture = fetchData();
  }

  Future fetchData() async {
    _coin = await CoinApi.getCoin(widget.id);

    _highLowPercentage = (100 * ((_coin.price - _coin.low) / (_coin.high - _coin.low))).toInt();
    if (_highLowPercentage > 100) {
      _highLowPercentage = 100;
    } else if (_highLowPercentage < 0) {
      _highLowPercentage = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('\$###,###,##0.00#########');
    final compactFormatter = NumberFormat.compactCurrency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red),
            onPressed: () {
              if (_isFav) {
                realm.write(() => realm.deleteMany(realm
                    .all<FavoriteCoinsDatabase>()
                    .query(r'id == $0', [widget.id])));
              } else {
                realm.write(() => realm.add(FavoriteCoinsDatabase(widget.id)));
              }
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
          if (snapshot.connectionState == ConnectionState.done) {
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
                            color: Colors.grey,
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
                            color: (_coin.priceChangePercentage24h < 0
                                ? Colors.red
                                : Colors.green),
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
                            color: Colors.grey,
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
                            color: (_coin.marketCapChangePercentage24h < 0
                                ? Colors.red
                                : Colors.green),
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
                            color: Colors.grey,
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
                            color: Colors.grey,
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
                  unselectedColor: Colors.grey.shade800,
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
                OhlcWidget(id: widget.id),
                const SizedBox(height: 20),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
