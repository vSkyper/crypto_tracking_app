import 'dart:convert';
import 'package:crypto_tracking_app/models/coin.dart';
import 'package:http/http.dart' as http;

class CoinApi {
  static Future<Coin> getCoin(id) async {
    var uri = Uri.https('api.coingecko.com', '/api/v3/coins/$id', {
      'localization': 'false',
      'tickers': 'false',
      'market_data': 'true',
      'community_data': 'false',
      'developer_data': 'false',
      'sparkline': 'false',
    });

    final response = await http.get(uri);

    Map data = json.decode(response.body);

    return Coin.coinFromSnapshot(data);
  }
}
