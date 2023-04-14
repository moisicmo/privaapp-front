// To parse this JSON data, do
//
//     final circleTrustModel = circleTrustModelFromJson(jsonString);

import 'dart:convert';

List<CircleTrustModel?>? circleTrustModelFromJson(String str) => json.decode(str) == null
    ? []
    : List<CircleTrustModel?>.from(json.decode(str)!.map((x) => CircleTrustModel.fromJson(x)));

String circleTrustModelToJson(List<CircleTrustModel?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class CircleTrustModel {
  CircleTrustModel({
    this.groupId,
    this.reason,
    this.group,
    this.users,
  });

  int? groupId;
  String? reason;
  Group? group;
  List<UserElement?>? users;

  CircleTrustModel copyWith({
    int? groupId,
    String? reason,
    Group? group,
    List<UserElement?>? users,
  }) =>
      CircleTrustModel(
        groupId: groupId ?? this.groupId,
        reason: reason ?? this.reason,
        group: group ?? this.group,
        users: users ?? this.users,
      );

  factory CircleTrustModel.fromJson(Map<String, dynamic> json) => CircleTrustModel(
        groupId: json["group_id"],
        reason: json["reason"],
        group: Group.fromJson(json["group"]),
        users: json["users"] == null ? [] : List<UserElement?>.from(json["users"]!.map((x) => UserElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "reason": reason,
        "group": group!.toJson(),
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x!.toJson())),
      };
}

class Group {
  Group({
    this.id,
    this.name,
    this.description,
    this.level,
  });

  int? id;
  String? name;
  String? description;
  String? level;

  Group copyWith({
    int? id,
    String? name,
    String? description,
    String? level,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        level: level ?? this.level,
      );

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "level": level,
      };
}

class UserElement {
  UserElement({
    this.reason,
    this.user,
  });

  String? reason;
  UserUser? user;

  UserElement copyWith({
    String? reason,
    UserUser? user,
  }) =>
      UserElement(
        reason: reason ?? this.reason,
        user: user ?? this.user,
      );

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
        reason: json["reason"],
        user: UserUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "user": user!.toJson(),
      };
}

class UserUser {
  UserUser({
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

  UserUser copyWith({
    int? id,
    String? name,
    String? lastName,
    String? email,
    int? phone,
    String? gender,
    dynamic numberWp,
    String? avatar,
  }) =>
      UserUser(
        id: id ?? this.id,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        gender: gender ?? this.gender,
        numberWp: numberWp ?? this.numberWp,
        avatar: avatar ?? this.avatar,
      );

  factory UserUser.fromJson(Map<String, dynamic> json) => UserUser(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        numberWp: json["number_wp"],
        avatar: json["avatar"],
      );

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
