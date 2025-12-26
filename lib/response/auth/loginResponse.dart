import 'package:carcheks/model/user_table_model.dart';

class LoginResponseResponse {
  String? message;
  User? data;
  bool? success;

  LoginResponseResponse({
    this.message,
    this.data,
    this.success,
  });

  factory LoginResponseResponse.fromJson(Map<String, dynamic> json) => LoginResponseResponse(
    message: json["message"],
    data: json["data"] == null ? null : User.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "success": success,
  };
}


