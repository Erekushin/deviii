class SearchModel {
  String id;
  String doctorId;
  String content;
  String location;
  String type;
  List<String> tags;
  int createdAt;
  SearchModel(
    this.id,
    this.doctorId,
    this.content,
    this.location,
    this.type,
    this.tags,
    this.createdAt,
  );
}
