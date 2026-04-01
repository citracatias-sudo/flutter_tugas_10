class GetUserModel {
  bool? success;
  String? message;
  UserData? data;

  GetUserModel({this.success, this.message, this.data});

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  int? id;
  String? name;
  String? email;

  UserData({this.id, this.name, this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
