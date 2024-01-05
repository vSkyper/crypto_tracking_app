class GlobalDataModel {
  final num totalMarketCapInUsd;
  final num marketCapChangePercentage24h;
  final num totalVolumeInUsd;
  final num marketCapPercentageBtc;
  final num marketCapPercentageEth;
  final int activeCryptocurrencies;

  GlobalDataModel({
    required this.totalMarketCapInUsd,
    required this.marketCapChangePercentage24h,
    required this.totalVolumeInUsd,
    required this.marketCapPercentageBtc,
    required this.marketCapPercentageEth,
    required this.activeCryptocurrencies,
  });

  factory GlobalDataModel.fromJson(dynamic json) {
    return GlobalDataModel(
      totalMarketCapInUsd: json['total_market_cap']['usd'] as num,
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h_usd'] as num,
      totalVolumeInUsd: json['total_volume']['usd'] as num,
      marketCapPercentageBtc: json['market_cap_percentage']['btc'] as num,
      marketCapPercentageEth: json['market_cap_percentage']['eth'] as num,
      activeCryptocurrencies: json['active_cryptocurrencies'] as int,
    );
  }

  static GlobalDataModel globalDataFromSnapshot(dynamic snapshot) {
    return GlobalDataModel.fromJson(snapshot);
  }
}
