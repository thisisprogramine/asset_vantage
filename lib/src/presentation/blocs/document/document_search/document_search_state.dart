part of 'document_search_cubit.dart';

abstract class DocumentSearchState extends Equatable {
  const DocumentSearchState();

  @override
  List<Object> get props => [];
}

class DocumentSearchInitial extends DocumentSearchState {}

class DocumentSearchLoaded extends DocumentSearchState {
  final List<Document> documents;
  const DocumentSearchLoaded({
    required this.documents
  });

  @override
  List<Object> get props => [];
}

class DocumentSearchLoading extends DocumentSearchState {}

class DocumentSearchError extends DocumentSearchState {
  final AppErrorType errorType;

  const DocumentSearchError({
    required this.errorType,
  });
}
