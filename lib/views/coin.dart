import 'package:crypto_tracking_app/models/coin.api.dart';
import 'package:crypto_tracking_app/models/coin.dart';
import 'package:crypto_tracking_app/models/favorite_coins_list_model.dart';
import 'package:crypto_tracking_app/views/widgets/ohlc_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  late Coin _coin;
  late Future _dataFuture;

  @override
  void initState() {
    super.initState();

    _dataFuture = fetchData();
  }

  Future fetchData() async {
    _coin = await CoinApi.getCoin(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    bool isFav = context.select<FavoriteCoinsListModel, bool>(
      (favoriteCoins) => favoriteCoins.favoriteCoins.contains(widget.id),
    );

    final formatter = NumberFormat.currency(symbol: '\$');
    final compactFormatter = NumberFormat.compactCurrency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red),
            onPressed: () {
              var model = context.read<FavoriteCoinsListModel>();
              model.toggleFavorite(widget.id);
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
