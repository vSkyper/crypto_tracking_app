import 'dart:math';
import 'package:crypto_tracking_app/models/global_data.api.dart';
import 'package:crypto_tracking_app/models/global_data.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GlobalData _globalData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    getGlobalData();
  }

  Future<void> getGlobalData() async {
    _globalData = await GlobalDataApi.getGlobalData();
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
        title: Row(
          children: const [
            Icon(Icons.euro),
            SizedBox(width: 10),
            Text('Cryptocurrency'),
            Spacer(),
            Icon(Icons.favorite, color: Colors.red),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Text(
                      'The global cryptocurrency market cap today is \$${(_globalData.totalMarketCapInUsd / pow(10, 12)).toStringAsFixed(2)} Trillion, a ${_globalData.marketCapChangePercentage24h.toStringAsFixed(2)}% change in the last 24 hours. Total cryptocurrency trading volume in the last day is at \$${(_globalData.totalVolumeInUsd / pow(10, 9)).toStringAsFixed(2)} Billion. Bitcoin dominance is at ${_globalData.marketCapPercentageBtc.toStringAsFixed(2)}% and Ethereum dominance is at ${_globalData.marketCapPercentageEth.toStringAsFixed(2)}%. CoinGecko is now tracking ${_globalData.activeCryptocurrencies} cryptocurrencies.')
                ],
              ),
            ),
    );
  }
}
