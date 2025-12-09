class FeedbackModel {
  String? message;
  List<FeedbackObject>? data;
  bool? success;

  FeedbackModel({
    this.message,
    this.data,
    this.success,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
    message: json["message"],
    data: json["data"] == null ? [] : List<FeedbackObject>.from(json["data"]!.map((x) => FeedbackObject.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };
}

class FeedbackObject {
  int? id;
  int? userId;
  String? subject;
  String? message;
  String? status;
  int? createdAt;
  int? updatedAt;
  String? userName;
  String? email;
  String? contactNumber;

  FeedbackObject({
    this.id,
    this.userId,
    this.subject,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.email,
    this.contactNumber,
  });

  factory FeedbackObject.fromJson(Map<String, dynamic> json) => FeedbackObject(
    id: json["id"],
    userId: json["userId"],
    subject: json["subject"],
    message: json["message"],
    status: json["status"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    userName: json["userName"],
    email: json["email"],
    contactNumber: json["contactNumber"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "subject": subject,
    "message": message,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "userName": userName,
    "email": email,
    "contactNumber": contactNumber,
  };
}
