

import 'package:asset_vantage/src/domain/entities/investment_policy_statement/investment_policy_statement_sub_grouping_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_error.dart';
import '../../../../domain/params/investment_policy_statement/ips_save_filter_params.dart';
import '../../../../domain/usecases/investment_policy_statement/save_ips_sub_group_filter.dart';

part 'investment_policy_statement_sub_grouping_state.dart';

class InvestmentPolicyStatementSubGroupingCubit extends Cubit<InvestmentPolicyStatementSubGroupingState> {
  final SaveIpsSubFilter saveIpsSubFilters;

  InvestmentPolicyStatementSubGroupingCubit({required this.saveIpsSubFilters}) : super(const InvestmentPolicyStatementSubGroupingInitial(selectedItems: []));

  void selectItemInFilter1({required List<SubGroupingItemData> selectedFilter, required String? entityName, required String? grouping,}) async{

    emit(InvestmentPolicyStatementSubGroupingInitial(selectedItems: selectedFilter));
    await saveSubFilters(entityName: entityName, grouping: grouping, subFilters1: selectedFilter);
    emit(InvestmentPolicyStatementSubGroupingChanged(selectedItems: selectedFilter));
  }
  Future<void> saveSubFilters({required String? entityName, required String? grouping, required List<SubGroupingItemData>? subFilters1,}) async {
    final Either<AppError, void> subFilters = await saveIpsSubFilters(
        SaveIpsFilterParams(
            entityName: entityName, grouping: grouping, filter: subFilters1));

    subFilters.fold((error) {

    }, (widget) {

    });
  }
}
