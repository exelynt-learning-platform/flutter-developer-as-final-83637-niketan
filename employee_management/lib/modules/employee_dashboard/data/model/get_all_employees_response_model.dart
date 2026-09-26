// To parse this JSON data, do
//
//     final getAllEmployeesModelResponse = getAllEmployeesModelResponseFromJson(jsonString);

import 'dart:convert';

List<GetAllEmployeesModelResponse> getAllEmployeesModelResponseFromJson(String str) =>
    List<GetAllEmployeesModelResponse>.from(json.decode(str).map((x) => GetAllEmployeesModelResponse.fromJson(x)));

String getAllEmployeesModelResponseToJson(List<GetAllEmployeesModelResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllEmployeesModelResponse {
  String? createdAt;
  String? name;
  String? avatar;
  String? emailId;
  String? mobile;
  String? country;
  String? state;
  String? district;
  String? id;
  String? email;
  String? profilePhoto;

  GetAllEmployeesModelResponse({
    this.createdAt,
    this.name,
    this.avatar,
    this.emailId,
    this.mobile,
    this.country,
    this.state,
    this.district,
    this.id,
    this.email,
    this.profilePhoto,
  });

  GetAllEmployeesModelResponse copyWith({
    String? createdAt,
    String? name,
    String? avatar,
    String? emailId,
    String? mobile,
    String? country,
    String? state,
    String? district,
    String? id,
    String? email,
    String? profilePhoto,
  }) => GetAllEmployeesModelResponse(
    createdAt: createdAt ?? this.createdAt,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    emailId: emailId ?? this.emailId,
    mobile: mobile ?? this.mobile,
    country: country ?? this.country,
    state: state ?? this.state,
    district: district ?? this.district,
    id: id ?? this.id,
    email: email ?? this.email,
    profilePhoto: profilePhoto ?? this.profilePhoto,
  );

  factory GetAllEmployeesModelResponse.fromJson(Map<String, dynamic> json) => GetAllEmployeesModelResponse(
    createdAt: json["createdAt"],
    name: json["name"],
    avatar: json["avatar"],
    emailId: json["emailId"],
    mobile: json["mobile"],
    country: json["country"],
    state: json["state"],
    district: json["district"],
    id: json["id"],
    email: json["email"],
    profilePhoto: json["profilePhoto"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt,
    "name": name,
    "avatar": avatar,
    "emailId": emailId,
    "mobile": mobile,
    "country": country,
    "state": state,
    "district": district,
    "id": id,
    "email": email,
    "profilePhoto": profilePhoto,
  };
}
