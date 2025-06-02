
import 'package:hive/hive.dart';

import '../../../config/constants/hive_constants.dart';
import '../../models/preferences/user_preference.dart';

abstract class AppLocalDataSource {

  Future<UserPreference> getUserPreference();
  Future<void> saveUserPreference({required UserPreference preference, bool shouldClear = false});
}

class AppLocalDataSourceImpl extends AppLocalDataSource {

  @override
  Future<UserPreference> getUserPreference() async {
    final userPreferenceBox = await Hive.openBox(HiveBox.userPreferenceBox);
    final preference = await userPreferenceBox.get(HiveFields.userPreference, defaultValue: {});
    return UserPreference.fromJson(preference);
  }

  @override
  Future<void> saveUserPreference({required UserPreference preference, bool shouldClear = false}) async {
    final userPreferenceBox = await Hive.openBox(HiveBox.userPreferenceBox);

    final Map<dynamic, dynamic> savedPreference = await userPreferenceBox.get(HiveFields.userPreference, defaultValue: {});
    Map<dynamic, dynamic> savedCred = savedPreference['credential'] ?? {};

    if(preference.credential?['systemName'] != null) {
      savedCred.addAll({"${preference.credential?['systemName']}": preference.credential});
    }

    final user = shouldClear ? preference : UserPreference.fromJson(savedPreference)
        .copyWith(
          loginStatus: preference.loginStatus,
          isFirstOpen: preference.isFirstOpen,
          isOnBiometric: preference.isOnBiometric,
          darkMode: preference.darkMode,
          user: preference.user,
          regionUrl: preference.regionUrl,
          region: preference.region,
          username: preference.username,
          credential: savedCred,
          displayname: preference.displayname,
          defaultTheme: preference.defaultTheme,
          password: preference.password,
          userId: preference.userId,
          accessToken: preference.accessToken,
          idToken: preference.idToken,
          refreshToken: preference.refreshToken,
          fcmToken: preference.fcmToken,
          systemName: preference.systemName,
          lastUserUpdate: preference.lastUserUpdate,
          ipsTimeStamp: preference.ipsTimeStamp,
          cashBalanceTimeStamp: preference.cashBalanceTimeStamp,
          netWorthTimeStamp: preference.netWorthTimeStamp,
          performanceTimeStamp: preference.performanceTimeStamp,
          incomeTimeStamp: preference.incomeTimeStamp,
          expenseTimeStamp: preference.expenseTimeStamp,
          fullName: preference.fullName,
          firstName: preference.firstName,
          lastName: preference.lastName,
          countryCode: preference.countryCode,
          countryFlag: preference.countryFlag,
          phoneNumber: preference.phoneNumber,
          otp: preference.otp,
          email: preference.email,
          avatar: preference.avatar,
          language: preference.language,
          appVersion: preference.appVersion,
        );

    await userPreferenceBox.put(HiveFields.userPreference, user.toJson());
  }
}