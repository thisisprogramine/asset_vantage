
import 'package:asset_vantage/src/domain/entities/income/income_account_entity.dart';

class IncomeAccountModel extends IncomeAccountEntity{
  final List<IncomeAccount>? incomeAccount;

  IncomeAccountModel({
    this.incomeAccount,
  }) : super(
    incomeAccounts: incomeAccount ?? []
  );

  factory IncomeAccountModel.fromJson(Map<dynamic, dynamic> json) => IncomeAccountModel(
    incomeAccount: json["incomeAccount"] == null ? [] : List<IncomeAccount>.from(json["incomeAccount"]!.map((x) => IncomeAccount.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "incomeAccount": incomeAccount == null ? [] : List<dynamic>.from(incomeAccount!.map((x) => x.toJson())),
  };
}

class IncomeAccount extends Account{
  final int? id;
  final String? accountname;
  final String? accounttype;

  IncomeAccount({
    this.id,
    this.accountname,
    this.accounttype,
  }) : super(
    id: id,
    accountname: accountname,
    accounttype: accounttype
  );

  factory IncomeAccount.fromJson(Map<dynamic, dynamic> json) => IncomeAccount(
    id: json["id"],
    accountname: json["accountname"],
    accounttype: json["accounttype"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "accountname": accountname,
    "accounttype": accounttype
  };
}
