// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel? userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel? data) => json.encode(data!.toJson());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.numberWp,
    this.avatar,
  });

  int? id;
  String? name;
  String? lastName;
  String? email;
  int? phone;
  String? gender;
  dynamic numberWp;
  String? avatar;

  UserModel copyWith({
    int? id,
    String? name,
    String? lastName,
    String? email,
    int? phone,
    String? gender,
    dynamic numberWp,
    String? avatar,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        gender: gender ?? this.gender,
        numberWp: numberWp ?? this.numberWp,
        avatar: avatar ?? this.avatar,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      name: json["name"],
      lastName: json["last_name"],
      email: json["email"],
      phone: json["phone"],
      gender: json["gender"],
      numberWp: json["number_wp"],
      avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "gender": gender,
        "number_wp": numberWp,
        "avatar": avatar,
      };
}
