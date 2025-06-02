
import 'dart:io';

import 'package:asset_vantage/src/domain/usecases/document/download_documents.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/document/document_entity.dart';
import '../../domain/params/document/download_params.dart';
import 'flash_helper.dart';

class FileHelper {
  FileHelper._();

  static void downloadFile({required BuildContext context, required Document document}) async{

    final downloadedDocument = getItInstance<DownloadDocuments>();

    final eitherDownload = await downloadedDocument(DownloadParams(context: context, documentId: document.id ?? '', name: document.filename ?? '', extension: document.filename?.substring(document.filename?.lastIndexOf('.') ?? 0) ?? '', type: document.type ?? ''));

    eitherDownload.fold((error) {
      FlashHelper.showToastMessage(context, message: 'Failed to download', type: ToastType.error);
    }, (response) async{

      Uint8List bytes = response.file;
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File(
      "$dir/${response.name}");
      await file.writeAsBytes(bytes);

      String rawName = response.name.trim();
      String rawExt = response.extension.trim();

      print("rawName: $rawName");
      print("rawExt: $rawExt");

      if (rawName.toLowerCase().endsWith(".${rawExt.toLowerCase()}")) {
        rawName = rawName.substring(0, rawName.length - rawExt.length - 1);
      }

      if (rawName.endsWith(".")) {
        rawName = rawName.substring(0, rawName.length - 1);
      }

      if (rawExt.startsWith(".")) {
        rawExt = rawExt.substring(1);
      }

      if(Platform.isAndroid) {
        print("Platform.isAndroid: ${Platform.isAndroid}");
        const platform = MethodChannel('com.assetVantagePune.support/save_file');

        try {
          await platform.invokeMethod('saveFileToLocal', {
            'bytes': bytes,
            'fileName': rawName,
            'extension': rawExt,
          });
        }catch(e) {
          print("ERROR:: $e");
        }
      }else {
        await FileSaver.instance.saveAs(
          name: rawName,
          bytes: bytes,
          mimeType: MimeType.custom,
          customMimeType: response.type,
          ext: rawExt,
        );
      }
      FlashHelper.showToastMessage(context, message: 'Document Downloaded', type: ToastType.success);
    });

  }

  static void openFile(
      {required BuildContext context, required Document document}) async {
    final downloadedDocument = getItInstance<DownloadDocuments>();

    final eitherDownload = await downloadedDocument(DownloadParams(
      context: context,
        documentId: document.id ?? '',
        name: document.filename ?? '',
        extension: document.filename
            ?.substring(document.filename?.lastIndexOf('.') ?? 0) ??
            '',
        type: document.type ?? ''));

    eitherDownload.fold((error) {
      FlashHelper.showToastMessage(context, message: 'Failed to open', type: ToastType.error);
    }, (response) async {
      Uint8List bytes = response.file;
      String dir;
      if (Platform.isAndroid) {
        dir = (await getExternalStorageDirectory())?.path ?? '';
      } else {
        dir = (await getApplicationDocumentsDirectory()).path;
      }
      File file = File("$dir/${response.name}");
      await file.writeAsBytes(bytes);
      OpenFilex.open(file.path);
    });
  }

  static void shareFile({required BuildContext context, required Document document}) async{
    final downloadedDocument = getItInstance<DownloadDocuments>();

    final eitherDownload = await downloadedDocument(DownloadParams(context: context, documentId: document.id ?? '', name: document.filename ?? '', extension: document.filename?.substring(document.filename?.lastIndexOf('.') ?? 0) ?? '', type: document.type ?? ''));

    eitherDownload.fold((error) {
      FlashHelper.showToastMessage(context, message: 'Failed to share', type: ToastType.error);
    }, (response) async{
      Uint8List bytes = response.file;
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File(
          "$dir/${response.name}");
      await file.writeAsBytes(bytes);
      Share.shareXFiles([XFile(file.path)]);
    });
  }

}