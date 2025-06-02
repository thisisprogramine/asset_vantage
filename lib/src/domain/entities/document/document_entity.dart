
class DocumentEntity {
  final List<Document>? documents;

  DocumentEntity({
    this.documents,
  });
}

class Document{
  Document({
    this.id,
    this.entityid,
    this.filename,
    this.description,
    this.type,
    this.size,
    this.updated,
  });

  final String? id;
  final String? entityid;
  final String? filename;
  final String? description;
  final String? type;
  final String? size;
  final String? updated;
}
