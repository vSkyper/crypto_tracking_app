import 'package:crypto_tracking_app/models/coins.api.dart';
import 'package:crypto_tracking_app/models/coins.dart';
import 'package:crypto_tracking_app/models/global_data.api.dart';
import 'package:crypto_tracking_app/models/global_data.dart';
import 'package:crypto_tracking_app/views/favorite_coins.dart';
import 'package:crypto_tracking_app/views/widgets/coin_card.dart';
import 'package:crypto_tracking_app/views/widgets/global_data_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GlobalData _globalData;
  late List<Coins> _coins;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    _globalData = await GlobalDataApi.getGlobalData();
    _coins = await CoinsApi.getCoins();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              if (!_isLoading) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavoriteCoins(coins: _coins),
                  ),
                );
              }
            },
          ),
        ],
        title: Row(
          children: const [
            Icon(Icons.euro),
            SizedBox(width: 10),
            Text('Cryptocurrency'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _coins.length,
                itemBuilder: (context, index) {
                  var coinCard = CoinCard(
                      id: _coins[index].id,
                      name: _coins[index].name,
                      symbol: _coins[index].symbol,
                      currentPrice: _coins[index].currentPrice,
                      priceChangePercentage24h:
                          _coins[index].priceChangePercentage24h,
                      image: _coins[index].image);

                  if (index == 0) {
                    return Column(
                      children: [
                        GlobalDataWidget(globalData: _globalData),
                        const SizedBox(height: 20),
                        coinCard
                      ],
                    );
                  }

                  return coinCard;
                },
              ),
            ),
    );
  }
}
