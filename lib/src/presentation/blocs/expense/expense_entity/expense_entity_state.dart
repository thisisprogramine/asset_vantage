part of 'expense_entity_cubit.dart';

abstract class ExpenseEntityState extends Equatable {
  final EntityData? selectedExpenseEntity;
  final List<EntityData?>? expenseEntityList;
  const ExpenseEntityState({this.selectedExpenseEntity, this.expenseEntityList});

  @override
  List<Object> get props => [];
}

class ExpenseEntityInitial extends ExpenseEntityState {}

class ExpenseEntityLoaded extends ExpenseEntityState {
  final EntityData? selectedEntity;
  final List<EntityData?>? entityList;
  const ExpenseEntityLoaded({
    required this.entityList,
    required this.selectedEntity,
  }) : super(selectedExpenseEntity: selectedEntity, expenseEntityList: entityList);

  @override
  List<Object> get props => [];
}

class ExpenseEntityError extends ExpenseEntityState {
  final AppErrorType errorType;

  const ExpenseEntityError({
    required this.errorType,
  });
}

class ExpenseEntityLoading extends ExpenseEntityState {
  const ExpenseEntityLoading();
}
