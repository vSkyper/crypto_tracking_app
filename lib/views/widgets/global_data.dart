import 'package:crypto_tracking/models/global_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalData extends StatelessWidget {
  final GlobalDataModel globalData;
  const GlobalData({
    super.key,
    required this.globalData,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.compactCurrency(symbol: '\$');

    return Text.rich(
      TextSpan(
        style: const TextStyle(height: 1.5, fontSize: 15.5),
        children: [
          TextSpan(
              text:
                  'The global cryptocurrency market cap today is ${formatter.format(globalData.totalMarketCapInUsd)}, a '),
          TextSpan(
            text: '${globalData.marketCapChangePercentage24h.toStringAsFixed(2)}% ',
            style: TextStyle(
              color: (globalData.marketCapChangePercentage24h < 0 ? Colors.red : Colors.green),
            ),
          ),
          TextSpan(
              text:
                  'change in the last 24 hours. Total cryptocurrency trading volume in the last day is at ${formatter.format(globalData.totalVolumeInUsd)}. Bitcoin dominance is at ${globalData.marketCapPercentageBtc.toStringAsFixed(2)}% and Ethereum dominance is at ${globalData.marketCapPercentageEth.toStringAsFixed(2)}%. CoinGecko is now tracking ${globalData.activeCryptocurrencies} cryptocurrencies.')
        ],
      ),
    );
  }
}
