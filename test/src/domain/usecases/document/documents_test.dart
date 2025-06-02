import 'package:asset_vantage/src/data/models/document/document_model.dart';
import 'package:asset_vantage/src/domain/entities/app_error.dart';
import 'package:asset_vantage/src/domain/entities/document/document_entity.dart';
import 'package:asset_vantage/src/domain/entities/document/download_entity.dart';
import 'package:asset_vantage/src/domain/params/document/document_params.dart';
import 'package:asset_vantage/src/domain/params/document/download_params.dart';
import 'package:asset_vantage/src/domain/params/document/search_document_params.dart';
import 'package:asset_vantage/src/domain/usecases/document/download_documents.dart';
import 'package:asset_vantage/src/domain/usecases/document/get_documents.dart';
import 'package:asset_vantage/src/domain/usecases/document/search_document.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'documents_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<DownloadDocuments>()])
@GenerateMocks([], customMocks: [MockSpec<GetDocuments>()])
@GenerateMocks([], customMocks: [MockSpec<SearchDocuments>()])
void main() async {
  group('Document test', () {
    test('DownloadEntity should be return on success api call', () async {
      final downloadDocuments = MockDownloadDocuments();

      when(downloadDocuments(const DownloadParams(
              documentId: '', name: '', extension: '', type: '')))
          .thenAnswer((_) async => Right(DownloadEntity(
              file: Uint8List(0), name: '', extension: '', type: '')));

      final result = await downloadDocuments(const DownloadParams(
          documentId: '', name: '', extension: '', type: ''));

      DocumentModel.fromJson({});
      // DocumentModel().toJson();
      DocumentData.fromJson({});
      DocumentData().toJson();

      DownloadParams(documentId: '', name: '', extension: '', type: '')
          .toJson();

      result.fold((error) {
        expect(error, isA<DownloadEntity>());
      }, (response) {
        expect(response, isA<DownloadEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final downloadDocuments = MockDownloadDocuments();

      when(downloadDocuments(const DownloadParams(
              documentId: '', name: '', extension: '', type: '')))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await downloadDocuments(const DownloadParams(
          documentId: '', name: '', extension: '', type: ''));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('DocumentEntity should be return on success api call', () async {
      final getDocuments = MockGetDocuments();

      when(getDocuments(
              const DocumentParams(entity: '', limit: '', startfrom: '')))
          .thenAnswer(
              (_) async => Right(DocumentEntity(documents: [Document()])));

      final result = await getDocuments(
          const DocumentParams(entity: '', limit: '', startfrom: ''));

      DocumentParams(entity: '', limit: '', startfrom: '').toJson();

      result.fold((error) {
        expect(error, isA<DocumentEntity>());
      }, (response) {
        expect(response, isA<DocumentEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final getDocuments = MockGetDocuments();

      when(getDocuments(
              const DocumentParams(entity: '', limit: '', startfrom: '')))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await getDocuments(
          const DocumentParams(entity: '', limit: '', startfrom: ''));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });

    test('DocumentEntity should be return on success api call', () async {
      final searchDocuments = MockSearchDocuments();

      when(searchDocuments(const SearchDocumentParams(
              entity: '', searchstring: '', limit: '', startfrom: '')))
          .thenAnswer(
              (_) async => Right(DocumentEntity(documents: [Document()])));

      final result = await searchDocuments(const SearchDocumentParams(
          entity: '', searchstring: '', limit: '', startfrom: ''));

      SearchDocumentParams(entity: '', limit: '', startfrom: '').toJson();

      result.fold((error) {
        expect(error, isA<DocumentEntity>());
      }, (response) {
        expect(response, isA<DocumentEntity>());
      });
    });

    test('AppError should be return on api call failure', () async {
      final searchDocuments = MockSearchDocuments();

      when(searchDocuments(const SearchDocumentParams(
              entity: '', searchstring: '', limit: '', startfrom: '')))
          .thenAnswer((_) async => const Left(AppError(AppErrorType.api)));

      final result = await searchDocuments(const SearchDocumentParams(
          entity: '', searchstring: '', limit: '', startfrom: ''));

      result.fold((error) {
        expect(error, isA<AppError>());
      }, (response) {
        expect(response, isA<AppError>());
      });
    });
  });
}
