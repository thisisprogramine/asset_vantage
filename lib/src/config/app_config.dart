
enum ReportTile {ipsAssetClass, ipsAdvisor, ipsCurrency, ipsLiquidity, ipsStrategy,
  cbAccount, cbGeography,
  nwAssetClass, nwAdvisor, nwCurrency, nwLiquidity, nwStrategy,
  perAssetClass, perAdvisor, perCurrency, perLiquidity, perStrategy, inc, exp, none}

ReportTile currentTile = ReportTile.none;

class AppConfiguration {
  AppConfiguration._();

  static const bool showInSights = false;

}
