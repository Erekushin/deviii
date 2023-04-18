class UserModelData {
  String id;
  String email;
  String phone;
  String password;
  String firstName;
  String lastName;
  String provider;
  dynamic picture;
  dynamic googleId;
  dynamic facebookId;
  int createdAt;
  int updatedAt;
  int status;

  UserModelData(
    this.id,
    this.email,
    this.phone,
    this.password,
    this.firstName,
    this.lastName,
    this.provider,
    this.picture,
    this.googleId,
    this.facebookId,
    this.createdAt,
    this.updatedAt,
    this.status,
  );
}
