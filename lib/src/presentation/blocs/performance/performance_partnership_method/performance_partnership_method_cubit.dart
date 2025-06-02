import 'package:asset_vantage/src/data/models/partnership_method/partnership_method_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/partnership_method/get_partnership_method.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/token/token_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/performance/performance_partnership_method/performance_partnership_method_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/performance/performance_filter/selected_partnership_method/get_performance_selected_partnership_method.dart';

class PerformancePartnershipMethodCubit extends Cubit<PerformancePartnershipMethodState>{
  final GetPartnershipMethod getPartnershipMethod;
  final GetPerformanceSelectedPartnershipMethod getPerformanceSelectedPartnershipMethod;

  PerformancePartnershipMethodCubit({
    required this.getPartnershipMethod,
    required this.getPerformanceSelectedPartnershipMethod}):super(
    PerformancePartnershipMethodInitial()
  );

  Future<void> loadPerformancePartnershipMethod({
   required BuildContext context, required String tileName,
    PartnershipMethodItem? favoritePartnershipMethodItemData })async{

    context.read<TokenCubit>().checkIfTokenExpired();

    emit(PerformancePartnershipMethodInitial());

    final Either<AppError,PartnershipMethodEntities> eitherPartnershipMethod = await getPartnershipMethod(context);
    final PartnershipMethodItemData? savedPartnershipMethod = favoritePartnershipMethodItemData ?? await getPerformanceSelectedPartnershipMethod(tileName);

    eitherPartnershipMethod.fold(
            (error){

            }, (partnershipMethodEntity){
              List<PartnershipMethodItemData> partnershipMethodList = partnershipMethodEntity.partnershipMethodList;
              PartnershipMethodItemData? selectedPartnershipMethod = (partnershipMethodEntity.partnershipMethodList.isNotEmpty) ? partnershipMethodEntity.partnershipMethodList.first : null;
              if(savedPartnershipMethod != null){
                selectedPartnershipMethod = partnershipMethodList.firstWhere((partnershipMethod)=>partnershipMethod.id == savedPartnershipMethod.id);
                partnershipMethodList.removeWhere((partnershipMethod)=> partnershipMethod.id == selectedPartnershipMethod?.id);
                partnershipMethodList.insert(0, selectedPartnershipMethod);
              }
              emit(PerformancePartnershipMethodLoaded(
                  selectedPartnershipMethod: selectedPartnershipMethod,
                  partnershipMethodList: partnershipMethodList.toSet().toList()));
    });
  }

  Future<void> changeSelectedPerformancePartnershipMethod({PartnershipMethodItemData? selectedPartnershipMethod}) async{
    List<PartnershipMethodItemData> partnershipList = state.performancePartnershipList ?? [];

    emit(PerformancePartnershipMethodInitial());
    emit(PerformancePartnershipMethodLoaded(
        selectedPartnershipMethod: selectedPartnershipMethod,
        partnershipMethodList: partnershipList.toSet().toList()));
  }

}