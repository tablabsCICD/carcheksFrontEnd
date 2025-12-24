class WithdrawalHistoryResponse {
  String? message;
  List<WithdrawalData>? data;
  bool? success;

  WithdrawalHistoryResponse({
    this.message,
    this.data,
    this.success,
  });

  factory WithdrawalHistoryResponse.fromJson(Map<String, dynamic> json) => WithdrawalHistoryResponse(
    message: json["message"],
    data: json["data"] == null ? [] : List<WithdrawalData>.from(json["data"]!.map((x) => WithdrawalData.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };
}

class WithdrawalData {
  int? id;
  int? garageId;
  double? requestedAmount;
  double? adminCommission;
  double? garageAmount;
  int? totalOrders;
  String? status;
  int? requestedAt;
  int? approvedAt;
  int? paidAt;
  dynamic remark;

  WithdrawalData({
    this.id,
    this.garageId,
    this.requestedAmount,
    this.adminCommission,
    this.garageAmount,
    this.totalOrders,
    this.status,
    this.requestedAt,
    this.approvedAt,
    this.paidAt,
    this.remark,
  });

  factory WithdrawalData.fromJson(Map<String, dynamic> json) => WithdrawalData(
    id: json["id"],
    garageId: json["garageId"],
    requestedAmount: json["requestedAmount"]??0.0,
    adminCommission: json["adminCommission"]??0.0,
    garageAmount: json["garageAmount"]??0.0,
    totalOrders: json["totalOrders"]??0,
    status: json["status"],
    requestedAt: json["requestedAt"],
    approvedAt: json["approvedAt"],
    paidAt: json["paidAt"],
    remark: json["remark"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "garageId": garageId,
    "requestedAmount": requestedAmount,
    "adminCommission": adminCommission,
    "garageAmount": garageAmount,
    "totalOrders": totalOrders,
    "status": status,
    "requestedAt": requestedAt,
    "approvedAt": approvedAt,
    "paidAt": paidAt,
    "remark": remark,
  };
}
