import 'package:crypto_tracking/models/coins.api.dart';
import 'package:crypto_tracking/models/coins.dart';
import 'package:crypto_tracking/models/global_data.api.dart';
import 'package:crypto_tracking/models/global_data.dart';
import 'package:crypto_tracking/views/favorite_coins.dart';
import 'package:crypto_tracking/views/widgets/coin_card.dart';
import 'package:crypto_tracking/views/widgets/global_data.dart';
import 'package:flutter/material.dart';

class Coins extends StatefulWidget {
  const Coins({super.key});

  @override
  State<Coins> createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  late GlobalDataModel _globalData;
  late List<CoinsModel> _coins;
  late List<CoinsModel> _searchedCoins;
  late Future _dataFuture;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dataFuture = _fetchData();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final List responses = await Future.wait([GlobalDataApi.getGlobalData(), CoinsApi.getCoins()]);
      _globalData = responses[0];
      _coins = responses[1];
      _searchedCoins = _coins;
      _controller.clear();
    } catch (e) {
      rethrow;
    }
  }

  void _searchCoins(String value) {
    setState(() {
      _searchedCoins = _coins.where((item) => item.name.toLowerCase().contains(value.toLowerCase())).toList();
    });
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
          IconButton(
            icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FavoriteCoins(),
              ),
            ),
          ),
        ],
        title: const Row(
          children: [
            Icon(Icons.euro),
            SizedBox(width: 10),
            Text('Cryptocurrency'),
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
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          GlobalData(globalData: _globalData),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _controller,
                              onChanged: (value) => _searchCoins(value),
                              decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                suffixIcon: _controller.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          _controller.clear();
                                          _searchCoins('');
                                        },
                                        icon: const Icon(Icons.close),
                                      )
                                    : null,
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Search',
                              ),
                            ),
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
                                  currentPrice: _searchedCoins[index].currentPrice,
                                  priceChangePercentage24h: _searchedCoins[index].priceChangePercentage24h,
                                  image: _searchedCoins[index].image,
                                  rank: _searchedCoins[index].rank,
                                );
                              },
                            ),
                          ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
