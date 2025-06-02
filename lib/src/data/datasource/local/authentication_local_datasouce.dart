import 'package:hive/hive.dart';

import '../../../config/constants/hive_constants.dart';
import '../../models/authentication/credentials.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> clear({required String systemName, required String username});
  Future<Credentials> getCredential();
  Future<void> saveCredential({required Map<dynamic, dynamic> credentials});
}

class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  @override
  Future<Credentials> getCredential() async{
    final credentialBox = await Hive.openBox(HiveBox.credentialBox);
    final data = await credentialBox.get(HiveFields.credential, defaultValue: {});
    return Credentials.fromJson(data);
  }

  @override
  Future<void> saveCredential({required Map<dynamic, dynamic> credentials}) async{
    final credentialBox = await Hive.openBox(HiveBox.credentialBox);
    final Map<dynamic, dynamic>? credential = await credentialBox.get(HiveFields.credential, defaultValue: {});
    credential?.addAll({"${credentials["systemName"]}": credentials});
    await credentialBox.put(HiveFields.credential, credential);
  }

  @override
  Future<void> clear({required String systemName, required String username}) async{
    if(Hive.isBoxOpen(HiveBox.userPreferenceBox)) {
      await Hive.box(HiveBox.userPreferenceBox).close();
    }

    await Future.wait([
      Hive.openBox(HiveBox.dashboardData),
      Hive.openBox(HiveBox.getUserBox),
      Hive.openBox(HiveBox.entityBox),
      Hive.openBox(HiveBox.currencyBox),
      Hive.openBox(HiveBox.ipsBox),
      Hive.openBox(HiveBox.performanceBox),
      Hive.openBox(HiveBox.performanceFilterBox(postFix: "${systemName}_${username}")),
      Hive.openBox(HiveBox.cashBalanceBox),
      Hive.openBox(HiveBox.cashBalanceFilterBox(postFix: "${systemName}_${username}")),
      Hive.openBox(HiveBox.netWorthBox),
      Hive.openBox(HiveBox.netWorthFilterBox(postFix: "${systemName}_${username}")),
      Hive.openBox(HiveBox.incomeBox),
      Hive.openBox(HiveBox.incomeFilterBox(postFix: "${systemName}_${username}")),
      Hive.openBox(HiveBox.expenseFilterBox(postFix: "${systemName}_${username}")),
      Hive.openBox(HiveBox.expenseBox),
      Hive.openBox(HiveBox.filterBox),
      Hive.openBox(HiveBox.chatBox),
    ]);

    return await Hive.deleteFromDisk();
  }

}