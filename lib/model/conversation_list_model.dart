class ConverstaionListModel {
  String id;
  dynamic secret;
  int? createdAt;
  dynamic isGroup;
  dynamic show;
  dynamic participants;
  String title;
  String image;
  dynamic participantsinfo;

  ConverstaionListModel(
    this.id,
    this.secret,
    this.createdAt,
    this.show,
    this.participants,
    this.title,
    this.image,
    this.participantsinfo,
  );
}
