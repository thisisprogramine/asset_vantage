part of 'income_entity_cubit.dart';

abstract class IncomeEntityState extends Equatable {
  final EntityData? selectedIncomeEntity;
  final List<EntityData?>? incomeEntityList;
  const IncomeEntityState({this.selectedIncomeEntity, this.incomeEntityList});

  @override
  List<Object> get props => [];
}

class IncomeEntityInitial extends IncomeEntityState {}

class IncomeEntityLoaded extends IncomeEntityState {
  final EntityData? selectedEntity;
  final List<EntityData?>? entityList;
  const IncomeEntityLoaded({
    required this.entityList,
    required this.selectedEntity,
  }) : super(selectedIncomeEntity: selectedEntity, incomeEntityList: entityList);

  @override
  List<Object> get props => [];
}

class IncomeEntityError extends IncomeEntityState {
  final AppErrorType errorType;

  const IncomeEntityError({
    required this.errorType,
  });
}

class IncomeEntityLoading extends IncomeEntityState {
  const IncomeEntityLoading();
}
