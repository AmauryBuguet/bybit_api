import '../enums/common_enums.dart';

class Position {
  PositionIdx? positionIdx;
  int riskId;
  String symbol;
  Side side;
  double size;
  double positionValue;
  double entryPrice;
  TradeMode tradeMode;
  bool autoAddMargin;
  int leverage;
  double positionBalance;
  double liqPrice;
  double bustPrice;
  double takeProfit;
  double stopLoss;
  double trailingStop;
  double unrealisedPnl;
  int createdTime;
  int updatedTime;
  TpSlMode? tpSlMode;
  int riskLimitValue;
  double sessionAvgPrice;
  PositionStatus positionStatus;
  double occClosingFee;
  double markPrice;
  double cumRealisedPnl;
  String positionMM;
  String positionIM;
  double? avgPrice;
  int adlRankIndicator;
  double activePrice;

  Position({
    required this.positionIdx,
    required this.riskId,
    required this.symbol,
    required this.side,
    required this.size,
    required this.positionValue,
    required this.entryPrice,
    required this.tradeMode,
    required this.autoAddMargin,
    required this.leverage,
    required this.positionBalance,
    required this.liqPrice,
    required this.bustPrice,
    required this.takeProfit,
    required this.stopLoss,
    required this.trailingStop,
    required this.unrealisedPnl,
    required this.createdTime,
    required this.updatedTime,
    required this.tpSlMode,
    required this.riskLimitValue,
    required this.activePrice,
    required this.markPrice,
    required this.cumRealisedPnl,
    required this.positionMM,
    required this.positionIM,
    required this.positionStatus,
    required this.sessionAvgPrice,
    required this.occClosingFee,
    required this.avgPrice,
    required this.adlRankIndicator,
  });

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
      positionIdx: PositionIdx.fromStr((map['positionIdx'] as int).toString()),
      riskId: map['riskId'],
      symbol: map['symbol'],
      side: Side.fromStr(map['side']),
      size: double.parse(map['size']),
      positionValue: double.parse(map['positionValue']),
      entryPrice: double.parse(map['entryPrice']),
      tradeMode: TradeMode.fromStr((map['tradeMode'] as int).toString()),
      autoAddMargin: map['autoAddMargin'] == 1,
      leverage: int.parse(map['leverage']),
      positionBalance: double.parse(map['positionBalance']),
      liqPrice: double.parse(map['liqPrice']),
      bustPrice: double.parse(map['bustPrice']),
      takeProfit: double.parse(map['takeProfit']),
      stopLoss: double.parse(map['stopLoss']),
      trailingStop: double.parse(map['trailingStop']),
      unrealisedPnl: double.parse(map['unrealisedPnl']),
      createdTime: int.parse(map['createdTime']),
      updatedTime: int.parse(map['updatedTime']),
      tpSlMode: TpSlMode.fromStr(map['tpSlMode']),
      riskLimitValue: int.parse(map['riskLimitValue']),
      activePrice: double.parse(map['activePrice']),
      markPrice: double.parse(map['markPrice']),
      cumRealisedPnl: double.parse(map['cumRealisedPnl']),
      positionMM: map['positionMM'],
      positionIM: map['positionIM'],
      positionStatus: PositionStatus.fromStr(map['positionStatus']),
      sessionAvgPrice: double.parse(map['sessionAvgPrice']),
      occClosingFee: double.parse(map['occClosingFee']),
      avgPrice: double.tryParse(map['avgPrice'] ?? ""),
      adlRankIndicator: map['adlRankIndicator'],
    );
  }
}
