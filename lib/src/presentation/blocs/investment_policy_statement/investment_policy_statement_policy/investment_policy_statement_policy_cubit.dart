
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/investment_policy_statement/investment_policy_statement_policies_entity.dart';
import '../../../../domain/params/investment_policy_statement/ips_save_filter_params.dart';
import '../../../../domain/usecases/investment_policy_statement/save_ips_policy_filter.dart';

part 'investment_policy_statement_policy_state.dart';

class InvestmentPolicyStatementPolicyCubit extends Cubit<InvestmentPolicyStatementPolicyState> {
  final SaveIpsPolicyFilter saveIpsPolicyFilter;

  InvestmentPolicyStatementPolicyCubit({required this.saveIpsPolicyFilter}) : super(const InvestmentPolicyStatementPolicyInitial());

  void selectPolicy({Policies? selectedPolicy, String? entityName, String? grouping}) async{

    emit(InvestmentPolicyStatementPolicyInitial(
        selectPolicy: state.selectedPolicy
    ));
    await savePolicyFilter(grouping: grouping,entityName: entityName,policy1: selectedPolicy);
    emit(InvestmentPolicyStatementPolicyChanged(
        selectPolicy: selectedPolicy
    )
    );
  }

  Future<void> savePolicyFilter({required String? entityName, required String? grouping, required Policies? policy1,}) async {
    final Either<AppError, void> policy = await saveIpsPolicyFilter(SaveIpsFilterParams(entityName: entityName, grouping: grouping, filter: policy1));

    policy.fold((error) {

    }, (widget) {

    });
  }
}
