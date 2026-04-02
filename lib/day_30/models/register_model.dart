class RegisterModel {
  bool? success;
  String? message;
  RegisterData? data;

  RegisterModel({this.success, this.message, this.data});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final token = json['token'];

    return RegisterModel(
      success: json['success'],
      message: json['message'],
      data: rawData is Map<String, dynamic>
          ? RegisterData.fromJson(rawData).copyWith(
              token: token is String && token.isNotEmpty ? token : null,
            )
          : (token is String && token.isNotEmpty
                ? RegisterData(token: token)
                : null),
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

  RegisterData copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
  }) {
    return RegisterData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
