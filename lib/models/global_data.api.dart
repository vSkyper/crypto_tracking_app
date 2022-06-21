import 'dart:convert';
import 'package:crypto_tracking_app/models/global_data.dart';
import 'package:http/http.dart' as http;

class GlobalDataApi {
  static Future<GlobalData> getGlobalData() async {
    var uri = Uri.https('api.coingecko.com', '/api/v3/global');

    final response = await http.get(uri);

    Map data = json.decode(response.body);

    return GlobalData.globalDataFromSnapshot(data['data']);
  }
}
