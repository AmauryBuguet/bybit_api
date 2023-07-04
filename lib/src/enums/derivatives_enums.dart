import 'package:collection/collection.dart';

enum Category {
  linear("linear"),
  inverse("inverse"),
  option("option");

  final String str;

  const Category(this.str);

  static Category fromStr(String str) {
    return Category.values.singleWhere((e) => e.str == str);
  }
}

enum PositionIdx {
  oneWayMode("0"),
  buySideOfHedgeMode("1"),
  sellSideOfHedgeMode("2");

  final String str;
  const PositionIdx(this.str);
  static PositionIdx? fromStr(String str) {
    return PositionIdx.values.singleWhereOrNull((e) => e.str == str);
  }
}

enum PositionStatus {
  normal("Normal"),
  liquidationInProgress("Liq"),
  autoDeleverageInProgress("Adl");

  final String str;

  const PositionStatus(this.str);

  static PositionStatus fromStr(String str) {
    return PositionStatus.values.singleWhere((e) => e.str == str);
  }
}

enum Interval {
  m1("1"),
  m3("3"),
  m5("5"),
  m15("15"),
  m30("30"),
  h1("60"),
  h2("120"),
  h4("240"),
  h6("360"),
  h12("720"),
  daily("D"),
  weekly("W"),
  monthly("M");

  final String str;

  const Interval(this.str);

  static Interval fromStr(String str) {
    return Interval.values.singleWhere((e) => e.str == str);
  }
}

enum TriggerBy {
  lastPrice("LastPrice"),
  markPrice("MarkPrice"),
  indexPrice("IndexPrice");

  final String str;

  const TriggerBy(this.str);

  static TriggerBy? fromStr(String str) {
    return TriggerBy.values.singleWhereOrNull((e) => e.str == str);
  }
}

enum TimeInForce {
  goodTillCancel("GoodTillCancel"),
  immediateOrCancel("ImmediateOrCancel"),
  fillOrKill("FillOrKill"),
  postOnly("PostOnly");

  final String str;

  const TimeInForce(this.str);

  static TimeInForce fromStr(String str) {
    return TimeInForce.values.singleWhere((e) => e.str == str);
  }
}

enum OrderFilter {
  order("Order"),
  stopOrder("StopOrder");

  final String str;

  const OrderFilter(this.str);

  static OrderFilter fromStr(String str) {
    return OrderFilter.values.singleWhere((e) => e.str == str);
  }
}

enum OrderStatus {
  created("Created"),
  newStatus("New"),
  rejected("Rejected"),
  partiallyFilled("PartiallyFilled"),
  filled("Filled"),
  pendingCancel("PendingCancel"),
  cancelled("Cancelled"),
  untriggered("Untriggered"),
  triggered("Triggered"),
  deactivated("Deactivated"),
  active("Active");

  final String str;

  const OrderStatus(this.str);

  static OrderStatus fromStr(String str) {
    return OrderStatus.values.singleWhere((e) => e.str == str);
  }
}

enum CancelType {
  cancelByUser("CancelByUser"),
  cancelByReduceOnly("CancelByReduceOnly"),
  cancelByPrepareLiq("CancelByPrepareLiq"),
  cancelAllBeforeLiq("CancelAllBeforeLiq"),
  cancelByPrepareAdl("CancelByPrepareAdl"),
  cancelAllBeforeAdl("CancelAllBeforeAdl"),
  cancelByAdmin("CancelByAdmin"),
  cancelByTpSlTsClear("CancelByTpSlTsClear"),
  cancelByPzSideCh("CancelByPzSideCh"),
  cancelBySmp("CancelBySmp");

  final String str;

  const CancelType(this.str);

  static CancelType? fromStr(String str) {
    return CancelType.values.singleWhereOrNull((e) => e.str == str);
  }
}

enum StopOrderType {
  takeProfit("TakeProfit"),
  stopLoss("StopLoss"),
  trailingStop("TrailingStop"),
  stop("Stop"),
  partialTakeProfit("PartialTakeProfit"),
  partialStopLoss("PartialStopLoss");

  final String str;

  const StopOrderType(this.str);

  static StopOrderType? fromStr(String str) {
    return StopOrderType.values.singleWhereOrNull((e) => e.str == str);
  }
}

enum RejectReason {
  ecNoError("EC_NoError"),
  ecOthers("EC_Others"),
  ecUnknownMessageType("EC_UnknownMessageType"),
  ecMissingClOrdID("EC_MissingClOrdID"),
  ecMissingOrigClOrdID("EC_MissingOrigClOrdID"),
  ecClOrdIDOrigClOrdIDAreTheSame("EC_ClOrdIDOrigClOrdIDAreTheSame"),
  ecDuplicatedClOrdID("EC_DuplicatedClOrdID"),
  ecOrigClOrdIDDoesNotExist("EC_OrigClOrdIDDoesNotExist"),
  ecTooLateToCancel("EC_TooLateToCancel"),
  ecUnknownOrderType("EC_UnknownOrderType"),
  ecUnknownSide("EC_UnknownSide"),
  ecUnknownTimeInForce("EC_UnknownTimeInForce"),
  ecWronglyRouted("EC_WronglyRouted"),
  ecMarketOrderPriceIsNotZero("EC_MarketOrderPriceIsNotZero"),
  ecLimitOrderInvalidPrice("EC_LimitOrderInvalidPrice"),
  ecNoEnoughQtyToFill("EC_NoEnoughQtyToFill"),
  ecNoImmediateQtyToFill("EC_NoImmediateQtyToFill"),
  ecPerCancelRequest("EC_PerCancelRequest"),
  ecMarketOrderCannotBePostOnly("EC_MarketOrderCannotBePostOnly"),
  ecPostOnlyWillTakeLiquidity("EC_PostOnlyWillTakeLiquidity"),
  ecCancelReplaceOrder("EC_CancelReplaceOrder"),
  ecInvalidSymbolStatus("EC_InvalidSymbolStatus");

  final String str;

  const RejectReason(this.str);

  static RejectReason? fromStr(String str) {
    return RejectReason.values.singleWhereOrNull((e) => e.str == str);
  }
}

enum PositionMode {
  oneWayMode("0"),
  hedgeMode("3");

  final String str;

  const PositionMode(this.str);

  static PositionMode fromStr(String str) {
    return PositionMode.values.singleWhere((e) => e.str == str);
  }
}

enum ExecType {
  trade("Trade"),
  adlTrade("AdlTrade"),
  funding("Funding"),
  bustTrade("BustTrade"),
  settle("Settle");

  final String str;

  const ExecType(this.str);

  static ExecType fromStr(String str) {
    return ExecType.values.singleWhere((e) => e.str == str);
  }
}

enum LastLiquidityInd {
  taker("TAKER"),
  maker("MAKER"),
  addedLiquidity("AddedLiquidity"),
  removedLiquidity("RemovedLiquidity");

  final String str;

  const LastLiquidityInd(this.str);

  static LastLiquidityInd fromStr(String str) {
    return LastLiquidityInd.values.singleWhere((e) => e.str == str);
  }
}

enum WalletFundType {
  deposit("Deposit"),
  withdraw("Withdraw"),
  realisedPNL("RealisedPNL"),
  commission("Commission"),
  refund("Refund"),
  prize("Prize"),
  exchangeOrderWithdraw("ExchangeOrderWithdraw"),
  exchangeOrderDeposit("ExchangeOrderDeposit"),
  returnServiceCash("ReturnServiceCash"),
  insurance("Insurance"),
  subMember("SubMember"),
  coupon("Coupon"),
  accountTransfer("AccountTransfer"),
  cashBack("CashBack");

  final String str;

  const WalletFundType(this.str);

  static WalletFundType fromStr(String str) {
    return WalletFundType.values.singleWhere((e) => e.str == str);
  }
}

enum BalanceUpdateType {
  transferIn("TRANSFER_IN"),
  transferOut("TRANSFER_OUT"),
  trade("TRADE"),
  settlement("SETTLEMENT"),
  delivery("DELIVERY"),
  liquidation("LIQUIDATION"),
  bonus("BONUS"),
  feeRefund("FEE_REFUND"),
  interest("INTEREST"),
  currencyBuy("CURRENCY_BUY"),
  currencySell("CURRENCY_SELL");

  final String str;

  const BalanceUpdateType(this.str);

  static BalanceUpdateType fromStr(String str) {
    return BalanceUpdateType.values.singleWhere((e) => e.str == str);
  }
}

enum TickDirection {
  plusTick("PlusTick"),
  zeroPlusTick("ZeroPlusTick"),
  minusTick("MinusTick"),
  zeroMinusTick("ZeroMinusTick");

  final String str;

  const TickDirection(this.str);

  static TickDirection fromStr(String str) {
    return TickDirection.values.singleWhere((e) => e.str == str);
  }
}

enum SmpType {
  none("None"),
  cancelMaker("CancelMaker"),
  cancelTaker("CancelTaker"),
  cancelBoth("CancelBoth");

  final String str;

  const SmpType(this.str);

  static SmpType fromStr(String str) {
    return SmpType.values.singleWhere((e) => e.str == str);
  }
}

enum UnifiedMarginStatus {
  regularAccount("1"),
  unifiedMarginAccount("2"),
  unifiedTradeAccount("3");

  final String str;

  const UnifiedMarginStatus(this.str);

  static UnifiedMarginStatus fromStr(String str) {
    return UnifiedMarginStatus.values.singleWhere((e) => e.str == str);
  }
}

enum Side {
  buy("Buy"),
  sell("Sell");

  final String str;

  const Side(this.str);

  static Side fromStr(String str) {
    return Side.values.singleWhere((e) => e.str == str);
  }
}

enum OrderType {
  market("Market"),
  limit("Limit");

  final String str;

  const OrderType(this.str);

  static OrderType fromStr(String str) {
    return OrderType.values.singleWhere((e) => e.str == str);
  }
}

enum TriggerDirection {
  rise("1"),
  fall("2");

  final String str;

  const TriggerDirection(this.str);

  static TriggerDirection? fromStr(String str) {
    return TriggerDirection.values.singleWhereOrNull((e) => e.str == str);
  }
}

enum TpSlMode {
  full("Full"),
  partial("Partial");

  final String str;

  const TpSlMode(this.str);

  static TpSlMode? fromStr(String str) {
    return TpSlMode.values.singleWhereOrNull((e) => e.str == str);
  }
}

enum TradeMode {
  crossMargin("0"),
  isolatedMargin("1");

  final String str;

  const TradeMode(this.str);

  static TradeMode fromStr(String str) {
    return TradeMode.values.singleWhere((e) => e.str == str);
  }
}
