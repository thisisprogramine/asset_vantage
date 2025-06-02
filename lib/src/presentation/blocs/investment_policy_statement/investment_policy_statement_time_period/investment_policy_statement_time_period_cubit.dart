
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/entities/investment_policy_statement/investment_policy_statement_time_period_entity.dart';
import '../../../../domain/params/investment_policy_statement/ips_save_filter_params.dart';
import '../../../../domain/usecases/investment_policy_statement/save_ips_return_filter.dart';

part 'investment_policy_statement_time_period_state.dart';

class InvestmentPolicyStatementTimePeriodCubit extends Cubit<InvestmentPolicyStatementTimePeriodState> {
  final SaveIpsReturnFilter saveIpsReturnFilter;

  InvestmentPolicyStatementTimePeriodCubit({required this.saveIpsReturnFilter}) : super(const InvestmentPolicyStatementTimePeriodInitial());

  void selectYear1({TimePeriodItemData? selectedTimePeriod, String? entityName, String? grouping}) async{

    emit(InvestmentPolicyStatementTimePeriodInitial(
        selectedItem: state.timePeriodSelectedItem
    ));
    await saveSelectedPeriod(entityName: entityName, grouping: grouping, period1: selectedTimePeriod);
    emit(InvestmentPolicyStatementTimePeriodChanged(
        selectedItem: selectedTimePeriod
    )
    );
  }
  Future<void> saveSelectedPeriod({required String? entityName, required String? grouping, required TimePeriodItemData? period1,}) async {
    final Either<AppError, void> period = await saveIpsReturnFilter(
        SaveIpsFilterParams(
            entityName: entityName, grouping: grouping, filter: period1));

    period.fold((error) {

    }, (widget) {

    });
  }

}
