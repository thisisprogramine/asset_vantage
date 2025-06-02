
import 'package:asset_vantage/src/data/models/preferences/app_theme.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  const UserEntity({
    this.id,
    this.username,
    this.displayname,
    this.email,
    this.address,
    this.phone,
    this.appTheme,
    this.defaultEntity,
    this.dateFormat,
    this.cobranding,
    this.cobrandingLight,
    this.amountplaces,
    this.timeFormat,
    this.numberFormat,
    this.decimalQuantity,
    this.decimalValue,
    this.fixedIncomeUnits,
    this.dateLimit,
    this.avInsightsUrl,
    this.avEdge,
    this.avInsights,
    this.role,
    this.unitPlaces,
    this.tokenExp,
  });

  final int? id;
  final String? username;
  final String? displayname;
  final String? email;
  final String? address;
  final AppThemeModel? appTheme;
  final String? phone;
  final String? defaultEntity;
  final String? dateFormat;
  final CoBrandingEntity? cobranding;
  final CoBrandingEntity? cobrandingLight;
  final int? amountplaces;
  final String? timeFormat;
  final String? numberFormat;
  final int? decimalQuantity;
  final int? decimalValue;
  final String? fixedIncomeUnits;
  final String? dateLimit;
  final String? avInsightsUrl;
  final bool? avEdge;
  final bool? avInsights;
  final String? role;
  final int? unitPlaces;
  final int? tokenExp;

  UserEntity copyWith({
    final int? id,
    final String? username,
    final String? displayname,
    final String? email,
    final String? address,
    final AppThemeModel? appTheme,
    final String? phone,
    final String? defaultEntity,
    final String? dateFormat,
    final CoBrandingEntity? cobranding,
    final CoBrandingEntity? cobrandingLight,
    final int? amountplaces,
    final String? timeFormat,
    final String? numberFormat,
    final int? decimalQuantity,
    final int? decimalValue,
    final String? fixedIncomeUnits,
    final String? dateLimit,
    final String? avInsightsUrl,
    final bool? avEdge,
    final bool? avInsights,
    final String? role,
    final int? unitPlaces,
    final int? tokenExp,
  }) => UserEntity(
    id: id ?? this.id,
    username: username ?? this.username,
    displayname: displayname ?? this.displayname,
    email: email ?? this.email,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    appTheme: appTheme ?? this.appTheme,
    defaultEntity: defaultEntity ?? this.defaultEntity,
    dateFormat: dateFormat ?? this.dateFormat,
    cobranding: cobranding ?? this.cobranding,
    cobrandingLight: cobrandingLight ?? this.cobrandingLight,
    amountplaces: amountplaces ?? this.amountplaces,
    timeFormat: timeFormat ?? this.timeFormat,
    numberFormat: numberFormat ?? this.numberFormat,
    decimalQuantity: decimalQuantity ?? this.decimalQuantity,
    decimalValue: decimalValue ?? this.decimalValue,
    fixedIncomeUnits: fixedIncomeUnits ?? this.fixedIncomeUnits,
    dateLimit: dateLimit ?? this.dateLimit,
    avInsightsUrl: avInsightsUrl ?? this.avInsightsUrl,
    avEdge: avEdge ?? this.avEdge,
    avInsights: avInsights ?? this.avInsights,
    role: role ?? this.role,
    unitPlaces: unitPlaces ?? this.unitPlaces,
    tokenExp: tokenExp ?? this.tokenExp,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "displayname": displayname,
    "email": email,
    "address": address,
    "phone": phone,
    "appTheme": appTheme,
    "defaultEntity": defaultEntity,
    "dateformat": dateFormat,
    "cobranding": cobranding?.toJson(),
    "cobrandingLight": cobrandingLight?.toJson(),
    "amountplaces": amountplaces,
    "timeformat": timeFormat,
    "numberformat": numberFormat,
    "DecimalQuantity": decimalQuantity,
    "DecimalValue": decimalValue,
    "FixedIncomeUnits": fixedIncomeUnits,
    "dateLimit": dateLimit,
    "avInsightsUrl": avInsightsUrl,
    "unitPlaces": unitPlaces,
    "role": role,
    "avInsights": avInsights,
    "avEdge": avEdge,
    "exp": tokenExp,
  };

  @override
  List<Object?> get props => [id, username, email, address, phone];
}

class CoBrandingEntity {
  final String? brandLogo;
  final String? brandName;
  final String? textColor;
  final String? backgroundColor;
  final String? primaryColor;
  final String? secondaryColor;
  final String? accentColor;
  final String? iconColor;
  final String? cardColor;
  final String? id;

  CoBrandingEntity({
    this.brandLogo,
    this.brandName,
    this.textColor,
    this.backgroundColor,
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.iconColor,
    this.cardColor,
    this.id,
  });

  Map<String, dynamic> toJson() => {
    "brandLogo": brandLogo,
    "brandName": brandName,
    "textColor": textColor,
    "backgroundColor": backgroundColor,
    "primaryColor": primaryColor,
    "secondaryColor": secondaryColor,
    "accentColor": accentColor,
    "iconColor": iconColor,
    "cardColor": cardColor,
    "id": id,
  };
}
