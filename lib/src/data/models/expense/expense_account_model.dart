
import 'package:asset_vantage/src/domain/entities/expense/expense_account_entity.dart';

class ExpenseAccountModel extends ExpenseAccountEntity{
  final List<ExpenseAccount>? expenseAccount;

  ExpenseAccountModel({
    this.expenseAccount,
  }) : super(
    expenseAccounts: expenseAccount ?? []
  );

  factory ExpenseAccountModel.fromJson(Map<dynamic, dynamic> json) => ExpenseAccountModel(
    expenseAccount: json["expenseAccount"] == null ? [] : List<ExpenseAccount>.from(json["expenseAccount"]!.map((x) => ExpenseAccount.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "expenseAccount": expenseAccount == null ? [] : List<dynamic>.from(expenseAccount!.map((x) => x.toJson())),
  };
}

class ExpenseAccount extends AccountEntity{
  final int? id;
  final String? accountname;
  final String? accounttype;

  ExpenseAccount({
    this.id,
    this.accountname,
    this.accounttype,
  }) : super(
    id: id,
    accountname: accountname,
    accounttype: accounttype,
  );

  factory ExpenseAccount.fromJson(Map<dynamic, dynamic> json) => ExpenseAccount(
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
