class CreateEmployeeRequestModel {
  final String name;
  final String avatar;
  final String emailId;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String email;

  const CreateEmployeeRequestModel({
    required this.name,
    required this.avatar,
    required this.emailId,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'emailId': emailId,
      'mobile': mobile,
      'country': country,
      'state': state,
      'district': district,
      'email': email,
    };
  }
}
