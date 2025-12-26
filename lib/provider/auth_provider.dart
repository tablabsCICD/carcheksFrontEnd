
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carcheks/model/user_table_model.dart';
import 'package:carcheks/response/auth/loginResponse.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/sharepreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../util/api_constants.dart';
import 'package:http_parser/http_parser.dart';

class AuthProvider extends ChangeNotifier {
  UserDetails? userDetails;
  User? user;
  var response;
  bool isLoading = false;
  String dropdownValue = 'English';

  Future<Map<String, dynamic>> loginUsingMobileNumber(
    String mobileNumber,
    String password,
  ) async {
    String myUrl =
        '${ApiConstants.LOGIN}mobileNumber?mobilenumber=$mobileNumber&password=$password';
    isLoading = true;
    print(myUrl);
    var req = await http.post(Uri.parse(myUrl));
    print(req);
    isLoading = false;
    response = json.decode(req.body);
    if (response['success']) {
      LoginResponseResponse res = LoginResponseResponse.fromJson(response);
      setUserData(res.data!);
      user = null;
      user = res.data;
    }
    return response;
  }

  Future<User?> getUserDetails() async {
    LocalSharePreferences preferences = LocalSharePreferences();
    User userData = await preferences.getLoginData();
    String myUrl = ApiConstants.getUserById(userData.id);
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));

    if (req.statusCode == 200) {
      response = json.decode(req.body);
      LoginResponseResponse loginResponseResponse = LoginResponseResponse.fromJson(response);
      user = loginResponseResponse.data;
      return user;
    }else{
    user = userData;
    return user;
    }
  }

  setVisitingFlag(bool flag) async {
    if (flag == false) {
      user = null;
      notifyListeners();
    }
    LocalSharePreferences preferences = LocalSharePreferences();
    await preferences.setBool(AppConstants.isUserLoggedIn, flag);
    notifyListeners();
  }

  setGarageOwnerVisitingFlag(bool flag) async {
    if (flag == false) {
      user = null;
      notifyListeners();
    }
    LocalSharePreferences preferences = LocalSharePreferences();
    await preferences.setBool(AppConstants.isUserLoggedIn, flag);
    notifyListeners();
  }

  setUserId(int id) async {
    LocalSharePreferences preferences = LocalSharePreferences();
    await preferences.setInt(AppConstants.currentUserId, id);
  }

  Future<int?> getUserId() async {
    LocalSharePreferences preferences = LocalSharePreferences();
    int? id = await preferences.getInt(AppConstants.currentUserId);
    return id;
  }

  void setUserData(User data) async {
    LocalSharePreferences preferences = LocalSharePreferences();
    String userJson = jsonEncode(data.toJson());
    print(userJson);
    await preferences.setString(AppConstants.currentUser, userJson);
  }


  String? uploadedProfileImg;
  String? uploadedGarageImg;
  File? localProfileImg;
  File? localGarageImg;

  final ImagePicker _picker = ImagePicker();
  Future<String?> pickAndUploadImage(
      BuildContext context,
      bool isProfile,
      ) async {
    try {
      if (!context.mounted) return null;

      final ImageSource? source = await _showImageSourceDialog(context);
      if (source == null) return null;

      // 🔒 Wrap picker with platform safety
      final XFile? pickedFile;
      try {
        pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
      } on PlatformException catch (e) {
        debugPrint("ImagePicker PlatformException: $e");
        return null;
      }

      // ✅ User cancelled OR MIUI killed activity
      if (pickedFile == null) {
        debugPrint("Image picking cancelled");
        return null;
      }

      final File imageFile = File(pickedFile.path);

      // ✅ Local preview update (safe)
      if (isProfile) {
        localProfileImg = imageFile;
      } else {
        localGarageImg = imageFile;
      }
      notifyListeners();

      // 🚀 Upload image
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.UPLOAD_IMG),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePicture',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        debugPrint("Upload failed: ${streamedResponse.reasonPhrase}");
        return null;
      }

      final responseBody = await streamedResponse.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (jsonResponse == null || jsonResponse.toString().isEmpty) {
        debugPrint("Invalid upload response");
        return null;
      }

      final String imageUrl = jsonResponse.toString();

      if (isProfile) {
        uploadedProfileImg = imageUrl;
      } else {
        uploadedGarageImg = imageUrl;
      }

      notifyListeners();
      return imageUrl;
    } catch (e, st) {
      debugPrint("pickAndUploadImage fatal error: $e");
      debugPrint(st.toString());

      // ❌ NEVER crash app
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to pick image. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  /// Helper function to show bottom dialog for image source selection
  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  saveUser({
    bool? active,
    String? created,
    String? created_by,
    String? updated,
    String? updated_by,
    String? device_id,
    String? operating_system,
    String? first_name,
    String? last_name,
    String? emailid,
    String? mobilenumber,
    String? password,
    String? image_url,
    bool? garrage_Owner,
    bool? payment_mode,
    bool? verified,

    String? garageName,
    String? garageInfo,
    String? garageImg,
    String? garageEmailId,
    int? garageMobile,
    String? openingTime,
    String? closingTime,
    String? lat,
    String? long,
    String? garageStreet,
    String? garageLandmark,
    String? garageCity,
    String? garageState,
    String? garageCountry,
    String? garageZipcode,
    bool? isPopular,
    String? garagePassword,
    String? website,
    String? verificationId,
    bool? isVerified,
    int? rating,
    String? description,
    int? noOfratings,

    String? city,
    String? addressName,
    String? state,
    String? country,
    String? street,
    String? landmark,
    String? zipcode,
    bool? garrageAddress,
  }) async {
    isLoading = true;
    String myUrl = ApiConstants.REGISTRATION;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "addressData": {
        "active": true,
        "country": country,
        "cityname": city,
        "created": created,
        "createdBy": created_by,
        "garrageAddress": garrageAddress,
        "landmark": landmark,
        "latitude": lat,
        "longitude": long,
        "state": state,
        "houseName": addressName,
        "street": street,
        "updated": updated,
        "updatedBy": updated_by,
        "userId": 0,
        "zipCode": zipcode,
      },
      "garrageData": garrage_Owner == true
          ? {
              "active": true,
              "addressId": 0,
              "closingTime": closingTime,
              "contactNumber": garageMobile,
              "created": created,
              "createdBy": created_by,
              "discription": garageInfo,
              "emailId": garageEmailId,
              "imageUrl": garageImg,
              "latitude": lat,
              "longitude": long,
              "name": garageName,
              "noOfRating": noOfratings,
              "openingTime": openingTime,
              "password": "string",
              "photos1": garageImg,
              "photos2": garageImg,
              "photos3": garageImg,
              "populer": isPopular,
              "rating": rating,
              "updated": updated,
              "updatedBy": updated_by,
              "usertableId": 0,
              "verificatiionId": verificationId,
              "verified": verified,
              "websiteUrl": website,
            }
          : null,
      "userData": {
        "active": true,
        "created": created,
        "createdBy": created_by,
        "device_id": '',
        "emailid": emailid,
        "firstName": first_name,
        "garrage_Owner": garrage_Owner,
        "image_url": image_url,
        "lastName": last_name,
        "mobilenumber": mobilenumber,
        "operating_system": "",
        "otp": "",
        "password": password,
        "payment_mode": payment_mode,
        "updated": updated,
        "updatedBy": updated_by,
        "verified": verified,
      },
    };
    var body = json.encode(data);
    var createResponse = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    isLoading = false;
    Map<String, dynamic> response = jsonDecode(createResponse.body);
    if (response['success'] == true) {
      var res = UserResponse.fromJson(response);
      userDetails = res.data;
      user = userDetails!.userData;
    }
    return response;
  }

  updateUser({
    bool? active,
    String? created,
    String? created_by,
    String? device_id,
    String? emailid,
    String? first_name,
    String? last_name,
    bool? garrage_Owner,
    String? image_url,
    String? mobilenumber,
    String? operating_system,
    int? id,
    bool? payment_mode,
    bool? verified,
    String? updated,
    String? updated_by,
  }) async {
    isLoading = true;
    String myUrl = ApiConstants.UPDATE_USER_PROFILE;
    log('Update URL========= $myUrl');
    log('Profile URL========= ${user!.imageUrl}');
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "active": active ?? user!.active,
      "created": created ?? user!.created,
      "createdBy": created_by ?? user!.createdBy,
      "device_id": device_id ?? user!.deviceId,
      "emailid": emailid ?? user!.emailid,
      "firstName": first_name ?? user!.firstName,
      "garrage_Owner": garrage_Owner ?? user!.garrageOwner,
      "id": user!.id,
      "image_url": image_url ?? user!.imageUrl,
      "lastName": last_name ?? user!.lastName,
      "mobilenumber": mobilenumber ?? user!.mobilenumber,
      "operating_system": operating_system ?? user!.operatingSystem,
      "payment_mode": payment_mode ?? user!.paymentMode,
      "password": user!.password,
      "updated": updated ?? user!.updatedBy,
      "updatedBy": updated_by ?? user!.updatedBy,
      "verified": verified ?? user!.verified,
    };
    var body = json.encode(data);
    var createResponse = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    log("${createResponse.statusCode} --- ${createResponse.body}");
    print(
      "${createResponse.statusCode}" + " --- " + createResponse.body.toString(),
    );
    print(createResponse.body);
    isLoading = false;
    if (createResponse.statusCode == 200) {
      var response = await json.decode(createResponse.body);

      // var res = UserResponse.fromJson(response);
      LoginResponseResponse res = LoginResponseResponse.fromJson(response);
      /* userDetails=null;
     userDetails = res.data;
     user = userDetails!.userData;*/
      user = res.data;
    }
    notifyListeners();
  }

  Future<bool> deleteAccount(User user, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      String myUrl = ApiConstants.DELETE_USER(user.id);
      log("DELETE URL → $myUrl");

      final res = await http.put(Uri.parse(myUrl));

      log("API RESPONSE → ${res.body}");

      final jsonRes = json.decode(res.body);

      if (jsonRes["success"] == true) {
        /// Clear everything
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        this.user = null;
        userDetails = null;

        notifyListeners();

        toast("User deleted successfully");

        return true;
      }

      return false;
    } catch (e, st) {
      log("DELETE ERROR → $e\n$st");
      toast("Something went wrong. Try again.");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> restoreSession() async {
    try {
      LocalSharePreferences preferences = LocalSharePreferences();
      final userJson = await preferences.getString(AppConstants.currentUser);

      if (userJson != null && userJson.isNotEmpty) {
        final Map<String, dynamic> jsonMap = jsonDecode(userJson);
        user = User.fromJson(jsonMap);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Restore session failed: $e");
    }
  }

}
