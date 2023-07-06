class FeeRate {
  String symbol;
  double takerFeeRate;
  double makerFeeRate;

  FeeRate({
    required this.symbol,
    required this.takerFeeRate,
    required this.makerFeeRate,
  });

  factory FeeRate.fromMap(Map<String, dynamic> map) {
    return FeeRate(
      symbol: map['symbol'],
      takerFeeRate: double.parse(map['takerFeeRate']),
      makerFeeRate: double.parse(map['makerFeeRate']),
    );
  }
}
