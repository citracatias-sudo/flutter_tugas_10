class RegisterModel {
  bool? success;
  String? message;
  RegisterData? data;

  RegisterModel({this.success, this.message, this.data});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
    );
  }
}

class RegisterData {
  int? id;
  String? name;
  String? email;
  String? token;

  RegisterData({this.id, this.name, this.email, this.token});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }
}
