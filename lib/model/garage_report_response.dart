class GarageReportResponse {
  String? message;
  GarageReport? data;
  bool? success;

  GarageReportResponse({this.message, this.data, this.success});

  GarageReportResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new GarageReport.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class GarageReport {
  double? totalAmount;
  List<PaypalOrder>? paypalOrder;

  GarageReport({this.totalAmount, this.paypalOrder});

  GarageReport.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    if (json['paypalOrder'] != null) {
      paypalOrder = <PaypalOrder>[];
      json['paypalOrder'].forEach((v) {
        paypalOrder!.add(new PaypalOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    if (this.paypalOrder != null) {
      data['paypalOrder'] = this.paypalOrder!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaypalOrder {
  int? id;
  String? orderId;
  String? status;
  double? price;
  String? description;
  String? currency;
  String? method;
  String? intent;
  int? createdTimestamp;
  String? response;
  String? transactionId;
  int? garageId;
  int? date;

  PaypalOrder(
      {this.id,
        this.orderId,
        this.status,
        this.price,
        this.description,
        this.currency,
        this.method,
        this.intent,
        this.createdTimestamp,
        this.response,
        this.transactionId,
        this.garageId,
        this.date});

  PaypalOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    status = json['status'];
    price = json['price'];
    description = json['description'];
    currency = json['currency'];
    method = json['method'];
    intent = json['intent'];
    createdTimestamp = json['createdTimestamp'];
    response = json['response'];
    transactionId = json['transactionId'];
    garageId = json['garageId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['status'] = this.status;
    data['price'] = this.price;
    data['description'] = this.description;
    data['currency'] = this.currency;
    data['method'] = this.method;
    data['intent'] = this.intent;
    data['createdTimestamp'] = this.createdTimestamp;
    data['response'] = this.response;
    data['transactionId'] = this.transactionId;
    data['garageId'] = this.garageId;
    data['date'] = this.date;
    return data;
  }
}
