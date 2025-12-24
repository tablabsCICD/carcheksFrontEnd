import 'dart:async';
import 'dart:convert';

import 'package:carcheks/util/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as ApiHelper;
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

import '../model/garage_balance_model.dart';
import '../model/withdrawal_history_model.dart';

class WithdrawalProvider extends ChangeNotifier {
  double? balance;
  int? totalOrders;
  List<WithdrawalData> withdrawals = [];

  bool isLoading = false;
  bool isSubmitting = false;

  /// GET Balance
  Future<void> fetchBalance(int garageId) async {
    isLoading = true;
    notifyListeners();

    String myUrl = ApiConstants.getBalance(1);
    var req = await http.get(Uri.parse(myUrl));

    if (req.statusCode == 200) {
      BalanceResponse balanceResponse = BalanceResponse.fromJson(
        jsonDecode(req.body),
      );
      if (balanceResponse.success == true) {
        balance = balanceResponse.data!.availableAmount ?? 0.0;
        totalOrders = balanceResponse.data!.totalOrders ?? 0;
      } else {}
    }

    isLoading = false;
    notifyListeners();
  }

  /// GET Withdrawal History
  Future<void> fetchWithdrawals(int garageId) async {
    String myUrl = ApiConstants.getWithdrawHistory(1);
    var req = await http.get(Uri.parse(myUrl));

    if (req.statusCode == 200) {
      WithdrawalHistoryResponse withdrawalHistoryResponse =
          WithdrawalHistoryResponse.fromJson(jsonDecode(req.body));
      if (withdrawalHistoryResponse.success == true) {
        withdrawals = withdrawalHistoryResponse.data!;
      } else {}
    }
    isLoading = false;
    notifyListeners();
  }

  /// POST Withdrawal Request
  Future<bool?> raiseWithdrawal(int garageId, double amount) async {
    isSubmitting = true;
    notifyListeners();

    String myUrl = ApiConstants.sendWithdrawRequest(garageId);
    var req = await http.post(Uri.parse(myUrl));

    isSubmitting = false;
    if (req.statusCode == 200) {
      WithdrawalHistoryResponse withdrawalHistoryResponse =
          WithdrawalHistoryResponse.fromJson(jsonDecode(req.body));
      if (withdrawalHistoryResponse.success == true) {
        withdrawals = withdrawalHistoryResponse.data!;
        await fetchBalance(garageId);
        await fetchWithdrawals(garageId);
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    }
  }
}
