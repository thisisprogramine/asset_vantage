

import '../../../domain/entities/authentication/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    this.id,
    this.username,
    this.displayname,
    this.email,
    this.address,
    this.phone,
    this.defaultEntity,
    this.dateFormat,
    this.cobranding,
    this.cobrandingLight,
    this.timeFormat,
    this.numberFormat,
    this.amountplaces,
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
  }) : super(
    id: id,
    username: username,
    displayname: displayname,
    email: email,
    address: address,
    phone: phone,
    defaultEntity: defaultEntity,
    dateFormat: dateFormat,
    cobranding: cobranding,
    cobrandingLight: cobrandingLight,
    timeFormat: timeFormat,
    numberFormat: numberFormat,
    amountplaces: amountplaces,
    decimalQuantity: decimalQuantity,
    decimalValue: decimalValue,
    fixedIncomeUnits: fixedIncomeUnits,
    dateLimit: dateLimit,
    avInsightsUrl: avInsightsUrl,
    avEdge: avEdge,
    avInsights: avInsights,
    role: role,
    unitPlaces: unitPlaces,
    tokenExp: tokenExp,
  );

  final int? id;
  final String? username;
  final String? displayname;
  final String? email;
  final String? address;
  final String? phone;
  final String? defaultEntity;
  final String? dateFormat;
  final CoBranding? cobranding;
  final CoBranding? cobrandingLight;
  final String? timeFormat;
  final String? numberFormat;
  final int? amountplaces;
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

  factory UserModel.fromJson(Map<dynamic, dynamic> json, {Map<String, dynamic>? tokenData}) {
    if(tokenData!=null){
      json["role"] = tokenData["custom:urole"];
      json["displayname"] = tokenData["nickname"];
      json["email"] = tokenData["email"];
      json["phone"] = (tokenData["phone_number"] ?? "").toString();
      json["defaultEntity"] = tokenData["custom:defaultEntityId"];
      json["amountplaces"] = int.tryParse(tokenData["custom:amountplaces"]);
      json["dateFormat"] = tokenData["custom:udisplaydateformat"];
      json["timeFormat"] = tokenData["custom:timeformat"];
      json["numberFormat"] = tokenData["custom:numberformat"];
      json["FixedIncomeUnits"] = tokenData["custom:fixedincomeunits"];
      json["avInsightsUrl"] = tokenData["custom:extraparam1"];
      json["unitPlaces"] = int.tryParse(tokenData["custom:unitplaces"]);
      json["exp"] = tokenData["exp"];
    }
    return UserModel(
      id: json["id"],
      username: json["username"],
      displayname: json["displayname"],
      email: json["email"],
      address: json["address"],
      phone: json["phone"],
      defaultEntity: json["defaultEntity"],
      amountplaces: json["amountplaces"],
      dateFormat: json["dateformat"],
      cobranding: json["cobranding"] != null ? CoBranding.fromJson(json["cobranding"]) : null,
      cobrandingLight: json["cobrandingLight"] != null ? CoBranding.fromJson(json["cobrandingLight"]) : null,
      timeFormat: json["timeformat"],
      numberFormat: json["numberformat"],
      decimalQuantity: json["DecimalQuantity"],
      decimalValue: json["DecimalValue"],
      fixedIncomeUnits: json["FixedIncomeUnits"],
      dateLimit: json["dateLimit"],
      avInsightsUrl: json['avInsightsUrl'],
      avEdge: json["avEdge"],
      avInsights: json["avInsights"],
      role: json["role"],
      unitPlaces: json["unitPlaces"],
      tokenExp: json["exp"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "displayname": displayname,
    "email": email,
    "address": address,
    "phone": phone,
    "defaultEntity": defaultEntity,
    "dateformat": dateFormat,
    "cobranding": cobranding?.toJson(),
    "cobrandingLight": cobrandingLight?.toJson(),
    "timeformat": timeFormat,
    "numberformat": numberFormat,
    "amountplaces": amountplaces,
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
}

class CoBranding extends CoBrandingEntity{
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

  CoBranding({
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
  }) : super(
      brandLogo: brandLogo,
    textColor: textColor,
    backgroundColor: backgroundColor,
    primaryColor: primaryColor,
    secondaryColor: secondaryColor,
    accentColor: accentColor,
    iconColor: iconColor,
    cardColor: cardColor,
    id: id,
    brandName: brandName,
  );

  factory CoBranding.fromJson(Map<dynamic, dynamic> json) => CoBranding(
    brandLogo: json["brandLogo"] != null ? json["brandLogo"] : null,
    brandName: json["brandName"]!=null?json["brandName"]:null,
    textColor: json["textColor"] != null ? json["textColor"].replaceFirst('#', '0xFF') : null,
    backgroundColor: json["backgroundColor"] != null ? json["backgroundColor"].replaceFirst('#', '0xFF') : null,
    primaryColor: json["primaryColor"] != null ? json["primaryColor"].replaceFirst('#', '0xFF') : null,
    secondaryColor: json["secondaryColor"] != null ? json["secondaryColor"].replaceFirst('#', '0xFF') : null,
    accentColor: json["accentColor"] != null ? json["accentColor"].replaceFirst('#', '0xFF') : null,
    iconColor: json["iconColor"] != null ? json["iconColor"].replaceFirst('#', '0xFF') : null,
    cardColor: json["cardColor"] != null ? json["cardColor"].replaceFirst('#', '0xFF') : null,
    id: json["id"],
  );

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

