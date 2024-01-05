import 'dart:convert';
import 'package:crypto_tracking/models/global_data.dart';
import 'package:http/http.dart';

class GlobalDataApi {
  static Future<GlobalDataModel> getGlobalData() async {
    try {
      final Uri uri = Uri.https('api.coingecko.com', '/api/v3/global');

      final Response response = await get(uri);

      if (response.statusCode != 200) throw Exception('Error getting global data');

      final Map data = json.decode(response.body);

      return GlobalDataModel.globalDataFromSnapshot(data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
