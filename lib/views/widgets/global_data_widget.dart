import 'package:crypto_tracking_app/models/global_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GlobalDataWidget extends StatelessWidget {
  final GlobalData globalData;

  const GlobalDataWidget({
    Key? key,
    required this.globalData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(height: 1.5),
        children: [
          TextSpan(
              text:
                  'The global cryptocurrency market cap today is \$${(globalData.totalMarketCapInUsd / pow(10, 12)).toStringAsFixed(2)} Trillion, a '),
          TextSpan(
            text:
                '${globalData.marketCapChangePercentage24h.toStringAsFixed(2)}% ',
            style: TextStyle(
              color: (globalData.marketCapChangePercentage24h < 0
                  ? Colors.red
                  : Colors.green),
            ),
          ),
          TextSpan(
              text:
                  'change in the last 24 hours. Total cryptocurrency trading volume in the last day is at \$${(globalData.totalVolumeInUsd / pow(10, 9)).toStringAsFixed(2)} Billion. Bitcoin dominance is at ${globalData.marketCapPercentageBtc.toStringAsFixed(2)}% and Ethereum dominance is at ${globalData.marketCapPercentageEth.toStringAsFixed(2)}%. CoinGecko is now tracking ${globalData.activeCryptocurrencies} cryptocurrencies.')
        ],
      ),
    );
  }
}