import 'package:equatable/equatable.dart';

class IncomeAccountEntity extends Equatable{
  IncomeAccountEntity({
    required this.incomeAccounts,
  });

  List<Account?> incomeAccounts;

  @override
  List<Object?> get props => [];
}

class Account extends Equatable{
  const Account({
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

  static List<Account?>? fromJson(Map x) {}

}