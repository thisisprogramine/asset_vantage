part of 'performance_entity_cubit.dart';

abstract class PerformanceEntityState extends Equatable {
  final EntityData? selectedPerformanceEntity;
  final List<EntityData?>? performanceEntityList;
  const PerformanceEntityState({this.selectedPerformanceEntity, this.performanceEntityList});

  @override
  List<Object> get props => [];
}

class PerformanceEntityInitial extends PerformanceEntityState {}

class PerformanceEntityLoaded extends PerformanceEntityState {
  final EntityData? selectedEntity;
  final List<EntityData?>? entityList;
  const PerformanceEntityLoaded({
    required this.entityList,
    required this.selectedEntity,
  }) :super(selectedPerformanceEntity: selectedEntity, performanceEntityList: entityList);

  @override
  List<Object> get props => [];
}

class PerformanceEntityError extends PerformanceEntityState {
  final AppErrorType errorType;

  const PerformanceEntityError({
    required this.errorType,
  });
}

class PerformanceEntityLoading extends PerformanceEntityState {
  const PerformanceEntityLoading();
}
