
import '../../../domain/entities/document/document_entity.dart';

class DocumentModel extends DocumentEntity{
  DocumentModel({
    this.documentList,
  }) : super(
    documents: documentList
  );

  final List<DocumentData>? documentList;

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
    documentList: json["result"] == null ? [] : List<DocumentData>.from(json["result"]!.map((x) => DocumentData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": documentList == null ? [] : List<dynamic>.from(documentList!.map((x) => x.toJson())),
  };
}

class DocumentData extends Document{
  DocumentData({
    this.id,
    this.entityid,
    this.filename,
    this.description,
    this.type,
    this.size,
    this.updated,
  }) : super(
    id: id,
    entityid: entityid,
    filename: filename,
    description: description,
    type: type,
    size: size,
    updated: updated,
  );

  final String? id;
  final String? entityid;
  final String? filename;
  final String? description;
  final String? type;
  final String? size;
  final String? updated;

  factory DocumentData.fromJson(Map<String, dynamic> json) => DocumentData(
    id: json["id"],
    entityid: json["entityid"],
    filename: json["filename"],
    description: json["description"],
    type: json["type"],
    size: json["size"],
    updated: json["updated"] == null ? null : json["updated"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entityid": entityid,
    "filename": filename,
    "description": description,
    "type": type,
    "size": size,
    "updated": updated,
  };
}
