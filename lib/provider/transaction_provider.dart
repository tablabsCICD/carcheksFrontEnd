import 'dart:convert';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/transaction_model.dart';
import 'package:carcheks/util/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;




class TransactionProvider extends ChangeNotifier{
  List<TransactionPayment> allTransactionList = [];
  bool isLoading = false;

  getAllTransactions({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if(currentPage == 0){
      allTransactionList.clear();
    }
    String myUrl = ApiConstants.GET_All_Transactions;
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = TransactionPayment.fromJson(response);
      allTransactionList.add(type);
      notifyListeners();
    }
  }


  saveTransactions({int ?id,String? created, String ?createdBy, String ?updated,String ?updatedBy,bool ?active,
    Null ?userOrder,String? transcationStatus,String ?transcationDiscrption})async {
    String myUrl = ApiConstants.SAVE_Transaction;
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
      "created": created,
      "createdBy":createdBy,
      "active": active,
      "updated": updated,
      "updatedby": updatedBy,
      "transcationStatus": transcationStatus,
      "transcationDiscrption": transcationDiscrption,
      "userOrder":userOrder
    };
    var body = json.encode(data);

    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());
    var response = await json.decode(createResponse.body);
    var list =TransactionPayment.fromJson(response);
    allTransactionList.add(list);
    notifyListeners();
  }


}