import 'package:asset_vantage/src/data/models/partnership_method/partnership_method_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/partnership_method/partnership_method.dart';
import 'package:asset_vantage/src/domain/usecases/net_worth/net_worth_filter/selected_partnership_method/get_networth_selected_partnership_method.dart';
import 'package:asset_vantage/src/presentation/blocs/authentication/token/token_cubit.dart';
import 'package:asset_vantage/src/presentation/blocs/net_worth/networth_partnership_method/networth_partnership_method_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/partnership_method/get_partnership_method.dart';

class NetWorthPartnershipMethodCubit extends Cubit<NetWorthPartnershipMethodState>{
  final GetPartnershipMethod getPartnershipMethod;
  final GetNetWorthSelectedPartnershipMethod getNetworthSelectedPartnershipMethod;

  NetWorthPartnershipMethodCubit({
    required this.getPartnershipMethod,
    required this.getNetworthSelectedPartnershipMethod}) : super(NetWorthPartnershipMethodInitial());

  Future<void> loadNetWorthPartnershipMethod({
    required BuildContext context, required String tileName, PartnershipMethodItem? favoritePartnershipMethodItemData}) async{

    context.read<TokenCubit>().checkIfTokenExpired();

    emit(const NetWorthPartnershipMethodLoading());

    final Either<AppError,PartnershipMethodEntities> eitherPartnershipMethod = await getPartnershipMethod(context);
    final PartnershipMethodItemData? savedPartnershipMethod = favoritePartnershipMethodItemData ?? await getNetworthSelectedPartnershipMethod(tileName);

    eitherPartnershipMethod.fold(
            (error){

            }, (partnershipMethodEntity){
          List<PartnershipMethodItemData> partnershipMethodList = partnershipMethodEntity.partnershipMethodList;
          PartnershipMethodItemData? selectedPartnershipMethod = (partnershipMethodEntity.partnershipMethodList.isNotEmpty) ? partnershipMethodEntity.partnershipMethodList.first : null;
          if(savedPartnershipMethod != null){
            selectedPartnershipMethod = partnershipMethodList.firstWhere((partnershipMethod)=>partnershipMethod.id == savedPartnershipMethod.id);
            partnershipMethodList.removeWhere((partnershipMethod)=>partnershipMethod.id == selectedPartnershipMethod?.id);
            partnershipMethodList.insert(0, selectedPartnershipMethod);
          }
          emit(NetWorthPartnershipMethodLoaded(
              selectedPartnershipMethod: selectedPartnershipMethod,
              partnershipMethodList: partnershipMethodList.toSet().toList()));
    },
    );
  }

  Future<void> changeSelectedNetWorthPartnershipMethod({PartnershipMethodItemData? selectedPartnershipMethod}) async{
    List<PartnershipMethodItemData> partnershipList = state.netWorthPartnershipMethodList ?? [];

    emit(NetWorthPartnershipMethodInitial());
    emit(NetWorthPartnershipMethodLoaded(
        selectedPartnershipMethod: selectedPartnershipMethod,
        partnershipMethodList: partnershipList.toSet().toList()));
  }

}