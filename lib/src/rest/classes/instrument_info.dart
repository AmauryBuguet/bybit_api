import '../enums/rest_enums.dart';

class InstrumentInfo {
  String symbol;
  ContractType contractType;
  SymbolStatus status;
  String baseCoin;
  String quoteCoin;
  int launchTime;
  int? deliveryTime;
  double? deliveryFeeRate;
  int priceScale;
  LeverageFilter leverageFilter;
  PriceFilter priceFilter;
  LotSizeFilter lotSizeFilter;
  bool unifiedMarginTrade;
  int fundingInterval;
  String settleCoin;

  InstrumentInfo({
    required this.symbol,
    required this.contractType,
    required this.status,
    required this.baseCoin,
    required this.quoteCoin,
    required this.launchTime,
    required this.deliveryTime,
    required this.deliveryFeeRate,
    required this.priceScale,
    required this.leverageFilter,
    required this.priceFilter,
    required this.lotSizeFilter,
    required this.unifiedMarginTrade,
    required this.fundingInterval,
    required this.settleCoin,
  });

  factory InstrumentInfo.fromMap(Map<String, dynamic> json) {
    return InstrumentInfo(
      symbol: json['symbol'],
      contractType: ContractType.fromStr(json['contractType']),
      status: SymbolStatus.fromStr(json['status']),
      baseCoin: json['baseCoin'],
      quoteCoin: json['quoteCoin'],
      launchTime: int.parse(json['launchTime']),
      deliveryTime: int.tryParse(json['deliveryTime']),
      deliveryFeeRate: double.tryParse(json['deliveryFeeRate']),
      priceScale: int.parse(json['priceScale']),
      leverageFilter: LeverageFilter.fromMap(json['leverageFilter']),
      priceFilter: PriceFilter.fromMap(json['priceFilter']),
      lotSizeFilter: LotSizeFilter.fromMap(json['lotSizeFilter']),
      unifiedMarginTrade: json['unifiedMarginTrade'],
      fundingInterval: json['fundingInterval'],
      settleCoin: json['settleCoin'],
    );
  }
}

class LeverageFilter {
  double minLeverage;
  double maxLeverage;
  double leverageStep;

  LeverageFilter({
    required this.minLeverage,
    required this.maxLeverage,
    required this.leverageStep,
  });

  factory LeverageFilter.fromMap(Map<String, dynamic> json) {
    return LeverageFilter(
      minLeverage: double.parse(json['minLeverage']),
      maxLeverage: double.parse(json['maxLeverage']),
      leverageStep: double.parse(json['leverageStep']),
    );
  }
}

class PriceFilter {
  double minPrice;
  double maxPrice;
  double tickSize;

  PriceFilter({
    required this.minPrice,
    required this.maxPrice,
    required this.tickSize,
  });

  factory PriceFilter.fromMap(Map<String, dynamic> json) {
    return PriceFilter(
      minPrice: double.parse(json['minPrice']),
      maxPrice: double.parse(json['maxPrice']),
      tickSize: double.parse(json['tickSize']),
    );
  }
}

class LotSizeFilter {
  double maxOrderQty;
  double minOrderQty;
  double qtyStep;
  double postOnlyMaxOrderQty;

  LotSizeFilter({
    required this.maxOrderQty,
    required this.minOrderQty,
    required this.qtyStep,
    required this.postOnlyMaxOrderQty,
  });

  factory LotSizeFilter.fromMap(Map<String, dynamic> json) {
    return LotSizeFilter(
      maxOrderQty: double.parse(json['maxOrderQty']),
      minOrderQty: double.parse(json['minOrderQty']),
      qtyStep: double.parse(json['qtyStep']),
      postOnlyMaxOrderQty: double.parse(json['postOnlyMaxOrderQty']),
    );
  }
}
