import '../../../domain/entities/authentication/user_entity.dart';
import '../authentication/credentials.dart';
import '../authentication/user_model.dart';

class UserPreference {
  const UserPreference({
    this.loginStatus,
    this.region,
    this.isFirstOpen,
    this.isOnBiometric,
    this.darkMode,
    this.user,
    this.regionUrl,
    this.username,
    this.credential,
    this.displayname,
    this.defaultTheme,
    this.password,
    this.userId,
    this.accessToken,
    this.idToken,
    this.refreshToken,
    this.fcmToken,
    this.systemName,
    this.lastUserUpdate,
    this.ipsTimeStamp,
    this.cashBalanceTimeStamp,
    this.netWorthTimeStamp,
    this.performanceTimeStamp,
    this.incomeTimeStamp,
    this.expenseTimeStamp,
    this.fullName,
    this.firstName,
    this.lastName,
    this.countryCode,
    this.countryFlag,
    this.phoneNumber,
    this.otp,
    this.email,
    this.avatar,
    this.language,
    this.appVersion,
  });

  final bool? loginStatus;
  final String? region;
  final bool? isFirstOpen;
  final bool? isOnBiometric;
  final bool? darkMode;
  final UserEntity? user;
  final String? username;
  final Map<dynamic, dynamic>? credential;
  final String? displayname;
  final String? regionUrl;
  final bool? defaultTheme;
  final String? password;
  final String? userId;
  final String? accessToken;
  final String? idToken;
  final String? refreshToken;
  final String? fcmToken;
  final String? systemName;
  final String? lastUserUpdate;
  final String? ipsTimeStamp;
  final String? cashBalanceTimeStamp;
  final String? netWorthTimeStamp;
  final String? performanceTimeStamp;
  final String? incomeTimeStamp;
  final String? expenseTimeStamp;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? countryCode;
  final String? countryFlag;
  final String? phoneNumber;
  final String? otp;
  final String? email;
  final String? avatar;
  final String? language;
  final String? appVersion;

  UserPreference copyWith({
    bool? loginStatus,
    String? region,
    bool? isFirstOpen,
    bool? isOnBiometric,
    bool? darkMode,
    UserEntity? user,
    String? regionUrl,
    String? userId,
    String? username,
    Map<dynamic, dynamic>? credential,
    String? displayname,
    bool? defaultTheme,
    String? password,
    String? accessToken,
    String? idToken,
    String? refreshToken,
    String? fcmToken,
    String? systemName,
    String? lastUserUpdate,
    String? ipsTimeStamp,
    String? cashBalanceTimeStamp,
    String? netWorthTimeStamp,
    String? performanceTimeStamp,
    String? incomeTimeStamp,
    String? expenseTimeStamp,
    String? fullName,
    String? firstName,
    String? lastName,
    String? countryCode,
    String? countryFlag,
    String? phoneNumber,
    String? otp,
    String? email,
    String? avatar,
    String? language,
    String? appVersion,
  }) =>
      UserPreference(
        loginStatus: loginStatus ?? this.loginStatus,
        region: region ?? this.region,
        isFirstOpen: isFirstOpen ?? this.isFirstOpen,
        isOnBiometric: isOnBiometric ?? this.isOnBiometric,
        darkMode: darkMode ?? this.darkMode,
        user: user?.copyWith(
          id: user.id ?? this.user?.id,
          username: user.username ?? this.user?.username,
          displayname: user.displayname ?? this.user?.displayname,
          email: user.email ?? this.user?.email,
          address: user.address ?? this.user?.address,
          phone: user.phone ?? this.user?.phone,
          appTheme: user.appTheme ?? this.user?.appTheme,
          defaultEntity: user.defaultEntity ?? this.user?.defaultEntity,
          dateFormat: user.dateFormat ?? this.user?.dateFormat,
          cobranding: user.cobranding ?? this.user?.cobranding,
          cobrandingLight: user.cobrandingLight ?? this.user?.cobrandingLight,
          timeFormat: user.timeFormat ?? this.user?.timeFormat,
          numberFormat: user.numberFormat ?? this.user?.numberFormat,
          decimalQuantity: user.decimalQuantity ?? this.user?.decimalQuantity,
          decimalValue: user.decimalValue ?? this.user?.decimalValue,
          fixedIncomeUnits: user.fixedIncomeUnits ?? this.user?.fixedIncomeUnits,
          dateLimit: user.dateLimit ?? this.user?.dateLimit,
        ) ?? this.user,
        regionUrl: regionUrl ?? this.regionUrl,
        username: username ?? this.username,
        credential: credential ?? this.credential,
        displayname: displayname ?? this.displayname,
        defaultTheme: defaultTheme ?? this.defaultTheme,
        password: password ?? this.password,
        userId: userId ?? this.userId,
        accessToken: accessToken ?? this.accessToken,
        idToken: idToken ?? this.idToken,
        refreshToken: refreshToken ?? this.refreshToken,
        fcmToken: fcmToken ?? this.fcmToken,
        systemName: systemName ?? this.systemName,
        lastUserUpdate: lastUserUpdate ?? this.lastUserUpdate,
        ipsTimeStamp: ipsTimeStamp ?? this.ipsTimeStamp,
        cashBalanceTimeStamp: cashBalanceTimeStamp ?? this.cashBalanceTimeStamp,
        netWorthTimeStamp: netWorthTimeStamp ?? this.netWorthTimeStamp,
        performanceTimeStamp: performanceTimeStamp ?? this.performanceTimeStamp,
        incomeTimeStamp: incomeTimeStamp ?? this.incomeTimeStamp,
        expenseTimeStamp: expenseTimeStamp ?? this.expenseTimeStamp,
        fullName: fullName ?? this.fullName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        countryCode: countryCode ?? this.countryCode,
        countryFlag: countryFlag ?? this.countryFlag,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        otp: otp ?? this.otp,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        language: language ?? this.language,
        appVersion: appVersion ?? this.appVersion,
      );

  factory UserPreference.fromJson(Map<dynamic, dynamic> json) {

    return UserPreference(
      loginStatus: json["loginStatus"] == null ? null : json["loginStatus"]!,
      region: json["region"] == null ? null : json["region"]!,
      isFirstOpen: json["isFirstOpen"] == null ? null : json["isFirstOpen"]!,
      isOnBiometric: json["isOnBiometric"] == null ? true : json["isOnBiometric"]!,
      darkMode: json["darkMode"] == null ? null : json["darkMode"]!,
      user: json["user"] == null ? null : UserModel.fromJson(json["user"]!),
      regionUrl: json["regionUrl"] == null ? null : json["regionUrl"]!,
      username: json["username"] == null ? null : json["username"]!,
      credential: json["credential"] == null ? null : json["credential"],
      displayname: json["displayname"] == null ? null : json["displayname"]!,
      defaultTheme: json["defaultTheme"] == null ? null : json["defaultTheme"]!,
      password: json["password"] == null ? null : json["password"]!,
      userId: json["user_id"] == null ? null : json["user_id"]!,
      accessToken: json["accessToken"] == null ? null : json["accessToken"]!,
      idToken: json["idToken"] == null ? null : json["idToken"]!,
      refreshToken: json["refreshToken"] == null ? null : json["refreshToken"]!,
      fcmToken: json["fcmToken"] == null ? null : json["fcmToken"]!,
      systemName: json["systemName"] == null ? null : json["systemName"]!,
      lastUserUpdate: json["lastUserUpdate"] == null ? null : json["lastUserUpdate"]!,
      ipsTimeStamp: json["ipsTimeStamp"] == null ? null : json["ipsTimeStamp"]!,
      cashBalanceTimeStamp: json["cashBalanceTimeStamp"] == null ? null : json["cashBalanceTimeStamp"]!,
      netWorthTimeStamp: json["netWorthTimeStamp"] == null ? null : json["netWorthTimeStamp"]!,
      performanceTimeStamp: json["performanceTimeStamp"] == null ? null : json["performanceTimeStamp"]!,
      incomeTimeStamp: json["incomeTimeStamp"] == null ? null : json["incomeTimeStamp"]!,
      expenseTimeStamp: json["expenseTimeStamp"] == null ? null : json["expenseTimeStamp"]!,
      fullName: json["fullName"] == null ? null : json["fullName"]!,
      firstName: json["firstName"] == null ? null : json["firstName"]!,
      lastName: json["lastName"] == null ? null : json["lastName"]!,
      countryCode: json["countryCode"] == null ? null : json["countryCode"]!,
      countryFlag: json["countryFlag"] == null ? null : json["countryFlag"]!,
      phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"]!,
      otp: json["otp"] == null ? null : json["otp"]!,
      email: json["email"] == null ? null : json["email"]!,
      avatar: json["avatar"] == null ? null : json["avatar"]!,
      language: json["language"] == null ? null : json["language"]!,
      appVersion: json["appVersion"] == null ? null : json["appVersion"]!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "loginStatus": loginStatus == null ? null : loginStatus!,
      "region": region == null ? null : region!,
      "isFirstOpen": isFirstOpen == null ? null : isFirstOpen!,
      "isOnBiometric": isOnBiometric == null ? true : isOnBiometric!,
      "darkMode": darkMode == null ? null : darkMode!,
      "user": user == null ? null : user!.toJson(),
      "regionUrl": regionUrl == null ? null : regionUrl!,
      "user_id": userId == null ? null : userId!,
      "username": username == null ? null : username!,
      "credential": credential == null ? null : credential!,
      "displayname": displayname == null ? null : displayname!,
      "defaultTheme": defaultTheme == null ? null : defaultTheme!,
      "password": password == null ? null : password!,
      "accessToken": accessToken == null ? null : accessToken!,
      "idToken": idToken == null ? null : idToken!,
      "refreshToken": refreshToken == null ? null : refreshToken!,
      "fcmToken": fcmToken == null ? null : fcmToken!,
      "systemName": systemName == null ? null : systemName!,
      "lastUserUpdate": lastUserUpdate == null ? null : lastUserUpdate!,
      "ipsTimeStamp": ipsTimeStamp == null ? null : ipsTimeStamp!,
      "cashBalanceTimeStamp": cashBalanceTimeStamp == null ? null : cashBalanceTimeStamp!,
      "netWorthTimeStamp": netWorthTimeStamp == null ? null : netWorthTimeStamp!,
      "performanceTimeStamp": performanceTimeStamp == null ? null : performanceTimeStamp!,
      "incomeTimeStamp": incomeTimeStamp == null ? null : incomeTimeStamp!,
      "expenseTimeStamp": expenseTimeStamp == null ? null : expenseTimeStamp!,
      "fullName": fullName == null ? null : fullName!,
      "firstName": firstName == null ? null : firstName!,
      "lastName": lastName == null ? null : lastName!,
      "countryCode": countryCode == null ? null : countryCode!,
      "countryFlag": countryFlag == null ? null : countryFlag!,
      "phoneNumber": phoneNumber == null ? null : phoneNumber!,
      "otp": otp == null ? null : otp!,
      "email": email == null ? null : email!,
      "avatar": avatar == null ? null : avatar!,
      "language": language == null ? null : language!,
      "appVersion": appVersion == null ? null : appVersion!,
    };
  }
}