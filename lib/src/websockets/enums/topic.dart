enum Topic {
  orderbook("orderbook"),
  publicTrade("publicTrade"),
  tickers("tickers"),
  kline("kline"),
  liquidation("liquidation"),
  userPosition("user.position"),
  userExecution("user.execution"),
  userOrder("user.order"),
  userWallet("user.wallet");

  final String str;
  const Topic(this.str);
}
