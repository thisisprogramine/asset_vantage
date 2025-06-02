part of 'universal_entity_filter_cubit.dart';

abstract class UniversalEntityFilterState extends Equatable {
  final EntityData? selectedUniversalEntity;
  final List<EntityData?>? universalEntityList;
  const UniversalEntityFilterState({this.selectedUniversalEntity, this.universalEntityList});

  @override
  List<Object> get props => [];
}

class UniversalEntityInitial extends UniversalEntityFilterState {}

class UniversalEntityLoaded extends UniversalEntityFilterState {
  final EntityData? selectedEntity;
  final List<EntityData?>? entityList;
  const UniversalEntityLoaded({
    required this.entityList,
    required this.selectedEntity,
  }) :super(selectedUniversalEntity: selectedEntity, universalEntityList: entityList);

  @override
  List<Object> get props => [];
}

class UniversalEntityError extends UniversalEntityFilterState {
  final AppErrorType errorType;

  const UniversalEntityError({
    required this.errorType,
  });
}

class UniversalEntityLoading extends UniversalEntityFilterState {
  const UniversalEntityLoading();
}
