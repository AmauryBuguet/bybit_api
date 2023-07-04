import '../enums/derivatives_enums.dart';

class BybitException implements Exception {
  final String message;
  final int code;

  BybitException(this.message, this.code);

  @override
  String toString() => 'BybitException $code : $message';
}

class Kline {
  int timestamp;
  double open;
  double high;
  double low;
  double close;
  double volume;
  double turnover;

  Kline({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.turnover,
  });

  factory Kline.fromList(List<dynamic> list) {
    if (list.length != 7) {
      throw FormatException('Invalid list length. Expected 7 elements.');
    }

    return Kline(
      timestamp: int.parse(list[0]),
      open: double.parse(list[1]),
      high: double.parse(list[2]),
      low: double.parse(list[3]),
      close: double.parse(list[4]),
      volume: double.parse(list[5]),
      turnover: double.parse(list[6]),
    );
  }
}

class BookOrder {
  double price;
  double qty;

  BookOrder({
    required this.price,
    required this.qty,
  });

  factory BookOrder.fromList(List<dynamic> list) {
    if (list.length != 2) {
      throw FormatException('Invalid list length. Expected 2 elements.');
    }

    return BookOrder(
      price: double.parse(list[0]),
      qty: double.parse(list[1]),
    );
  }
}

class OrderBook {
  List<BookOrder> asks;
  List<BookOrder> bids;
  int timestamp;
  int updateId;
  String symbol;

  OrderBook({
    required this.asks,
    required this.bids,
    required this.timestamp,
    required this.updateId,
    required this.symbol,
  });

  factory OrderBook.fromMap(Map<String, dynamic> map) {
    return OrderBook(
      asks: List<BookOrder>.from(
        (map['a'] as List<dynamic>).map<BookOrder>(
          (x) => BookOrder.fromList(x as List<dynamic>),
        ),
      ),
      bids: List<BookOrder>.from(
        (map['b'] as List<dynamic>).map<BookOrder>(
          (x) => BookOrder.fromList(x as List<dynamic>),
        ),
      ),
      timestamp: map['ts'] as int,
      updateId: map['u'] as int,
      symbol: map['s'] as String,
    );
  }
}

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

class Order {
  String symbol;
  String orderId;
  Side side;
  OrderType orderType;
  StopOrderType? stopOrderType;
  double price;
  double qty;
  TimeInForce timeInForce;
  OrderStatus orderStatus;
  double triggerPrice;
  String? orderLinkId;
  int createdTime;
  int updatedTime;
  double takeProfit;
  double stopLoss;
  TriggerBy? tpTriggerBy;
  TriggerBy? slTriggerBy;
  TriggerBy? triggerBy;
  bool reduceOnly;
  double leavesQty;
  double leavesValue;
  double cumExecQty;
  double cumExecValue;
  double cumExecFee;
  TriggerDirection? triggerDirection;
  CancelType? cancelType;
  double? lastPriceOnCreated;
  bool closeOnTrigger;
  TpSlMode? tpslMode;
  double? tpLimitPrice;
  double? slLimitPrice;
  SmpType smpType;
  int smpGroup;
  String? smpOrderId;
  RejectReason? rejectReason;
  PositionIdx? positionIdx;
  String? blockTradeId;

  Order({
    required this.symbol,
    required this.orderId,
    required this.side,
    required this.orderType,
    required this.stopOrderType,
    required this.price,
    required this.qty,
    required this.timeInForce,
    required this.orderStatus,
    required this.triggerPrice,
    required this.orderLinkId,
    required this.createdTime,
    required this.updatedTime,
    required this.takeProfit,
    required this.stopLoss,
    required this.tpTriggerBy,
    required this.slTriggerBy,
    required this.triggerBy,
    required this.reduceOnly,
    required this.leavesQty,
    required this.leavesValue,
    required this.cumExecQty,
    required this.cumExecValue,
    required this.cumExecFee,
    required this.triggerDirection,
    required this.cancelType,
    required this.lastPriceOnCreated,
    required this.closeOnTrigger,
    required this.tpslMode,
    required this.tpLimitPrice,
    required this.slLimitPrice,
    required this.smpType,
    required this.smpGroup,
    required this.smpOrderId,
    required this.rejectReason,
    required this.positionIdx,
    required this.blockTradeId,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      symbol: map['symbol'],
      orderId: map['orderId'],
      side: Side.fromStr(map['side']),
      orderType: OrderType.fromStr(map['orderType']),
      stopOrderType: StopOrderType.fromStr(map['stopOrderType']),
      price: double.parse(map['price']),
      qty: double.parse(map['qty']),
      timeInForce: TimeInForce.fromStr(map['timeInForce']),
      orderStatus: OrderStatus.fromStr(map['orderStatus']),
      triggerPrice: double.parse(map['triggerPrice']),
      orderLinkId: map['orderLinkId'],
      createdTime: int.parse(map['createdTime']),
      updatedTime: int.parse(map['updatedTime']),
      takeProfit: double.parse(map['takeProfit']),
      stopLoss: double.parse(map['stopLoss']),
      tpTriggerBy: TriggerBy.fromStr(map['tpTriggerBy']),
      slTriggerBy: TriggerBy.fromStr(map['slTriggerBy']),
      triggerBy: TriggerBy.fromStr(map['triggerBy']),
      reduceOnly: map['reduceOnly'],
      leavesQty: double.parse(map['leavesQty']),
      leavesValue: double.parse(map['leavesValue']),
      cumExecQty: double.parse(map['cumExecQty']),
      cumExecValue: double.parse(map['cumExecValue']),
      cumExecFee: double.parse(map['cumExecFee']),
      triggerDirection: TriggerDirection.fromStr((map['triggerDirection'] as int).toString()),
      cancelType: CancelType.fromStr(map['cancelType']),
      lastPriceOnCreated: double.tryParse(map['lastPriceOnCreated']),
      closeOnTrigger: map['closeOnTrigger'],
      tpslMode: TpSlMode.fromStr(map['tpslMode']),
      tpLimitPrice: double.tryParse(map['tpLimitPrice']),
      slLimitPrice: double.tryParse(map['slLimitPrice']),
      smpType: SmpType.fromStr(map['smpType']),
      smpGroup: map['smpGroup'],
      smpOrderId: map['smpOrderId'],
      rejectReason: RejectReason.fromStr(map['rejectReason'] ?? ""),
      positionIdx: map.containsKey("positionIdx") ? PositionIdx.fromStr((map['positionIdx'] as int).toString()) : null,
      blockTradeId: map['blockTradeId'],
    );
  }
}

class Position {
  PositionIdx positionIdx;
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
  TpSlMode tpSlMode;
  int riskLimitValue;
  double activePrice;
  double markPrice;
  double cumRealisedPnl;
  String positionMM;
  String positionIM;
  PositionStatus positionStatus;
  double sessionAvgPrice;
  double occClosingFee;
  double avgPrice;
  int adlRankIndicator;

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
      positionIdx: PositionIdx.fromStr(map['positionIdx']) ?? PositionIdx.oneWayMode,
      riskId: map['riskId'],
      symbol: map['symbol'],
      side: Side.fromStr(map['side']),
      size: double.parse(map['size']),
      positionValue: double.parse(map['positionValue']),
      entryPrice: double.parse(map['entryPrice']),
      tradeMode: TradeMode.fromStr(map['tradeMode']),
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
      tpSlMode: TpSlMode.fromStr(map['tpSlMode']) ?? TpSlMode.full,
      riskLimitValue: int.parse(map['riskLimitValue']),
      activePrice: double.parse(map['activePrice']),
      markPrice: double.parse(map['markPrice']),
      cumRealisedPnl: double.parse(map['cumRealisedPnl']),
      positionMM: map['positionMM'],
      positionIM: map['positionIM'],
      positionStatus: PositionStatus.fromStr(map['positionStatus']),
      sessionAvgPrice: double.parse(map['sessionAvgPrice']),
      occClosingFee: double.parse(map['occClosingFee']),
      avgPrice: double.parse(map['avgPrice']),
      adlRankIndicator: map['adlRankIndicator'],
    );
  }
}

class ClosedPnL {
  String symbol;
  String orderId;
  Side side;
  double qty;
  double orderPrice;
  OrderType orderType;
  ExecType execType;
  double closedSize;
  double cumEntryValue;
  double avgEntryPrice;
  double cumExitValue;
  double avgExitPrice;
  double closedPnl;
  int fillCount;
  int leverage;
  int createdAt;

  ClosedPnL({
    required this.symbol,
    required this.orderId,
    required this.side,
    required this.qty,
    required this.orderPrice,
    required this.orderType,
    required this.execType,
    required this.closedSize,
    required this.cumEntryValue,
    required this.avgEntryPrice,
    required this.cumExitValue,
    required this.avgExitPrice,
    required this.closedPnl,
    required this.fillCount,
    required this.leverage,
    required this.createdAt,
  });

  factory ClosedPnL.fromMap(Map<String, dynamic> map) {
    return ClosedPnL(
      symbol: map['symbol'],
      orderId: map['orderId'],
      side: Side.fromStr(map['side']),
      qty: double.parse(map['qty']),
      orderPrice: double.parse(map['orderPrice']),
      orderType: OrderType.fromStr(map['orderType']),
      execType: ExecType.fromStr(map['execType']),
      closedSize: double.parse(map['closedSize']),
      cumEntryValue: double.parse(map['cumEntryValue']),
      avgEntryPrice: double.parse(map['avgEntryPrice']),
      cumExitValue: double.parse(map['cumExitValue']),
      avgExitPrice: double.parse(map['avgExitPrice']),
      closedPnl: double.parse(map['closedPnl']),
      fillCount: int.parse(map['fillCount']),
      leverage: int.parse(map['leverage']),
      createdAt: int.parse(map['createdAt']),
    );
  }
}

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
