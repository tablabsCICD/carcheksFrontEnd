import 'package:carcheks/model/feedback_model.dart';

class SaveFeedbackModel {
  String? message;
  FeedbackObject? data;
  bool? success;

  SaveFeedbackModel({
    this.message,
    this.data,
    this.success,
  });

  factory SaveFeedbackModel.fromJson(Map<String, dynamic> json) => SaveFeedbackModel(
    message: json["message"],
    data: json["data"] == null ? null : FeedbackObject.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "success": success,
  };
}
