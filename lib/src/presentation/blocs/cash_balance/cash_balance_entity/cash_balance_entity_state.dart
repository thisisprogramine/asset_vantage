part of 'cash_balance_entity_cubit.dart';

abstract class CashBalanceEntityState extends Equatable {
  final EntityData? selectedCashBalanceEntity;
  final List<EntityData?>? cashBalanceEntityList;
  const CashBalanceEntityState({this.selectedCashBalanceEntity, this.cashBalanceEntityList});

  @override
  List<Object> get props => [];
}

class CashBalanceEntityInitial extends CashBalanceEntityState {}

class CashBalanceEntityLoaded extends CashBalanceEntityState {
  final EntityData? selectedEntity;
  final List<EntityData?>? entityList;
  const CashBalanceEntityLoaded({
    required this.entityList,
    required this.selectedEntity,
  }) :super(selectedCashBalanceEntity: selectedEntity, cashBalanceEntityList: entityList);

  @override
  List<Object> get props => [];
}

class CashBalanceEntityError extends CashBalanceEntityState {
  final AppErrorType errorType;

  const CashBalanceEntityError({
    required this.errorType,
  });
}

class CashBalanceEntityLoading extends CashBalanceEntityState {
  const CashBalanceEntityLoading();
}
