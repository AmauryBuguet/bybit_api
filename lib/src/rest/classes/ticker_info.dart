class TickerInfo {
  String symbol;
  double bidPrice;
  double askPrice;
  double lastPrice;
  String lastTickDirection;
  double prevPrice24h;
  double price24hPcnt;
  double highPrice24h;
  double lowPrice24h;
  double prevPrice1h;
  double markPrice;
  double indexPrice;
  double openInterest;
  double turnover24h;
  double volume24h;
  double fundingRate;
  int nextFundingTime;
  double? predictedDeliveryPrice;
  double? basisRate;
  double? deliveryFeeRate;
  int deliveryTime;
  double openInterestValue;

  TickerInfo({
    required this.symbol,
    required this.bidPrice,
    required this.askPrice,
    required this.lastPrice,
    required this.lastTickDirection,
    required this.prevPrice24h,
    required this.price24hPcnt,
    required this.highPrice24h,
    required this.lowPrice24h,
    required this.prevPrice1h,
    required this.markPrice,
    required this.indexPrice,
    required this.openInterest,
    required this.turnover24h,
    required this.volume24h,
    required this.fundingRate,
    required this.nextFundingTime,
    required this.predictedDeliveryPrice,
    required this.basisRate,
    required this.deliveryFeeRate,
    required this.deliveryTime,
    required this.openInterestValue,
  });

  factory TickerInfo.fromMap(Map<String, dynamic> map) {
    return TickerInfo(
      symbol: map['symbol'],
      bidPrice: double.parse(map['bidPrice']),
      askPrice: double.parse(map['askPrice']),
      lastPrice: double.parse(map['lastPrice']),
      lastTickDirection: map['lastTickDirection'],
      prevPrice24h: double.parse(map['prevPrice24h']),
      price24hPcnt: double.parse(map['price24hPcnt']),
      highPrice24h: double.parse(map['highPrice24h']),
      lowPrice24h: double.parse(map['lowPrice24h']),
      prevPrice1h: double.parse(map['prevPrice1h']),
      markPrice: double.parse(map['markPrice']),
      indexPrice: double.parse(map['indexPrice']),
      openInterest: double.parse(map['openInterest']),
      turnover24h: double.parse(map['turnover24h']),
      volume24h: double.parse(map['volume24h']),
      fundingRate: double.parse(map['fundingRate']),
      nextFundingTime: int.parse(map['nextFundingTime']),
      predictedDeliveryPrice: double.tryParse(map['predictedDeliveryPrice']),
      basisRate: double.tryParse(map['basisRate']),
      deliveryFeeRate: double.tryParse(map['deliveryFeeRate']),
      deliveryTime: int.parse(map['deliveryTime']),
      openInterestValue: double.parse(map['openInterestValue']),
    );
  }
}
