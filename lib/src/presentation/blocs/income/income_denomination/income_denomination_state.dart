part of 'income_denomination_cubit.dart';

abstract class IncomeDenominationState extends Equatable {
  final DenominationData? selectedIncomeDenomination;
  final List<DenominationData?>? incomeDenominationList;
  const IncomeDenominationState({this.selectedIncomeDenomination, this.incomeDenominationList});

  @override
  List<Object> get props => [];
}

class IncomeDenominationInitial extends IncomeDenominationState {}

class IncomeDenominationLoaded extends IncomeDenominationState {
  final DenominationData? selectedDenomination;
  final List<DenominationData?>? denominationList;
  const IncomeDenominationLoaded({
    required this.denominationList,
    required this.selectedDenomination,
  }) :super(selectedIncomeDenomination: selectedDenomination, incomeDenominationList: denominationList);

  @override
  List<Object> get props => [];
}

class IncomeDenominationError extends IncomeDenominationState {
  final AppErrorType errorType;

  const IncomeDenominationError({
    required this.errorType,
  });
}

class IncomeDenominationLoading extends IncomeDenominationState {
  const IncomeDenominationLoading();
}
