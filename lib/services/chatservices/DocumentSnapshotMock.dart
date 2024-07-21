
class DocumentSnapshotMock {
  final Map<String, dynamic> dataMap;
  final String documentId;

  DocumentSnapshotMock(this.dataMap, this.documentId);

  Map<String, dynamic> data() {
    return dataMap;
  }
}
