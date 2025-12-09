import 'dart:convert';
import 'dart:io';
import 'package:carcheks/model/user_table_model.dart';
import 'package:carcheks/response/auth/loginResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../util/api_constants.dart';
import 'package:http_parser/http_parser.dart';

extension extString on String {
  bool get isNotNull{
    return this!=null;
  }
}

class  AuthProvider extends ChangeNotifier {
  UserDetails? userDetails;
  User? user;
  var response;
  bool isLoading = false;
  String dropdownValue = 'English';

  Future<Map<String, dynamic>> loginUsingMobileNumber(String mobileNumber, String password) async {
    String myUrl = ApiConstants.LOGIN + 'mobileNumber?mobilenumber=${mobileNumber}&password=${password}';
    print(myUrl);
    isLoading=true;
    var req = await http.post(Uri.parse(myUrl));
    isLoading=false;
    response = json.decode(req.body);
    print(response);
    if(response['success']){
      var res = LoginResponseResponse.fromJson(response);
      await setUserData(req.body);
      user = null;
      user = res.data;
    }
    return response;
  }

  Future<User?>getUserDetails() async {
        LoginResponseResponse? loginResponseResponse =await getUserData();
    if(loginResponseResponse==null){
      return null;
    }
    user=loginResponseResponse!.data;
    return user;
  }

  setVisitingFlag(bool flag) async {
    if (flag == false) {
      user = null;
      notifyListeners();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("Already Visited", flag);
    notifyListeners();
  }

  setGarageOwnerVisitingFlag(bool flag) async {
    if (flag == false) {
      user = null;
      notifyListeners();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("Garage Owner Already Visited", flag);
    notifyListeners();
  }
  setUserId(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("id", id);
    //preferences.clear();
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  setUserName(String uName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("userName", uName);
  }



  Future<bool?> getVisitingFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? alreadyVisited = await preferences.getBool("Already Visited") ??
        false;
    return alreadyVisited;
  }

  Future<bool?> getGarageOwnerVisitingFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? alreadyVisited = await preferences.getBool("Garage Owner Already Visited") ??
        false;
    return alreadyVisited;
  }

  Future<int?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? id = await preferences.getInt("id")!;
    return id;
  }

  Future<String> setUserData(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isdone=await preferences.setString("jsonData", data);
    print('the done ${isdone}');
    return data;
  }

  Future<LoginResponseResponse?> getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data= await preferences.getString("jsonData");
    if(data==null){
      return null;
    }
    dynamic val=await jsonDecode(data!);
    LoginResponseResponse loginResponseResponse=LoginResponseResponse.fromJson(val);
    print('the id is ${loginResponseResponse.data!.id}');
    return loginResponseResponse;
  }

  String? uploadedProfileImg;
  String? uploadedGarageImg;
  File? localProfileImg;
  File? localGarageImg;

  final ImagePicker _picker = ImagePicker();
  Future<String?> pickAndUploadImage(BuildContext context, bool isProfile) async {
    try {
      ImageSource? source = await _showImageSourceDialog(context);
      if (source == null) return null;

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      File imageFile = File(pickedFile.path);

      // Save locally first for immediate UI update
      if (isProfile) {
        localProfileImg = imageFile;
      } else {
        localGarageImg = imageFile;
      }
      notifyListeners();

      // Upload to backend
      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.UPLOAD_IMG));
      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePicture',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();
      print(response.stream);

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print(responseBody);

        dynamic jsonResponse = json.decode(responseBody);
        print(jsonResponse);

        String imageUrl = jsonResponse?? '';

        if (isProfile) {
          uploadedProfileImg = imageUrl;
        } else {
          uploadedGarageImg = imageUrl;
        }

        notifyListeners();
        return imageUrl;
      } else {
        debugPrint("❌ Upload failed: ${response.reasonPhrase}");
        return null;
      }
    } catch (e, st) {
      debugPrint("❌ Error picking/uploading image: $e\n$st");
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
    isLoading=true;
    String myUrl = ApiConstants.REGISTRATION;
    print(myUrl);
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
        "zipCode": zipcode
      },
      "garrageData": garrage_Owner==true?{
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
        "websiteUrl": website
      }:null,
      "userData": {
        "active": true,
        "created": created,
        "createdBy": created_by,
        "device_id": '',
        "emailid":emailid,
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
        "verified": verified
      }
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" + " --- " +
        createResponse.body.toString());
    isLoading=false;
    Map<String, dynamic> response = jsonDecode(createResponse.body);
   if(response['success']==true){
     var res = UserResponse.fromJson(response);
     userDetails = res.data;
     user = userDetails!.userData;

   }
    return response;
  }

 updateUser(
      {bool? active, String? created, String? created_by, String? device_id, String? emailid, String? first_name,
        String? last_name, bool? garrage_Owner, String? image_url, String? mobilenumber, String? operating_system, int? id, bool? payment_mode, bool? verified,
        String? updated, String? updated_by,
      }) async {
   isLoading=true;
    String myUrl = ApiConstants.UPDATE_USER_PROFILE;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
        "active": active ?? user!.active ,
        "created": created ?? user!.created,
        "createdBy": created_by ?? user!.createdBy,
        "device_id": device_id ?? user!.deviceId,
        "emailid": emailid ?? user!.emailid,
        "firstName": first_name?? user!.firstName,
        "garrage_Owner": garrage_Owner ?? user!.garrageOwner,
        "id": user!.id ,
        "image_url": image_url ?? user!.imageUrl,
        "lastName": last_name?? user!.lastName,
        "mobilenumber": mobilenumber ?? user!.mobilenumber,
        "operating_system": operating_system ?? user!.operatingSystem ,
        "payment_mode": payment_mode ?? user!.paymentMode,
        "password": user!.password,
        "updated": updated ?? user!.updatedBy,
        "updatedBy": updated_by ?? user!.updatedBy ,
        "verified": verified ?? user!.verified
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.put(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" + " --- " +
        createResponse.body.toString());
    print(createResponse.body);
   isLoading=false;
   if(createResponse.statusCode==200){
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

  deleteUser(User user) async {
    isLoading=true;
    String myUrl = ApiConstants.DELETE_USER + 'deleteById?id=${user.id}';
    var req = await http.delete(Uri.parse(myUrl));
    isLoading=false;
    response = json.decode(req.body);
    notifyListeners();
  }
}