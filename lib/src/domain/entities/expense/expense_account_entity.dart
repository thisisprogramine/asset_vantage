import 'package:equatable/equatable.dart';

class ExpenseAccountEntity extends Equatable{
  ExpenseAccountEntity({
    required this.expenseAccounts,
  });

  List<AccountEntity?> expenseAccounts;

  @override
  List<Object?> get props => [];
}

class AccountEntity extends Equatable{
  const AccountEntity({
    this.id,
    this.accountname,
    this.accounttype,
  });

  final int? id;
  final String? accountname;
  final String? accounttype;

  Map<String, dynamic> toJson() => {
    "id": id,
    "accountname": accountname,
    "accounttype": accounttype
  };

  @override
  List<Object?> get props => [id, accountname, accounttype];

}