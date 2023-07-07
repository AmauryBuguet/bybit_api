class WalletUpdate {
  String topic;
  List<WalletData> data;

  WalletUpdate({
    required this.topic,
    required this.data,
  });

  factory WalletUpdate.fromMap(Map<String, dynamic> json) {
    return WalletUpdate(
      topic: json['topic'],
      data: List<WalletData>.from(json['data'].map((data) => WalletData.fromMap(data))),
    );
  }
}

class WalletData {
  String coin;
  double equity;
  double walletBalance;
  double positionMargin;
  double availableBalance;
  double orderMargin;
  double unrealisedPnl;
  double cumRealisedPnl;

  WalletData({
    required this.coin,
    required this.equity,
    required this.walletBalance,
    required this.positionMargin,
    required this.availableBalance,
    required this.orderMargin,
    required this.unrealisedPnl,
    required this.cumRealisedPnl,
  });

  factory WalletData.fromMap(Map<String, dynamic> json) {
    return WalletData(
      coin: json['coin'],
      equity: double.parse(json['equity']),
      walletBalance: double.parse(json['walletBalance']),
      positionMargin: double.parse(json['positionMargin']),
      availableBalance: double.parse(json['availableBalance']),
      orderMargin: double.parse(json['orderMargin']),
      unrealisedPnl: double.parse(json['unrealisedPnl']),
      cumRealisedPnl: double.parse(json['cumRealisedPnl']),
    );
  }
}
