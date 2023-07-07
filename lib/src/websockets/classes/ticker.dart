import '../../common/enums/common_enums.dart';
import '../enums/update_type.dart';

class TickerUpdate {
  String topic;
  UpdateType type;
  TickerData data;
  int crossSequence;
  int ts;

  TickerUpdate({
    required this.topic,
    required this.type,
    required this.data,
    required this.crossSequence,
    required this.ts,
  });

  factory TickerUpdate.fromMap(Map<String, dynamic> json) {
    return TickerUpdate(
      topic: json['topic'],
      type: UpdateType.fromStr(json['type']),
      data: TickerData.fromMap(json['data']),
      crossSequence: json['cs'],
      ts: json['ts'],
    );
  }
}

class TickerData {
  String symbol;
  TickDirection? tickDirection;
  double? price24hPcnt;
  double? lastPrice;
  double? prevPrice24h;
  double? highPrice24h;
  double? lowPrice24h;
  double? prevPrice1h;
  double? markPrice;
  double? indexPrice;
  double? openInterest;
  double? openInterestValue;
  double? turnover24h;
  double? volume24h;
  int? nextFundingTime;
  double? fundingRate;
  double? bid1Price;
  double? bid1Size;
  double? ask1Price;
  double? ask1Size;

  TickerData({
    required this.symbol,
    required this.tickDirection,
    required this.price24hPcnt,
    required this.lastPrice,
    required this.prevPrice24h,
    required this.highPrice24h,
    required this.lowPrice24h,
    required this.prevPrice1h,
    required this.markPrice,
    required this.indexPrice,
    required this.openInterest,
    required this.openInterestValue,
    required this.turnover24h,
    required this.volume24h,
    required this.nextFundingTime,
    required this.fundingRate,
    required this.bid1Price,
    required this.bid1Size,
    required this.ask1Price,
    required this.ask1Size,
  });

  factory TickerData.fromMap(Map<String, dynamic> json) {
    return TickerData(
      symbol: json['symbol'],
      tickDirection: json['tickDirection'] != null ? TickDirection.fromStr(json['tickDirection']) : null,
      price24hPcnt: double.tryParse(json['price24hPcnt'] ?? ""),
      lastPrice: double.tryParse(json['lastPrice'] ?? ""),
      prevPrice24h: double.tryParse(json['prevPrice24h'] ?? ""),
      highPrice24h: double.tryParse(json['highPrice24h'] ?? ""),
      lowPrice24h: double.tryParse(json['lowPrice24h'] ?? ""),
      prevPrice1h: double.tryParse(json['prevPrice1h'] ?? ""),
      markPrice: double.tryParse(json['markPrice'] ?? ""),
      indexPrice: double.tryParse(json['indexPrice'] ?? ""),
      openInterest: double.tryParse(json['openInterest'] ?? ""),
      openInterestValue: double.tryParse(json['openInterestValue'] ?? ""),
      turnover24h: double.tryParse(json['turnover24h'] ?? ""),
      volume24h: double.tryParse(json['volume24h'] ?? ""),
      nextFundingTime: int.tryParse(json['nextFundingTime'] ?? ""),
      fundingRate: double.tryParse(json['fundingRate'] ?? ""),
      bid1Price: double.tryParse(json['bid1Price'] ?? ""),
      bid1Size: double.tryParse(json['bid1Size'] ?? ""),
      ask1Price: double.tryParse(json['ask1Price'] ?? ""),
      ask1Size: double.tryParse(json['ask1Size'] ?? ""),
    );
  }
}
