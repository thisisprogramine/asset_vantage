import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:asset_vantage/src/data/models/expense/expense_account_model.dart';
import 'package:asset_vantage/src/data/models/income/income_account_model.dart';
import 'package:asset_vantage/src/data/models/number_of_period/number_of_period_model.dart';
import 'package:asset_vantage/src/data/models/return_percentage/return_percentage_model.dart';
import 'package:asset_vantage/src/domain/entities/expense/expense_account_entity.dart';
import 'package:asset_vantage/src/domain/entities/income/income_account_entity.dart';
import 'package:asset_vantage/src/domain/entities/number_of_period/number_of_period.dart';
import 'package:asset_vantage/src/domain/entities/period/period_enitity.dart';

import '../../data/models/currency/currency_model.dart';
import '../../data/models/dashboard/dashboard_entity_model.dart';
import '../../data/models/denomination/denomination_model.dart';
import '../../data/models/performance/performance_primary_grouping_model.dart';
import '../../data/models/cash_balance/cash_balance_grouping_model.dart' as cashPrimaryM;
import '../../data/models/performance/performance_secondary_grouping_model.dart';
import '../../data/models/cash_balance/cash_balance_sub_grouping_model.dart' as cashSubPrimaryM;
import '../../data/models/period/period_model.dart';
import '../../domain/entities/currency/currency_entity.dart';
import '../../domain/entities/dashboard/dashboard_list_entity.dart';
import 'package:asset_vantage/src/domain/entities/net_worth/net_worth_return_percent_entity.dart' as returtPerNW;
import 'package:asset_vantage/src/data/models/net_worth/net_worth_return_percent_model.dart' as mReturtPerNW;
import '../../domain/entities/denomination/denomination_entity.dart';
import '../../domain/entities/favorites/favorites_entity.dart';
import '../../domain/entities/performance/performance_primary_grouping_entity.dart' as primary;
import '../../domain/entities/cash_balance/cash_balance_grouping_entity.dart' as cashPrimary;
import '../../domain/entities/performance/performance_primary_sub_grouping_enity.dart' as subPrimary;
import '../../domain/entities/cash_balance/cash_balance_sub_grouping_entity.dart' as cashSubPrimary;
import '../../domain/entities/performance/performance_secondary_grouping_entity.dart' as secondary;
import '../../domain/entities/performance/performance_secondary_sub_grouping_enity.dart' as subSecondary;
import '../../data/models/performance/performance_secondary_sub_grouping_model.dart' as subSecondaryM;
import '../../data/models/performance/performance_primary_sub_grouping_model.dart' as subPrimaryM;
import '../../domain/entities/return_percentage/return_percentage_entity.dart';
import '../../domain/entities/net_worth/net_worth_grouping_entity.dart' as netWorthGroup;
import '../../domain/entities/net_worth/net_worth_sub_grouping_enity.dart' as netWorthSubGroup;
import 'package:asset_vantage/src/data/models/net_worth/net_worth_grouping_model.dart' as mNetWorthGroup;
import 'package:asset_vantage/src/data/models/net_worth/net_worth_sub_grouping_model.dart' as mNetWorthSubGroup;

class FavoriteHelper{
  FavoriteHelper._();

  static List<subPrimaryM.SubGroupingItem?>? getPrimarySubGrouping(List<dynamic>? primarySubGrouping) {

    if(primarySubGrouping != null) {
      return (primarySubGrouping.isNotEmpty)
          ? (primarySubGrouping as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return subPrimaryM.SubGroupingItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static List<mNetWorthSubGroup.SubGroupingItem?>? getPrimarySubGroupingForNetWorth(List<dynamic>? primarySubGrouping) {

    if(primarySubGrouping != null) {
      return (primarySubGrouping.isNotEmpty)
          ? (primarySubGrouping as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return mNetWorthSubGroup.SubGroupingItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static List<cashSubPrimaryM.SubGroupingItem?>? getCashBalancePrimarySubGrouping(List<dynamic>? primarySubGrouping) {

    if(primarySubGrouping != null) {
      return (primarySubGrouping.isNotEmpty)
          ? (primarySubGrouping as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return cashSubPrimaryM.SubGroupingItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static bool _isPrimarySubGroupingMatch({required List<subPrimary.SubGroupingItemData?>? primarySubGrouping, List<subPrimaryM.SubGroupingItem?>? mPrimarySubGrouping}) {

    final primarySubGroupingList = primarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mPrimarySubGroupingList = mPrimarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (primarySubGroupingList?.containsAll(mPrimarySubGroupingList?.toList() ?? []) ?? false) &&
        (mPrimarySubGroupingList?.containsAll(primarySubGroupingList?.toList() ?? []) ?? false);
  }

  static bool _isCashBalancePrimarySubGroupingMatch({required List<cashSubPrimary.SubGroupingItemData?>? primarySubGrouping, List<cashSubPrimaryM.SubGroupingItem?>? mPrimarySubGrouping}) {

    final primarySubGroupingList = primarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mPrimarySubGroupingList = mPrimarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (primarySubGroupingList?.containsAll(mPrimarySubGroupingList?.toList() ?? []) ?? false) &&
        (mPrimarySubGroupingList?.containsAll(primarySubGroupingList?.toList() ?? []) ?? false);
  }

  static bool _isSecondarySubGroupingMatch({required List<subSecondary.SubGroupingItemData?>? secondarySubGrouping, List<subSecondaryM.SubGroupingItem?>? mSecondarySubGrouping}) {

    final secondarySubGroupingList = secondarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mSecondarySubGroupingList = mSecondarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (secondarySubGroupingList?.containsAll(mSecondarySubGroupingList?.toList() ?? []) ?? false) &&
        (mSecondarySubGroupingList?.containsAll(secondarySubGroupingList?.toList() ?? []) ?? false);
  }

  static bool _isReturnPercentMatch({required List<ReturnPercentItemData?>? returnPercent, List<ReturnPercentItem?>? mReturnPercent}) {

    final returnPercentList = returnPercent?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mReturnPercentList = mReturnPercent?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (returnPercentList?.containsAll(mReturnPercentList?.toList() ?? []) ?? false) &&
        (mReturnPercentList?.containsAll(returnPercentList?.toList() ?? []) ?? false);
  }

  static bool _isReturnPercentForNetWorthMatch({required List<returtPerNW.ReturnPercentItemData?>? returnPercent, List<mReturtPerNW.ReturnPercentItem?>? mReturnPercent}) {

    final returnPercentList = returnPercent?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mReturnPercentList = mReturnPercent?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (returnPercentList?.containsAll(mReturnPercentList?.toList() ?? []) ?? false) &&
        (mReturnPercentList?.containsAll(returnPercentList?.toList() ?? []) ?? false);
  }

  static List<subSecondaryM.SubGroupingItem?>? getSecondarySubGrouping(List<dynamic>? secondarySubGrouping) {

    if(secondarySubGrouping != null) {
      return (secondarySubGrouping.isNotEmpty)
          ? (secondarySubGrouping as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return subSecondaryM.SubGroupingItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static List<ReturnPercentItem?>? getReturnPercent(List<dynamic>? returnPercentItem) {

    if(returnPercentItem != null) {
      return (returnPercentItem.isNotEmpty)
          ? (returnPercentItem as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return ReturnPercentItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static List<mReturtPerNW.ReturnPercentItem?>? getReturnPercentForNerWorth(List<dynamic>? returnPercentItem) {

    if(returnPercentItem != null) {
      return (returnPercentItem.isNotEmpty)
          ? (returnPercentItem as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return mReturtPerNW.ReturnPercentItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static bool _isNetWorthPrimarySubGroupingMatch({required List<netWorthSubGroup.SubGroupingItemData?>? primarySubGrouping, List<mNetWorthSubGroup.SubGroupingItem?>? mPrimarySubGrouping}) {

    final primarySubGroupingList = primarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mPrimarySubGroupingList = mPrimarySubGrouping?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (primarySubGroupingList?.containsAll(mPrimarySubGroupingList?.toList() ?? []) ?? false) &&
        (mPrimarySubGroupingList?.containsAll(primarySubGroupingList?.toList() ?? []) ?? false);
  }

  static bool isPerformanceCombinationExist({
    required List<Favorite?>? favorites,
    required EntityData? entity,
    required primary.GroupingEntity? primaryGrouping,
    required List<subPrimary.SubGroupingItemData?>? primarySubGrouping,
    required secondary.GroupingEntity? secondaryGrouping,
    required List<subSecondary.SubGroupingItemData?>? secondarySubGrouping,
    required List<ReturnPercentItemData?>? returnPercent,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {
    bool isExist = false;

    for(Favorite? favorite in favorites ?? []) {
      if(favorite?.reportId!="${FavoriteConstants.performanceId}") continue;
      isExist = favorite?.filter != null ? iteratePerformanceCombination(
        filters: favorite?.filter,
        entity: entity,
        primaryGrouping: primaryGrouping,
        primarySubGrouping: primarySubGrouping,
        secondaryGrouping: secondaryGrouping,
        secondarySubGrouping: secondarySubGrouping,
        returnPercent: returnPercent,
        currency: currency,
        denomination: denomination,
        asOnDate: asOnDate,
      ) : false;

      if(isExist) {
        return isExist;
      }
    }

    return isExist;
  }

  static bool iteratePerformanceCombination({
    required Map<dynamic, dynamic>? filters,
    required EntityData? entity,
    required primary.GroupingEntity? primaryGrouping,
    required List<subPrimary.SubGroupingItemData?>? primarySubGrouping,
    required secondary.GroupingEntity? secondaryGrouping,
    required List<subSecondary.SubGroupingItemData?>? secondarySubGrouping,
    required List<ReturnPercentItemData?>? returnPercent,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {

    Entity? mEntity;
    PrimaryGrouping? mPrimaryGrouping;
    List<subPrimaryM.SubGroupingItem?>? mPrimarySubGrouping;
    SecondaryGrouping? mSecondaryGrouping;
    List<subSecondaryM.SubGroupingItem?>? mSecondarySubGrouping;
    List<ReturnPercentItem?>? mReturnPercent;
    CurrencyData? mCurrency;
    DenData? mDenomination;
    String mAsOnDate;

    mEntity = Entity.fromJson(filters?[FavoriteConstants.entityFilter]);
    mPrimaryGrouping = PrimaryGrouping.fromJson(filters?[FavoriteConstants.primaryGrouping]);
    mPrimarySubGrouping = getPrimarySubGrouping(filters?[FavoriteConstants.primarySubGrouping]);
    mSecondaryGrouping = SecondaryGrouping.fromJson(filters?[FavoriteConstants.secondaryGrouping]);
    mSecondarySubGrouping = getSecondarySubGrouping(filters?[FavoriteConstants.secondarySubGrouping]);
    mReturnPercent = getReturnPercent(filters?[FavoriteConstants.returnPercent]);
    mCurrency = CurrencyData.fromJson(filters?[FavoriteConstants.currency]);
    mDenomination = DenData.fromJson(filters?[FavoriteConstants.denomination]);
    mAsOnDate = filters?[FavoriteConstants.asOnDate];

    bool isEntityMatch = false;
    bool isPrimaryGroupingMatch = false;
    bool isPrimarySubGroupingMatch = false;
    bool isSecondaryGroupingMatch = false;
    bool isSecondarySubGroupingMatch = false;
    bool isReturnPercentMatch = false;
    bool isCurrencyMatch = false;
    bool isDenominationMatch = false;
    bool isAsOnDateMatch = false;


    if(entity?.id == mEntity.id && entity?.type == mEntity.type) {
      isEntityMatch = true;
    }

    if(primaryGrouping?.id?.contains(mPrimaryGrouping.id ?? '') ?? false) {
      isPrimaryGroupingMatch = true;
    }

    if(_isPrimarySubGroupingMatch(primarySubGrouping: primarySubGrouping, mPrimarySubGrouping: mPrimarySubGrouping)) {
      isPrimarySubGroupingMatch = true;
    }

    if(secondaryGrouping?.id?.contains(mSecondaryGrouping.id ?? '') ?? false) {
      isSecondaryGroupingMatch = true;
    }

    if(_isSecondarySubGroupingMatch(secondarySubGrouping: secondarySubGrouping, mSecondarySubGrouping: mSecondarySubGrouping)) {
      isSecondarySubGroupingMatch = true;
    }

    if(_isReturnPercentMatch(returnPercent: returnPercent, mReturnPercent: mReturnPercent)) {
      isReturnPercentMatch = true;
    }

    if(currency?.id?.contains(mCurrency.id ?? '') ?? false) {
      isCurrencyMatch = true;
    }

    if(denomination?.id == mDenomination.id) {
      isDenominationMatch = true;
    }

    if(asOnDate?.contains(mAsOnDate) ?? false) {
      isAsOnDateMatch = true;
    }


    if(isEntityMatch && isPrimaryGroupingMatch && isPrimarySubGroupingMatch && isSecondaryGroupingMatch
        && isSecondarySubGroupingMatch && isReturnPercentMatch && isCurrencyMatch && isDenominationMatch && isAsOnDateMatch) {
      return true;
    }else {
      return false;
    }
  }

  static List<IncomeAccount?>? getIncomeAccounts(List<dynamic>? accounts) {

    if(accounts != null) {
      return (accounts.isNotEmpty)
          ? (accounts as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return IncomeAccount.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static List<ExpenseAccount?>? getExpenseAccounts(List<dynamic>? accounts) {

    if(accounts != null) {
      return (accounts.isNotEmpty)
          ? (accounts as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return ExpenseAccount.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }



  static List<cashSubPrimaryM.SubGroupingItem?>? getCashBalanceAccounts(List<dynamic>? accounts) {

    if(accounts != null) {
      return (accounts.isNotEmpty)
          ? (accounts as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return cashSubPrimaryM.SubGroupingItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    } else {
      return null;
    }
  }

  static bool isIncomeCombinationExist({
    required List<Favorite?>? favorites,
    required EntityData? entity,
    required List<Account?>? accounts,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {
    bool isExist = false;

    for(Favorite? favorite in favorites ?? []) {
      if(favorite?.reportId!="${FavoriteConstants.incomeId}") continue;
      isExist = favorite?.filter != null ? iterateIncomeCombination(
        filters: favorite?.filter,
        entity: entity,
        numberOfPeriod: numberOfPeriod,
        accounts: accounts,
        period: period,
        currency: currency,
        denomination: denomination,
        asOnDate: asOnDate,
      ) : false;
      if(isExist) {
        return isExist;
      }
    }

    return isExist;
  }

  static bool isExpenseCombinationExist({
    required List<Favorite?>? favorites,
    required EntityData? entity,
    required List<AccountEntity?>? accounts,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {
    bool isExist = false;

    for(Favorite? favorite in favorites ?? []) {
      if(favorite?.reportId!="${FavoriteConstants.expenseId}") continue;
      isExist = favorite?.filter != null ? iterateExpenseCombination(
        filters: favorite?.filter,
        entity: entity,
        period: period,
        numberOfPeriod: numberOfPeriod,
        accounts: accounts,
        currency: currency,
        denomination: denomination,
        asOnDate: asOnDate,
      ) : false;
      if(isExist) {
        return isExist;
      }
    }

    return isExist;
  }

  static bool isCashBalanceCombinationExist({
    required List<Favorite?>? favorites,
    required EntityData? entity,
    required List<cashSubPrimary.SubGroupingItemData?>? accounts,
    required cashPrimary.GroupingEntity? primaryGrouping,
    required List<cashSubPrimary.SubGroupingItemData?>? primarySubGrouping,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {
    bool isExist = false;

    for(Favorite? favorite in favorites ?? []) {
      if(favorite?.reportId!="${FavoriteConstants.cashBalanceId}") continue;
      print("favorite?.filter: ${favorite?.filter}");
      isExist = favorite?.filter != null ? iterateCashBalanceCombination(
        filters: favorite?.filter,
        entity: entity,
        primaryGrouping: primaryGrouping,
        primarySubGrouping: primarySubGrouping,
        period: period,
        numberOfPeriod: numberOfPeriod,
        accounts: accounts,
        currency: currency,
        denomination: denomination,
        asOnDate: asOnDate,
      ) : false;
      if(isExist) {
        return isExist;
      }
    }

    return isExist;
  }

  static bool iterateCashBalanceCombination({
    required Map<dynamic, dynamic>? filters,
    required EntityData? entity,
    required List<cashSubPrimary.SubGroupingItemData?>? accounts,
    required cashPrimary.GroupingEntity? primaryGrouping,
    required List<cashSubPrimary.SubGroupingItemData?>? primarySubGrouping,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {

    Entity? mEntity;
    List<cashSubPrimaryM.SubGroupingItem?>? mAccounts;
    cashPrimaryM.PrimaryGrouping? mPrimaryGrouping;
    List<cashSubPrimaryM.SubGroupingItem?>? mPrimarySubGrouping;
    PeriodItemData? mPeriod;
    NumberOfPeriodItemData? mNumberOfPeriod;
    CurrencyData? mCurrency;
    DenData? mDenomination;
    String mAsOnDate;

    mEntity = Entity.fromJson(filters?[FavoriteConstants.entityFilter]);
    mAccounts = filters?[FavoriteConstants.accounts] != null ? getCashBalanceAccounts(filters?[FavoriteConstants.accounts]) : null;
    mPrimaryGrouping = filters?[FavoriteConstants.primaryGrouping] != null ? cashPrimaryM.PrimaryGrouping.fromJson(filters?[FavoriteConstants.primaryGrouping]) : null;
    mPrimarySubGrouping = filters?[FavoriteConstants.primarySubGrouping] != null ? getCashBalancePrimarySubGrouping(filters?[FavoriteConstants.primarySubGrouping]) : null;
    mPeriod = PeriodItem.fromJson(filters?[FavoriteConstants.period]);
    mNumberOfPeriod = NumberOfPeriodItem.fromJson(filters?[FavoriteConstants.numberOfPeriod]);
    mCurrency = CurrencyData.fromJson(filters?[FavoriteConstants.currency]);
    mDenomination = DenData.fromJson(filters?[FavoriteConstants.denomination]);
    mAsOnDate = filters?[FavoriteConstants.asOnDate];

    bool isEntityMatch = false;
    bool isAccountMatch = false;
    bool isPrimaryGroupingMatch = false;
    bool isPrimarySubGroupingMatch = false;
    bool isPeriodMatch = false;
    bool isNumberOfPeriodMatch = false;
    bool isCurrencyMatch = false;
    bool isDenominationMatch = false;
    bool isAsOnDateMatch = false;

    if(entity?.id == mEntity.id && entity?.type == mEntity.type) {
      isEntityMatch = true;
    }
    if(_isCashBalanceAccountMatch(accounts: accounts, mAccounts: mAccounts)) {
      isAccountMatch = true;
    }

    if(primaryGrouping?.id?.contains(mPrimaryGrouping?.id ?? '') ?? false) {
      isPrimaryGroupingMatch = true;
    }

    if(_isCashBalancePrimarySubGroupingMatch(primarySubGrouping: primarySubGrouping, mPrimarySubGrouping: mPrimarySubGrouping)) {
      isPrimarySubGroupingMatch = true;
    }

    if(period?.id?.contains(mPeriod.id ?? '') ?? false) {
      isPeriodMatch = true;
    }

    if(numberOfPeriod?.id?.contains(mNumberOfPeriod.id ?? '') ?? false) {
      isNumberOfPeriodMatch = true;
    }

    if(currency?.id?.contains(mCurrency.id ?? '') ?? false) {
      isCurrencyMatch = true;
    }

    if(denomination?.id == mDenomination.id) {
      isDenominationMatch = true;
    }

    if(asOnDate?.contains(mAsOnDate) ?? false) {
      isAsOnDateMatch = true;
    }

    if(isEntityMatch && isAccountMatch && isPrimaryGroupingMatch && isPrimarySubGroupingMatch
        && isPeriodMatch && isNumberOfPeriodMatch && isCurrencyMatch && isDenominationMatch && isAsOnDateMatch) {
      return true;
    }else {
      return false;
    }
  }

  static bool isNetWorthCombinationExist({
    required String msg,
    required List<Favorite?>? favorites,
    required EntityData? entity,
    required netWorthGroup.GroupingEntity? primaryGrouping,
    required List<netWorthSubGroup.SubGroupingItemData?>? primarySubGrouping,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required List<returtPerNW.ReturnPercentItemData?>? returnPercentage,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {
    bool isExist = false;

    for(Favorite? favorite in favorites ?? []) {
      if(favorite?.reportId!="${FavoriteConstants.netWorthId}") continue;
      isExist = favorite?.filter != null ? iterateNetWorthCombination(
        msg: msg,
        filters: favorite?.filter,
        entity: entity,
        primaryGrouping: primaryGrouping,
        primarySubGrouping: primarySubGrouping,
        period: period,
        numberOfPeriod: numberOfPeriod,
        currency: currency,
        returnPercentage: returnPercentage,
        denomination: denomination,
        asOnDate: asOnDate,
      ) : false;
      if(isExist) {
        return isExist;
      }
    }

    return isExist;
  }

  static bool iterateNetWorthCombination({
    required String msg,
    required Map<dynamic, dynamic>? filters,
    required EntityData? entity,
    required netWorthGroup.GroupingEntity? primaryGrouping,
    required List<netWorthSubGroup.SubGroupingItemData?>? primarySubGrouping,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required List<returtPerNW.ReturnPercentItemData?>? returnPercentage,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {

    Entity? mEntity;
    mNetWorthGroup.PrimaryGrouping? mPrimaryGrouping;
    List<mNetWorthSubGroup.SubGroupingItem?>? mPrimarySubGrouping;
    PeriodItemData? mPeriod;
    NumberOfPeriodItemData? mNumberOfPeriod;
    CurrencyData? mCurrency;
    List<mReturtPerNW.ReturnPercentItem?>? mReturnPercent;
    DenData? mDenomination;
    String mAsOnDate;

    mEntity = Entity.fromJson(filters?[FavoriteConstants.entityFilter]);
    mPrimaryGrouping = filters?[FavoriteConstants.primaryGrouping] != null ? mNetWorthGroup.PrimaryGrouping.fromJson(filters?[FavoriteConstants.primaryGrouping]) : null;
    mPrimarySubGrouping = filters?[FavoriteConstants.primarySubGrouping] != null ? getNetWorthPrimarySubGrouping(filters?[FavoriteConstants.primarySubGrouping]) : null;
    mPeriod = PeriodItem.fromJson(filters?[FavoriteConstants.period]);
    mNumberOfPeriod = NumberOfPeriodItem.fromJson(filters?[FavoriteConstants.numberOfPeriod]);
    mCurrency = CurrencyData.fromJson(filters?[FavoriteConstants.currency]);
    mReturnPercent = getReturnPercentForNerWorth(filters?[FavoriteConstants.returnPercent]);
    mDenomination = DenData.fromJson(filters?[FavoriteConstants.denomination]);
    mAsOnDate = filters?[FavoriteConstants.asOnDate];

    print(">>>>> $msg filter: ${filters}");
    print(">>>>> entity: ${entity} ${mEntity}");
    print(">>>>> primaryGrouping: ${primaryGrouping} ${mPrimaryGrouping}");
    print(">>>>> primarySubGrouping: ${primarySubGrouping} ${mPrimarySubGrouping}");
    print(">>>>> period: ${period} ${mPeriod}");
    print(">>>>> numberOfPeriod: ${numberOfPeriod} ${mNumberOfPeriod}");
    print(">>>>> returnPercentage: ${returnPercentage} ${mReturnPercent}");
    print(">>>>> currency: ${currency} ${mCurrency}");
    print(">>>>> denomination: ${denomination} ${mDenomination}");
    print(">>>>> mAsOnDate: ${asOnDate} ${mAsOnDate}");


    bool isEntityMatch = false;
    bool isPrimaryGroupingMatch = false;
    bool isPrimarySubGroupingMatch = false;
    bool isPeriodMatch = false;
    bool isNumberOfPeriodMatch = false;
    bool isCurrencyMatch = false;
    bool isReturnPercent = false;
    bool isDenominationMatch = false;
    bool isAsOnDateMatch = false;

    if(entity?.id == mEntity.id && entity?.type == mEntity.type) {
      isEntityMatch = true;
    }

    if(_isReturnPercentForNetWorthMatch(returnPercent: returnPercentage, mReturnPercent: mReturnPercent)) {
      isReturnPercent = true;
    }

    if(primaryGrouping?.id?.contains(mPrimaryGrouping?.id ?? '') ?? false) {
      isPrimaryGroupingMatch = true;
    }

    if(_isNetWorthPrimarySubGroupingMatch(primarySubGrouping: primarySubGrouping, mPrimarySubGrouping: mPrimarySubGrouping)) {
      isPrimarySubGroupingMatch = true;
    }

    if(period?.id?.contains(mPeriod.id ?? '') ?? false) {
      isPeriodMatch = true;
    }

    if(numberOfPeriod?.id?.contains(mNumberOfPeriod.id ?? '') ?? false) {
      isNumberOfPeriodMatch = true;
    }

    if(currency?.id?.contains(mCurrency.id ?? '') ?? false) {
      isCurrencyMatch = true;
    }

    if(denomination?.id == mDenomination.id) {
      isDenominationMatch = true;
    }

    if(asOnDate?.contains(mAsOnDate) ?? false) {
      isAsOnDateMatch = true;
    }

    if(isEntityMatch && isReturnPercent && isPrimaryGroupingMatch && isPrimarySubGroupingMatch
        && isPeriodMatch && isNumberOfPeriodMatch && isCurrencyMatch && isDenominationMatch && isAsOnDateMatch) {
      return true;
    }else {
      return false;
    }
  }

  static List<mNetWorthSubGroup.SubGroupingItem?>? getNetWorthPrimarySubGrouping(List<dynamic>? primarySubGrouping) {

    if(primarySubGrouping != null) {
      return (primarySubGrouping.isNotEmpty)
          ? (primarySubGrouping as List).map((x) {
        if (x is Map<dynamic, dynamic>) {
          return mNetWorthSubGroup.SubGroupingItem.fromJson(x);
        }
        return null;
      }).toList()
          : [];
    }else {
      return null;
    }
  }

  static bool iterateIncomeCombination({
    required Map<dynamic, dynamic>? filters,
    required EntityData? entity,
    required List<Account?>? accounts,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {

    Entity? mEntity;
    List<Account?>? mAccounts;
    PeriodItemData? mPeriod;
    NumberOfPeriodItemData? mNumberOfPeriod;
    CurrencyData? mCurrency;
    DenData? mDenomination;
    String mAsOnDate;

    mEntity = Entity.fromJson(filters?[FavoriteConstants.entityFilter]);
    mAccounts = getIncomeAccounts(filters?[FavoriteConstants.accounts]);
    mPeriod = PeriodItem.fromJson(filters?[FavoriteConstants.period]);
    mNumberOfPeriod = NumberOfPeriodItem.fromJson(filters?[FavoriteConstants.numberOfPeriod]);
    mCurrency = CurrencyData.fromJson(filters?[FavoriteConstants.currency]);
    mDenomination = DenData.fromJson(filters?[FavoriteConstants.denomination]);
    mAsOnDate = filters?[FavoriteConstants.asOnDate];

    bool isEntityMatch = false;
    bool isAccountMatch = false;
    bool isPeriodMatch = false;
    bool isNumberOfPeriodMatch = false;
    bool isCurrencyMatch = false;
    bool isDenominationMatch = false;
    bool isAsOnDateMatch = false;


    if(entity?.id == mEntity.id && entity?.type == mEntity.type) {
      isEntityMatch = true;
    }

    if(_isIncomeAccountMatch(accounts: accounts, mAccounts: mAccounts)) {
      isAccountMatch = true;
    }

    if(period?.id?.contains(mPeriod.id ?? '') ?? false) {
      isPeriodMatch = true;
    }

    if(numberOfPeriod?.id?.contains(mNumberOfPeriod.id ?? '') ?? false) {
      isNumberOfPeriodMatch = true;
    }

    if(currency?.id?.contains(mCurrency.id ?? '') ?? false) {
      isCurrencyMatch = true;
    }

    if(denomination?.id == mDenomination.id) {
      isDenominationMatch = true;
    }

    if(asOnDate?.contains(mAsOnDate) ?? false) {
      isAsOnDateMatch = true;
    }


    if(isEntityMatch && isAccountMatch && isPeriodMatch && isNumberOfPeriodMatch && isCurrencyMatch && isDenominationMatch && isAsOnDateMatch) {
      return true;
    }else {
      return false;
    }
  }

  static bool iterateExpenseCombination({
    required Map<dynamic, dynamic>? filters,
    required EntityData? entity,
    required List<AccountEntity?>? accounts,
    required PeriodItemData? period,
    required NumberOfPeriodItemData? numberOfPeriod,
    required Currency? currency,
    required DenominationData? denomination,
    required String? asOnDate,
  }) {

    Entity? mEntity;
    List<AccountEntity?>? mAccounts;
    PeriodItemData? mPeriod;
    NumberOfPeriodItemData? mNumberOfPeriod;
    CurrencyData? mCurrency;
    DenData? mDenomination;
    String mAsOnDate;

    mEntity = Entity.fromJson(filters?[FavoriteConstants.entityFilter]);
    mAccounts = getExpenseAccounts(filters?[FavoriteConstants.accounts]);
    mPeriod = PeriodItem.fromJson(filters?[FavoriteConstants.period]);
    mNumberOfPeriod = NumberOfPeriodItem.fromJson(filters?[FavoriteConstants.numberOfPeriod]);
    mCurrency = CurrencyData.fromJson(filters?[FavoriteConstants.currency]);
    mDenomination = DenData.fromJson(filters?[FavoriteConstants.denomination]);
    mAsOnDate = filters?[FavoriteConstants.asOnDate];

    bool isEntityMatch = false;
    bool isAccountMatch = false;
    bool isPeriodMatch = false;
    bool isNumberOfPeriodMatch = false;
    bool isCurrencyMatch = false;
    bool isDenominationMatch = false;
    bool isAsOnDateMatch = false;

    if(entity?.id == mEntity.id && entity?.type == mEntity.type) {
      isEntityMatch = true;
    }

    if(_isExpenseAccountMatch(accounts: accounts, mAccounts: mAccounts)) {
      isAccountMatch = true;
    }

    if(period?.id?.contains(mPeriod.id ?? '') ?? false) {
      isPeriodMatch = true;
    }

    if(numberOfPeriod?.id?.contains(mNumberOfPeriod.id ?? '') ?? false) {
      isNumberOfPeriodMatch = true;
    }
    if(currency?.id?.contains(mCurrency.id ?? '') ?? false) {
      isCurrencyMatch = true;
    }
    if(denomination?.id == mDenomination.id) {
      isDenominationMatch = true;
    }
    if(asOnDate?.contains(mAsOnDate) ?? false) {
      isAsOnDateMatch = true;
    }

    if(isEntityMatch && isAccountMatch && isPeriodMatch && isNumberOfPeriodMatch && isCurrencyMatch && isDenominationMatch && isAsOnDateMatch) {
      return true;
    }else {
      return false;
    }
  }



  static bool _isIncomeAccountMatch({required List<Account?>? accounts, List<Account?>? mAccounts}) {

    final accountList = accounts?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mAccountsList = mAccounts?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (accountList?.containsAll(mAccountsList?.toList() ?? []) ?? false) &&
        (mAccountsList?.containsAll(accountList?.toList() ?? []) ?? false);
  }

  static bool _isExpenseAccountMatch({required List<AccountEntity?>? accounts, List<AccountEntity?>? mAccounts}) {

    final accountList = accounts?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mAccountsList = mAccounts?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (accountList?.containsAll(mAccountsList?.toList() ?? []) ?? false) &&
        (mAccountsList?.containsAll(accountList?.toList() ?? []) ?? false);
  }

  static bool _isCashBalanceAccountMatch({required List<cashSubPrimary.SubGroupingItemData?>? accounts, List<cashSubPrimaryM.SubGroupingItem?>? mAccounts}) {

    final accountList = accounts?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();
    final mAccountsList = mAccounts?.map((g) {
      if(g?.id != null) {
        return g?.id;
      }
    }).toSet();

    return (accountList?.containsAll(mAccountsList?.toList() ?? []) ?? false) &&
        (mAccountsList?.containsAll(accountList?.toList() ?? []) ?? false);
  }
}