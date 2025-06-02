part of 'document_cubit.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoaded extends DocumentState {
  final List<Document> documents;
  const DocumentLoaded({
    required this.documents
  });

  @override
  List<Object> get props => [];
}

class DocumentLoading extends DocumentState {}

class DocumentError extends DocumentState {
  final AppErrorType errorType;

  const DocumentError({
    required this.errorType,
  });
}
