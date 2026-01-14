import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettlementProvider extends ChangeNotifier {
  bool isLoading = false;

  double availableAmount = 0;
  int totalOrders = 0;

  List<WithdrawalRequest> withdrawalHistory = [];

  Future<void> fetchAvailableBalance(int garageId) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      "https://api.carcheks.com/carchecks/api/garage/$garageId/withdrawal/balance",
    );
    log('=======>>> fetchAvailableBalance url = $url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'];

      availableAmount = (data['availableAmount'] ?? 0).toDouble();
      totalOrders = data['totalOrders'] ?? 0;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> requestSettlement(int garageId) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      "https://api.carcheks.com/carchecks/api/garage/$garageId/withdrawal/request",
    );
    log('=======>>> requestSettlement url = $url');

    await http.post(url);

    // refresh everything
    await fetchAvailableBalance(garageId);
    await fetchWithdrawalHistory(garageId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWithdrawalHistory(int garageId) async {
    final url = Uri.parse(
      "https://api.carcheks.com/carchecks/api/garage/$garageId/withdrawal/requests",
    );
    log('=======>>> fetchWithdrawalHistory url = $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      withdrawalHistory = (body['data'] as List)
          .map((e) => WithdrawalRequest.fromJson(e))
          .toList();
      notifyListeners();
    }
  }
}

class WithdrawalRequest {
  final int id;
  final double requestedAmount;
  final double adminCommission;
  final double garageAmount;
  final int totalOrders;
  final String status;
  final int requestedAt;

  WithdrawalRequest({
    required this.id,
    required this.requestedAmount,
    required this.adminCommission,
    required this.garageAmount,
    required this.totalOrders,
    required this.status,
    required this.requestedAt,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['id'],
      requestedAmount: (json['requestedAmount']).toDouble(),
      adminCommission: (json['adminCommission']).toDouble(),
      garageAmount: (json['garageAmount']).toDouble(),
      totalOrders: json['totalOrders'],
      status: json['status'],
      requestedAt: json['requestedAt'],
    );
  }
}
