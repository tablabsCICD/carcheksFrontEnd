class BalanceResponse {
  String? message;
  Data? data;
  bool? success;

  BalanceResponse({
    this.message,
    this.data,
    this.success,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) => BalanceResponse(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "success": success,
  };
}

class Data {
  double? availableAmount;
  int? garageId;
  int? totalOrders;

  Data({
    this.availableAmount,
    this.garageId,
    this.totalOrders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    availableAmount: double.parse(json["availableAmount"].toString()),
    garageId: json["garageId"],
    totalOrders: json["totalOrders"],
  );

  Map<String, dynamic> toJson() => {
    "availableAmount": availableAmount,
    "garageId": garageId,
    "totalOrders": totalOrders,
  };
}
