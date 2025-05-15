import 'package:mongo_dart/mongo_dart.dart';

class MongoDbModel {
  static const String defaultPhoto = 'assets/images/profiledefault.png';

  MongoDbModel({
    required this.id,
    required this.name,
    required this.cid,
    required this.phoneNo,
    required this.emergency,
    required this.password,
    required this.photo,
  });

  ObjectId id;
  String name;
  String cid;
  String phoneNo;
  String emergency;
  String password;
  String photo;

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["id"],
        name: json["name"],
        cid: json["cid"],
        phoneNo: json["phoneNo"],
        emergency: json["emergency"],
        password: json["password"],
        photo: json["photo"] ?? defaultPhoto,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cid": cid,
        "phoneNo": phoneNo,
        "emergency": emergency,
        "password": password,
        "photo": photo,
      };
}
