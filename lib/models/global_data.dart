class GlobalData {
  final num totalMarketCapInUsd;
  final num marketCapChangePercentage24h;
  final num totalVolumeInUsd;
  final num marketCapPercentageBtc;
  final num marketCapPercentageEth;
  final int activeCryptocurrencies;

  GlobalData({
    required this.totalMarketCapInUsd,
    required this.marketCapChangePercentage24h,
    required this.totalVolumeInUsd,
    required this.marketCapPercentageBtc,
    required this.marketCapPercentageEth,
    required this.activeCryptocurrencies,
  });

  factory GlobalData.fromJson(dynamic json) {
    return GlobalData(
      totalMarketCapInUsd: json['total_market_cap']['usd'] as num,
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h_usd'] as num,
      totalVolumeInUsd: json['total_volume']['usd'] as num,
      marketCapPercentageBtc: json['market_cap_percentage']['btc'] as num,
      marketCapPercentageEth: json['market_cap_percentage']['eth'] as num,
      activeCryptocurrencies: json['active_cryptocurrencies'] as int,
    );
  }

  static GlobalData globalDataFromSnapshot(dynamic snapshot) {
      return GlobalData.fromJson(snapshot);
  }
}