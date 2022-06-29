import 'package:crypto_tracking_app/models/coins.api.dart';
import 'package:crypto_tracking_app/models/coins.dart';
import 'package:crypto_tracking_app/models/global_data.api.dart';
import 'package:crypto_tracking_app/models/global_data.dart';
import 'package:crypto_tracking_app/views/favorite_coins.dart';
import 'package:crypto_tracking_app/views/widgets/coin_card.dart';
import 'package:crypto_tracking_app/views/widgets/global_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GlobalData _globalData;
  late List<Coins> _coins;
  late List<Coins> _searchedCoins;
  late Future _dataFuture;

  @override
  void initState() {
    super.initState();

    _dataFuture = fetchData();
  }

  Future<void> fetchData() async {
    List responses =
        await Future.wait([GlobalDataApi.getGlobalData(), CoinsApi.getCoins()]);
    _globalData = responses[0];
    _coins = responses[1];
    _searchedCoins = _coins;
  }

  void searchCoins(String value) {
    setState(() {
      _searchedCoins = _coins
          .where(
              (item) => item.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoriteCoins(),
                ),
              );
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
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        GlobalDataWidget(globalData: _globalData),
                        const SizedBox(height: 20),
                        CupertinoSearchTextField(
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            searchCoins(value);
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  _searchedCoins.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text('No result found'),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: _searchedCoins.length,
                            (context, index) {
                              return CoinCard(
                                id: _searchedCoins[index].id,
                                name: _searchedCoins[index].name,
                                symbol: _searchedCoins[index].symbol,
                                currentPrice:
                                    _searchedCoins[index].currentPrice,
                                priceChangePercentage24h: _searchedCoins[index]
                                    .priceChangePercentage24h,
                                image: _searchedCoins[index].image,
                                rank: _searchedCoins[index].rank,
                              );
                            },
                          ),
                        )
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
