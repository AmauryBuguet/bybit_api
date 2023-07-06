enum Channel {
  usdtContract("contract/usdt/public/v3"),
  inverseContract("contract/inverse/public/v3"),
  usdcContract("contract/usdc/public/v3"),
  usdcOption("option/usdc/public/v3"),
  privateUnified("unified/private/v3"),
  privateContract("contract/private/v3");

  final String str;

  const Channel(this.str);

  static Channel publicChannelFromSymbol(String symbol) {
    if (symbol.endsWith("USDT")) {
      return Channel.usdtContract;
    } else if (symbol.endsWith("PERP")) {
      return Channel.usdcContract;
    } else if (symbol.endsWith("USD")) {
      return Channel.inverseContract;
    } else {
      return Channel.usdcOption;
    }
  }

  bool isPrivate() {
    return str.contains("private");
  }
}
