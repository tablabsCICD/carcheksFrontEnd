import 'dart:convert';
import 'dart:typed_data';
import 'package:carcheks/util/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../util/api_constants.dart';

class ImgProvider extends ChangeNotifier {
  late String image = '';
  late String uploadedImage = '';

  Future<void> setImage(String img) async {
    image = img;
    notifyListeners();
  }

  Future<String?> uploadImage(
      String? userId, {
        String? imageFilePath,
        Uint8List? imageBytes,
        PlatformFile? objectFile,
      }) async {
    if (objectFile == null) {
      debugPrint("No file selected.");
      return null;
    }

    String uploadUrl = ApiConstants.UPLOAD_IMG;
    debugPrint("Upload URL: $uploadUrl");

    var postUri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest("POST", postUri);

    try {
      Map<String, String> headers = {"Content-Type": "multipart/form-data"};
      request.headers.addAll(headers);

      request.files.add(http.MultipartFile(
        "profilePicture",
        objectFile.readStream!,
        objectFile.size,
        filename: objectFile.name,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint("Response: $responseBody");

        RegExp regExp = RegExp('"([^"]*)"');
        Match? match = regExp.firstMatch(responseBody);

        if (match != null) {
          uploadedImage = match.group(1) ?? '';
          notifyListeners(); // 🔑 update UI
          return uploadedImage;
        } else {
          debugPrint("Error parsing response.");
          return null;
        }
      } else {
        debugPrint("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Exception during upload: $e");
      return null;
    }
  }


  Future<void> updateProfilePicture(
      String userId, {
        String? imageFilePath,
        Uint8List? imageBytes,
        PlatformFile? objectFile,
      }) async {
    if (objectFile == null) {
      debugPrint("No file selected.");
      return;
    }

    String updateUrl = "${ApiConstants.BASE_URL}profilePicture";
    debugPrint("Update URL: $updateUrl");

    var postUri = Uri.parse(updateUrl);
    var request = http.MultipartRequest("PUT", postUri);

    try {
      Map<String, String> headers = {"Content-Type": "multipart/form-data"};
      request.headers.addAll(headers);

      request.files.add(http.MultipartFile(
        "profilePicture",
        objectFile.readStream!,
        objectFile.size,
        filename: objectFile.name,
      ));

      request.fields['userId'] = userId;

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint("Response: $responseBody");

        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        // Handle the parsed JSON response here if necessary
        notifyListeners();
      } else {
        debugPrint("Failed to update profile picture: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception during update: $e");
    }
  }


}
