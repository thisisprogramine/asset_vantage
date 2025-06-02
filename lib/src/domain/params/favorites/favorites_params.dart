import 'package:asset_vantage/src/config/constants/favorite_constants.dart';
import 'package:flutter/material.dart';

class FavoritesParams{
  final BuildContext context;
  final String action;
  final bool isBlankWidget;
  final int? id;
  final String? userId;
  final String? systemName;
  final String? reportName;
  final String? reportId;
  final Map<dynamic, dynamic>? entity;
  final Map<dynamic, dynamic>? primaryGrouping;
  final List<Map<dynamic, dynamic>>? primarySubGrouping;
  final Map<dynamic, dynamic>? secondaryGrouping;
  final List<Map<dynamic, dynamic>>? secondarySubGrouping;
  final Map<dynamic, dynamic>? period;
  final Map<dynamic, dynamic>? numberOfPeriod;
  final Map<dynamic,dynamic>? partnershipMethod;
  final Map<dynamic,dynamic>? holdingMethod;
  final List<Map<dynamic, dynamic>>? returnPercent;
  final Map<dynamic, dynamic>? currency;
  final Map<dynamic, dynamic>? denomination;
  final List<Map<dynamic, dynamic>>? accounts;
  final String? asOnDate;
  final bool? isMarketValueSelecte;
  final String? drillDownLevel;
  final String? drillDownItemId;
  final bool? isPinned;
  final List<int>? favSequence;



  const FavoritesParams( {
    required this.context,
    required this.action,
    this.isBlankWidget = false,
    this.id,
    this.userId,
    this.systemName,
    this.reportName,
    this.reportId,
    this.entity,
    this.primaryGrouping,
    this.primarySubGrouping,
    this.secondaryGrouping,
    this.secondarySubGrouping,
    this.period,
    this.numberOfPeriod,
    this.returnPercent,
    this.currency,
    this.denomination,
    this.accounts,
    this.asOnDate,
    this.isMarketValueSelecte,
    this.drillDownLevel,
    this.drillDownItemId,
    this.isPinned,
    this.favSequence,
    this.partnershipMethod,
    this.holdingMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "data": {
        if(id != null)
          "id": id,
        if(userId != null)
          "user_id": userId,
        if(systemName != null)
          "system_name": systemName,
        if(reportName != null)
          "reportname": reportName,
        if(reportId != null)
          "reportid": reportId,
        if(entity != null || primaryGrouping != null || primarySubGrouping != null || secondaryGrouping != null || secondarySubGrouping != null
            || period != null || numberOfPeriod != null || returnPercent != null || currency != null || denomination != null || asOnDate != null)
          "filter": isBlankWidget ? {"message": "empty"}
              : {
            if(entity != null)
              FavoriteConstants.entityFilter: entity,
            if(primaryGrouping != null)
              FavoriteConstants.primaryGrouping: primaryGrouping,
            if(primarySubGrouping != null)
              FavoriteConstants.primarySubGrouping: primarySubGrouping,
            if(secondaryGrouping != null)
              FavoriteConstants.secondaryGrouping: secondaryGrouping,
            if(secondarySubGrouping != null)
              FavoriteConstants.secondarySubGrouping: secondarySubGrouping,
            if(partnershipMethod !=null)
              FavoriteConstants.partnershipMethod :partnershipMethod,
            if(holdingMethod !=null)
               FavoriteConstants.holdingMethod :holdingMethod,
            if(period != null)
              FavoriteConstants.period: period,
            if(numberOfPeriod != null)
              FavoriteConstants.numberOfPeriod: numberOfPeriod,
            if(returnPercent != null)
              FavoriteConstants.returnPercent: returnPercent,
            if(currency != null)
              FavoriteConstants.currency: currency,
            if(denomination != null)
              FavoriteConstants.denomination: denomination,
            if(asOnDate != null)
              FavoriteConstants.asOnDate: asOnDate,
            if(accounts!=null)
              FavoriteConstants.accounts: accounts,
            if(isMarketValueSelecte!=null)
              FavoriteConstants.isMarketValueSelected: isMarketValueSelecte,
          },
        if(drillDownLevel != null)
          "level": drillDownLevel,
        if(drillDownItemId != null)
          "itemid": drillDownItemId,
          "isPined": false,
        if(favSequence!=null)
          "sequence_data": {
            "sequence": favSequence
          }
        },
      };
    }
  }