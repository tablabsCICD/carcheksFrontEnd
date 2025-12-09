import 'dart:convert';
import 'package:carcheks/model/address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class UserProvider extends ChangeNotifier{
  /*List<Address> allAddressList = [];
  bool isLoading = false;

  getAllFuelType({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if(currentPage == 0){
      allAddressList.clear();
    }
    String myUrl = "http://carchek-loadbalancer-425503991.us-east-1.elb.amazonaws.com:8080/carcheck/api/fuelType/getAll";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = AddressModel.fromJson(response);
      allAddressList.addAll(type.data);
      notifyListeners();
    }
  }
*/
}