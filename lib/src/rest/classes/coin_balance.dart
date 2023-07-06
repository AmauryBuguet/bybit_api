class CoinBalance {
  String coin;
  double equity;
  double walletBalance;
  double positionMargin;
  double availableBalance;
  double orderMargin;
  double occClosingFee;
  double occFundingFee;
  double unrealisedPnl;
  double cumRealisedPnl;
  double givenCash;
  double serviceCash;
  double? accountIM;
  double? accountMM;

  CoinBalance({
    required this.coin,
    required this.equity,
    required this.walletBalance,
    required this.positionMargin,
    required this.availableBalance,
    required this.orderMargin,
    required this.occClosingFee,
    required this.occFundingFee,
    required this.unrealisedPnl,
    required this.cumRealisedPnl,
    required this.givenCash,
    required this.serviceCash,
    required this.accountIM,
    required this.accountMM,
  });

  factory CoinBalance.fromMap(Map<String, dynamic> map) {
    return CoinBalance(
      coin: map['coin'],
      equity: double.parse(map['equity']),
      walletBalance: double.parse(map['walletBalance']),
      positionMargin: double.parse(map['positionMargin']),
      availableBalance: double.parse(map['availableBalance']),
      orderMargin: double.parse(map['orderMargin']),
      occClosingFee: double.parse(map['occClosingFee']),
      occFundingFee: double.parse(map['occFundingFee']),
      unrealisedPnl: double.parse(map['unrealisedPnl']),
      cumRealisedPnl: double.parse(map['cumRealisedPnl']),
      givenCash: double.parse(map['givenCash']),
      serviceCash: double.parse(map['serviceCash']),
      accountIM: double.tryParse(map['accountIM']),
      accountMM: double.tryParse(map['accountMM']),
    );
  }
}
