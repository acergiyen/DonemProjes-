
class User {
  int Id;
  String NameSurname;
  String Email;
  String PasswordHash;
  int UserType;
  String Gsm;
  int PhotoRef;
  int State;
  String GoogleProfileId;
  int RandomNumber;
  User(this.Email, this.PasswordHash);

  User.map(dynamic obj) {
    this.Email = obj["username"];
    this.PasswordHash = obj["password"];
  }

  String get email => Email;
  String get password => PasswordHash;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = Email;
    map["password"] = PasswordHash;

    return map;
  }
}