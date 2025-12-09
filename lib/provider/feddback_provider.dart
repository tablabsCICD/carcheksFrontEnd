import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/model/feedback_model.dart';
import 'package:carcheks/model/save_feedback.dart';
import 'package:carcheks/util/api_constants.dart';

class FeedbackProvider extends ChangeNotifier {
  List<FeedbackObject> feedbackList = [];
  bool isLoading = false;

  final authProvider = locator<AuthProvider>();

  // ----------------------- GET FEEDBACK LIST -----------------------
  Future<dynamic> getFeedbackByUserId() async {
    try {
      isLoading = true;
      notifyListeners();

      feedbackList.clear();

      final userId = authProvider.user?.id ?? 0;
      final url = ApiConstants.getFeedback(userId);

      print("Fetching feedback: $url");

      final response = await http.get(Uri.parse(url));
      print("Fetching feedback: ${response.body}");
      isLoading = false;

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final model = FeedbackModel.fromJson(jsonData);
        print("Fetching feedback: ${response.body}");
        feedbackList = model.data ?? [];
        notifyListeners();

        return model;
      } else {
        print("❌ Error: ${response.statusCode}  — ${response.body}");
        notifyListeners();
        return null;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("⚠ Exception (getReviewByGarageId): $e");
      return null;
    }
  }

  // ----------------------- SAVE FEEDBACK -----------------------
  Future<dynamic> saveFeedback({
    required String title,
    required String message,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final url = ApiConstants.saveFeedback;

      print("➡ Saving feedback: $url");

      final Map<String, dynamic> data = {
        "id": 0,
        "message": message,
        "subject": title,
        "userId": authProvider.user?.id ?? 0,
      };

      print("📤 Sending: $data");

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      isLoading = false;

      print("📥 Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final raw = jsonDecode(response.body);
        final result = SaveFeedbackModel.fromJson(raw);

        print("✔ Feedback Saved: ${result.message}");

        notifyListeners();
        return result;
      } else {
        print("❌ Error Saving: ${response.statusCode}");
        notifyListeners();
        return null;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("⚠ Exception (saveFeedback): $e");
      return null;
    }
  }
}
