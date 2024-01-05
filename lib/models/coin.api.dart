import 'dart:convert';
import 'package:crypto_tracking/models/coin.dart';
import 'package:http/http.dart';

class CoinApi {
  static Future<CoinModel> getCoin(id) async {
    try {
      final Uri uri = Uri.https('api.coingecko.com', '/api/v3/coins/$id', {
        'localization': 'false',
        'tickers': 'false',
        'market_data': 'true',
        'community_data': 'false',
        'developer_data': 'false',
        'sparkline': 'false',
      });

      final Response response = await get(uri);

      if (response.statusCode != 200) throw Exception('Error getting coin');

      final Map data = json.decode(response.body);

      return CoinModel.coinFromSnapshot(data);
    } catch (e) {
      rethrow;
    }
  }
}
