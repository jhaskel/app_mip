class UserModel {
  String? displayName;
  String? email;
  String? photoURL;

  UserModel({this.displayName, this.email, this.photoURL});

  UserModel.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    photoURL = json['photoURL'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> mapData = new Map<String, dynamic>();
    mapData['email'] = this.email;
    mapData['displayName'] = this.displayName;
    mapData['photoURL'] = this.photoURL;

    return mapData;
  }
}
