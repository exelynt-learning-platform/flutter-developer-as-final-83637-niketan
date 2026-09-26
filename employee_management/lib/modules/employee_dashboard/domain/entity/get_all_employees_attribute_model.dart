class GetAllEmployeesAttributeModel {
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

  GetAllEmployeesAttributeModel({
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

  GetAllEmployeesAttributeModel copyWith({
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
  }) => GetAllEmployeesAttributeModel(
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
}
