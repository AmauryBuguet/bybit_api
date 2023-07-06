enum UpdateType {
  delta,
  snapshot;

  static UpdateType fromStr(String str) {
    return UpdateType.values.singleWhere((e) => e.name == str);
  }
}
