import 'package:crypto_tracking_app/models/coin.api.dart';
import 'package:crypto_tracking_app/models/coin.dart';
import 'package:crypto_tracking_app/models/favorite_coins_list_model.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    _coin = await CoinApi.getCoin(widget.id);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isFav = context.select<FavoriteCoinsListModel, bool>(
      (favoriteCoins) => favoriteCoins.getFavoriteCoins().contains(widget.id),
    );

    final formatter = NumberFormat();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Price:'),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${_coin.price}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 7),
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
                  Expanded(
                    child: ListView(
                      children: [
                        Stack(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Market Capitalization'),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '\$${formatter.format(_coin.marketCap)}'),
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
                              child: Text(
                                  '\$${formatter.format(_coin.totalVolume)}'),
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
                              child: Text(formatter.format(_coin.totalVolume / _coin.marketCap)),
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
                              child: Text('\$${formatter.format(_coin.low)} / \$${formatter.format(_coin.high)}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
