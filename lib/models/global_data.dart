class GlobalData {
  final double totalMarketCapInUsd;
  final double marketCapChangePercentage24h;
  final double totalVolumeInUsd;
  final double marketCapPercentageBtc;
  final double marketCapPercentageEth;
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
      totalMarketCapInUsd: json['total_market_cap']['usd'] as double,
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h_usd'] as double,
      totalVolumeInUsd: json['total_volume']['usd'] as double,
      marketCapPercentageBtc: json['market_cap_percentage']['btc'] as double,
      marketCapPercentageEth: json['market_cap_percentage']['eth'] as double,
      activeCryptocurrencies: json['active_cryptocurrencies'] as int,
    );
  }

  static GlobalData globalDataFromSnapshot(dynamic snapshot) {
      return GlobalData.fromJson(snapshot);
  }
}