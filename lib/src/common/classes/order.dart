import '../enums/common_enums.dart';

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
  TpSlMode? tpslMode;
  TriggerBy? tpTriggerBy;
  TriggerBy? slTriggerBy;
  TriggerBy? triggerBy;
  double? tpLimitPrice;
  double? slLimitPrice;
  bool reduceOnly;
  bool closeOnTrigger;
  double leavesQty;
  double leavesValue;
  double cumExecQty;
  double cumExecValue;
  double cumExecFee;
  TriggerDirection? triggerDirection;
  CancelType? cancelType;
  SmpType smpType;
  int smpGroup;
  String? smpOrderId;
  RejectReason? rejectReason;
  PositionIdx? positionIdx;
  String? blockTradeId;
  double? lastExecQty;
  double? lastExecPrice;
  double? avgPrice;
  double? lastPriceOnCreated;

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
    required this.avgPrice,
    required this.lastExecPrice,
    required this.lastExecQty,
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
      lastExecQty: double.tryParse(map['lastExecQty'] ?? ""),
      lastExecPrice: double.tryParse(map['lastExecPrice'] ?? ""),
      avgPrice: double.tryParse(map['avgPrice'] ?? ""),
    );
  }
}
