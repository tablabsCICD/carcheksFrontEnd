
class PayPalItem {
  PayPalItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.currency,
  });
  late final int quantity;
  late final String name;
  late final String price;
  late final String currency;

/*  FinalServices.fromJson(Map<String, dynamic> json){
    name = json['name']??'';
    quantity = json['quantity']??0;
    price = json['price']??'';
    currency = json['currency']??'\$';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['quantity'] = quantity;
    _data['price'] = price;
    _data['currency'] = currency;
    return _data;
  }*/
}