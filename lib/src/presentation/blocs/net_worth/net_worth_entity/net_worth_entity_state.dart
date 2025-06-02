part of 'net_worth_entity_cubit.dart';

abstract class NetWorthEntityState extends Equatable {
  final EntityData? selectedNetWorthEntity;
  final List<EntityData?>? netWorthEntityList;
  const NetWorthEntityState({this.selectedNetWorthEntity, this.netWorthEntityList});

  @override
  List<Object> get props => [];
}

class NetWorthEntityInitial extends NetWorthEntityState {}

class NetWorthEntityLoaded extends NetWorthEntityState {
  final EntityData? selectedEntity;
  final List<EntityData?>? entityList;
  const NetWorthEntityLoaded({
    required this.entityList,
    required this.selectedEntity,
  }) :super(selectedNetWorthEntity: selectedEntity, netWorthEntityList: entityList);

  @override
  List<Object> get props => [];
}

class NetWorthEntityError extends NetWorthEntityState {
  final AppErrorType errorType;

  const NetWorthEntityError({
    required this.errorType,
  });
}

class NetWorthEntityLoading extends NetWorthEntityState {
  const NetWorthEntityLoading();
}
