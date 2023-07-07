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

enum OrderFilter {
  order("Order"),
  stopOrder("StopOrder");

  final String str;

  const OrderFilter(this.str);

  static OrderFilter fromStr(String str) {
    return OrderFilter.values.singleWhere((e) => e.str == str);
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

enum SymbolStatus {
  preLaunch("PreLaunch"),
  trading("Trading"),
  settling("Settling"),
  delivering("Delivering"),
  closed("Closed");

  final String str;

  const SymbolStatus(this.str);

  static SymbolStatus fromStr(String str) {
    return SymbolStatus.values.singleWhere((e) => e.str == str);
  }
}

enum ContractType {
  inversePerpetual("InversePerpetual"),
  linearPerpetual("LinearPerpetual"),
  linearFutures("LinearFutures"),
  inverseFutures("InverseFutures");

  final String str;

  const ContractType(this.str);

  static ContractType fromStr(String str) {
    return ContractType.values.singleWhere((e) => e.str == str);
  }
}
