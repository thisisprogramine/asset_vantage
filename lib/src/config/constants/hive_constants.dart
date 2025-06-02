class HiveBox {
  HiveBox._();

  static const String userPreferenceBox = 'userPreferenceBox';
  static const String appPreferenceBox = 'appPreferenceBox';
  static const String credentialBox = 'credentialBox';

  static const String dashboardData = 'dashboardData';

  static const String getUserBox = 'getUserBox';
  static const String entityBox = 'entityBox';
  static const String currencyBox = 'currencyBox';
  static const String ipsBox = 'ipsBox';
  static const String performanceBox = 'performanceBox';
  static String performanceFilterBox({required String postFix}) => 'performanceFilterBox_$postFix';
  static const String cashBalanceBox = 'cashBalanceBox';
  static String cashBalanceFilterBox({required String postFix}) => 'cashBalanceFilterBox_$postFix';
  static const String netWorthBox = 'netWorthBox';
  static String netWorthFilterBox({required String postFix}) => 'netWorthFilterBox_$postFix';
  static const String incomeBox = 'incomeBox';
  static String incomeFilterBox({required String postFix}) => 'incomeFilterBox_$postFix';
  static String expenseFilterBox({required String postFix}) => 'expenseFilterBox_$postFix';
  static const String expenseBox = 'expenseBox';
  static const String filterBox = 'filterBox';
  static const String chatBox = 'chatBox';
  static const String perfomanceSortReport = 'perfomanceSortReport';
}

class HiveFields {
  HiveFields._();

  static const String userPreference = 'userPreference';

  static const String preferredLanguage = 'preferredLanguage';
  static const String preferredTheme = 'preferredTheme';
  static const String credential = 'credential';


  static const String entityData = 'entityData';

  static const String currencyData = 'currencyData';

  static const String userData = 'userData';

  static const String dashboardListSequence = 'dashboardListSequence';

  static const String ipsReport = 'ipsReport';
  static const String ipsGrouping = 'performanceGrouping';
  static const String ipsSubGrouping = 'ipsSubGrouping';
  static const String ipsPolicies = 'performancePolicies';
  static const String ipsYears = 'performanceYears';

  static const String performanceReport = 'performanceReport';
  static const String performancePrimaryGrouping = 'performancePrimaryGrouping';
  static const String performancePrimarySubGrouping = 'performancePrimarySubGrouping';
  static const String performanceSecondaryGrouping = 'performanceSecondaryGrouping';
  static const String performanceSecondarySubGrouping = 'performanceSecondarySubGrouping';


  static const String performanceSelectedEntity = 'performanceSelectedEntity';
  static const String performanceSelectedPrimaryGrouping = 'performanceSelectedPrimaryGrouping';
  static const String performanceSelectedPrimarySubGrouping = 'performanceSelectedPrimarySubGrouping';
  static const String performanceSelectedSecondaryGrouping = 'performanceSelectedSecondaryGrouping';
  static const String performanceSelectedSecondarySubGrouping = 'performanceSelectedSecondarySubGrouping';
  static const String performanceSelectedReturnPercent = 'performanceSelectedReturnPercent';
  static const String performanceSelectedCurrency = 'performanceSelectedCurrency';
  static const String performanceSelectedDenomination = 'performanceSelectedDenomination';
  static const String performanceSelectedAsOnDate = 'performanceSelectedAsOnDate';
  static const String performanceSortReport = 'performanceSortReport';
  static const String performanceSortMarketValueSelection = 'performanceSortMarketValueSelection';
  static const String performanceSelectedPartnershipMethod = 'performanceSelectedPartnershipMethod';
  static const String performanceSelectedHoldingMethod = 'performanceSelectedHoldingMethod';


  static const String incomeSelectedEntity = 'performanceSelectedEntity';
  static const String incomeSelectedAccounts = 'incomeSelectedAccounts';
  static const String incomeSelectedPeriod = 'incomeSelectedPeriod';
  static const String incomeSelectedNumberOfPeriod = 'incomeSelectedNumberOfPeriod';
  static const String incomeSelectedCurrency = 'performanceSelectedCurrency';
  static const String incomeSelectedDenomination = 'performanceSelectedDenomination';
  static const String incomeSelectedAsOnDate = 'performanceSelectedAsOnDate';

  static const String expenseSelectedEntity = 'expenseSelectedEntity';
  static const String expenseSelectedAccounts = 'expenseSelectedAccounts';
  static const String expenseSelectedPeriod = 'expenseSelectedPeriod';
  static const String expenseSelectedNumberOfPeriod = 'expenseSelectedNumberOfPeriod';
  static const String expenseSelectedCurrency = 'expenseSelectedCurrency';
  static const String expenseSelectedDenomination = 'expenseSelectedDenomination';
  static const String expenseSelectedAsOnDate = 'expenseSelectedAsOnDate';




  static const String performanceSortItem = 'performanceSortItem';
  static const String performanceTopItem = 'performanceTopItem';

  static const String netWorthReport = 'netWorthReport';
  static const String netWorthGrouping = 'netWorthGrouping';
  static const String netWorthSubGrouping = 'netWorthSubGrouping';

  static const String netWorthSelectedEntity = 'netWorthSelectedEntity';
  static const String netWorthSelectedPrimaryGrouping = 'netWorthSelectedPrimaryGrouping';
  static const String netWorthSelectedPrimarySubGrouping = 'netWorthSelectedPrimarySubGrouping';
  static const String netWorthSelectedPeriod = 'netWorthSelectedPeriod';
  static const String netWorthSelectedNumberOfPeriod = 'netWorthSelectedNumberOfPeriod';
  static const String netWorthSelectedReturnPercent = 'netWorthSelectedReturnPercent';
  static const String netWorthSelectedCurrency = 'netWorthSelectedCurrency';
  static const String netWorthSelectedDenomination = 'netWorthSelectedDenomination';
  static const String netWorthSelectedAsOnDate = 'netWorthSelectedAsOnDate';
  static const String netWorthSelectedPartnershipMethod = 'netWorthSelectedPartnershipMethod';
  static const String netWorthSelectedHoldingMethod = 'netWorthSelectedHoldingMethod';


  static const String cashBalanceReport = 'cashBalanceReport';
  static const String cashBalanceGrouping = 'cashBalanceGrouping';
  static const String cashBalanceSubGrouping = 'cashBalanceSubGrouping';
  static const String cashBalanceAccounts = 'cashBalanceAccounts';

  static const String cashBalanceSelectedEntity = 'cashBalanceSelectedEntity';
  static const String cashBalanceSelectedPrimaryGrouping = 'cashBalanceSelectedPrimaryGrouping';
  static const String cashBalanceSelectedPrimarySubGrouping = 'cashBalanceSelectedPrimarySubGrouping';
  static const String cashBalanceSelectedPeriod = 'cashBalanceSelectedPeriod';
  static const String cashBalanceSelectedNumberOfPeriod = 'cashBalanceSelectedNumberOfPeriod';
  static const String cashBalanceSelectedCurrency = 'cashBalanceSelectedCurrency';
  static const String cashBalanceSelectedDenomination = 'cashBalanceSelectedDenomination';
  static const String cashBalanceSelectedAsOnDate = 'cashBalanceSelectedAsOnDate';
  static const String cashBalanceSelectedAccounts = 'cashBalanceSelectedAccounts';

  static const String incomeAccount = 'incomeAccount';
  static const String incomeReport = 'incomeReport';

  static const String expenseAccount = 'expenseAccount';
  static const String expenseReport = 'expenseReport';

  static const String selectedEntity = 'selectedEntity';
  static const String selectedDocumentEntity = 'selectedDocumentEntity';
  static const String selectedIpsPolicyFilter = 'selected-ips-policy-filter';
  static const String selectedIpsSubFilter = 'selected-ips-sub-filter';
  static const String selectedIpsReturnFilter = 'selected-ips-return-filter';
  static const String selectedCBSubFilter = 'selected-cb-sub-filter';
  static const String selectedNWSubFilter = 'selected-nw-sub-filter';
  static const String selectedNWNoOfPeriods = 'selected-nw-no-of-periods';
  static const String selectedNWPeriods = 'selected-nw-period';
  static const String selectedPerSubFilter = 'selected-per-sub-filter';
  static const String selectedPerTopItem = 'selected-per-top-item';
  static const String selectedIncExpFilter = 'selected-inc-exp-filter';
  static const String selectedIncExpNoOfPeriods = 'selected-inc-exp-no-of-periods';
  static const String selectedCBSortFilter = 'selected-cb-sort-filter';
  static const String selectedCurrencyFilter = 'selected-currency-filter';
  static const String selectedDenominationFilter = 'selected-denomination-filter';
  static const String selectedNWReturnPercent = 'selected-nw-return-percent';
}