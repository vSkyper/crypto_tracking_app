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
  late Stream _streamFetchData;

  @override
  void initState() {
    super.initState();

    _streamFetchData = fetchData();
  }

  Stream fetchData() async* {
    _coin = await CoinApi.getCoin(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var isFav = context.select<FavoriteCoinsListModel, bool>(
      (favoriteCoins) => favoriteCoins.getFavoriteCoins().contains(widget.id),
    );

    final formatter = NumberFormat.currency(symbol: '\$');

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
            Image.network(widget.image, width: 30, height: 30),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _streamFetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              padding: const EdgeInsets.only(left: 15, right: 15),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text(
                  'Current Price:',
                  style: TextStyle(fontSize: 17.5),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formatter.format(_coin.price),
                      style: const TextStyle(
                          fontSize: 19.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
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
                const SizedBox(height: 20),
                OhlcWidget(id: widget.id),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Market Capitalization'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(formatter.format(_coin.marketCap)),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                Stack(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('24h Trading Volume'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(formatter.format(_coin.totalVolume)),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                Stack(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Volume / Market Cap'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(formatter
                          .format(_coin.totalVolume / _coin.marketCap)),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                Stack(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('24h Low / 24h High'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${formatter.format(_coin.low)} / ${formatter.format(_coin.high)}'),
                    ),
                  ],
                ),
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
