part of 'document_filter_cubit.dart';

abstract class DocumentFilterState extends Equatable {
  final List<EntityData>? filterList;
  final EntityData? selectedFilter;
  final List<EntityData>? originalList;

  const DocumentFilterState({
    this.filterList,
    this.selectedFilter,
    this.originalList
  });

  @override
  List<Object> get props => [];
}

class DocumentFilterInitial extends DocumentFilterState {
  final List<EntityData>? list;
  final EntityData? selectFilter;
  final List<EntityData>? origList;

  const DocumentFilterInitial({
    this.list,
    this.selectFilter,
    this.origList,
  }) : super(
    filterList: list,
    selectedFilter: selectFilter,
    originalList: origList
  );
}

class DocumentFilterChanged extends DocumentFilterState {
  final List<EntityData>? list;
  final EntityData? selectFilter;
  final List<EntityData>? origList;

  const DocumentFilterChanged({
    required this.list,
    required this.selectFilter,
    required this.origList,
  }) : super(
    filterList: list,
    selectedFilter: selectFilter,
    originalList: origList
  );
}

class DocumentFilterLoading extends DocumentFilterState {}

class DocumentFilterError extends DocumentFilterState {
  final String message;
  final AppErrorType appErrorType;

  const DocumentFilterError(this.message,this.appErrorType);

  @override
  List<Object> get props => [message,appErrorType];
}