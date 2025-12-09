class OrderModel {
  String? message;
  Order? data;
  bool? success;

  OrderModel({this.message, this.data, this.success});

  OrderModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Order.fromJson(json['data']) : null;
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

class Order {
  String? orderId;
  OrderTableObject? orderTableObject;

  Order({this.orderId, this.orderTableObject});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderTableObject = json['orderTableObject'] != null
        ? new OrderTableObject.fromJson(json['orderTableObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.orderTableObject != null) {
      data['orderTableObject'] = this.orderTableObject!.toJson();
    }
    return data;
  }
}

class OrderTableObject {
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

  OrderTableObject(
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

  OrderTableObject.fromJson(Map<String, dynamic> json) {
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
