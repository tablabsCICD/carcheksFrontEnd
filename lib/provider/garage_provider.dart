import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/bid_model.dart';
import 'package:carcheks/model/dashbord_model.dart';
import 'package:carcheks/model/fuel_model.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/garage_report_response.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/util/Snackbar.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/request_get_garage.dart';

import '../model/services_garage.dart';
import '../model/viewServicesGarageModel.dart';
import '../util/api_constants.dart';


class GarageProvider extends ChangeNotifier {
  List<Garage> allGarageList = [];
  List<Garage> dashboardGarageList = [];
  List<Garage> garageListNearByUser = [];
  List<Garage> ownGarageList = [];

  List<Garage> isPopularGarageList = [];
  List<Garage> isNotPopularGarageList = [];
  List<String> imageList = [];
  Garage? garage;
  List<GarageService> allGarageServiceList = [];
  List<GarageService> allGarageServiceListByGarageId = [];
  List<ViewGarageServices> viewallGarageServiceList = [];
  List<GarageService> listSubServicesGarage = [];
  ServiceProvider serviceProvider = locator<ServiceProvider>();
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  bool isLoading = false;
  AuthProvider authProvider = locator<AuthProvider>();


  getAllGarage({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    String myUrl =
        ApiConstants.BASE_URL + "/api/garrage/getAll";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = GarageModel.fromJson(response);
      allGarageList.clear();
      isPopularGarageList.clear();
      isNotPopularGarageList.clear();
      allGarageList.addAll(type.data as Iterable<Garage>);
      allGarageList.forEach((element) {
        if (element.populer == true) {
          isPopularGarageList.add(element);
        }
        else {
          isNotPopularGarageList.add(element);
        }
      });
      notifyListeners();
    }
  }

  getAllFilter(int vehicleId, List<int> selctedSubServices) async {
    isLoading = true;
    RequestGetGarage getGarage = RequestGetGarage(
        vehicleTypeId: vehicleId, subserviceId: selctedSubServices);
    notifyListeners();
    String myUrl =
        ApiConstants.BASE_URL +
            "/garrage_services/getAllGarrages/byVehicleTypeAndSubServices";
    print(myUrl);

    var bodys = jsonEncode(getGarage.toJson());
    print(bodys);
    var req = await http.post(Uri.parse(myUrl), body: bodys, headers: {
      'Content-Type': 'Application/json'
    });
    isLoading = false;
    print('the status code ${req.statusCode}');
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = GarageModel.fromJson(response);
      allGarageList.clear();
      isPopularGarageList.clear();
      isNotPopularGarageList.clear();
      allGarageList.addAll(type.data as Iterable<Garage>);
      allGarageList.forEach((element) {
        if (element.populer == true) {
          isPopularGarageList.add(element);
        }
        else {
          isNotPopularGarageList.add(element);
        }
      });
      notifyListeners();
    }
  }

  getAllGarageNearByUser({int currentPage = 0, String? cityName}) async {
    isLoading = true;
    notifyListeners();
    allGarageList.clear();
    if (currentPage == 0) {
      garageListNearByUser.clear();
      isPopularGarageList.clear();
    }
    String myUrl = ApiConstants.BASE_URL +
        "/api/getnearbyGarages?latitude=${AppConstants
            .CurrentLatitude}&longitude=${AppConstants.CurrentLongtitude}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      if (response['data'] == null || response['data'] == "") {
        allGarageList.clear();
        garageListNearByUser.clear();
      } else {
        var type = GarageModel.fromJson(response);
        allGarageList.addAll(type.data as Iterable<Garage>);
        garageListNearByUser.addAll(type.data as Iterable<Garage>);
        garageListNearByUser.forEach((element) {
          if (element.populer == true) {
            isPopularGarageList.add(element);
          }
          else {
            isNotPopularGarageList.add(element);
          }
        });
      }
      notifyListeners();
    }
  }

  getAllGarageNearByVehicleType({int currentPage = 0, int? vehicleType}) async {
    isLoading = true;
    notifyListeners();
    allGarageList.clear();
    if (currentPage == 0) {
      garageListNearByUser.clear();
    }
    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/getbyvechicletypeid?id=${vehicleType}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = GarageModel.fromJson(response);
      allGarageList.addAll(type.data as Iterable<Garage>);
      garageListNearByUser.forEach((element) {
        if (element.populer == true) {
          isPopularGarageList.add(element);
        }
        else {
          isNotPopularGarageList.add(element);
        }
      });
      notifyListeners();
    }
  }

  getGarageByUserId(int userId) async {
    isLoading = true;
    notifyListeners();

    String myUrl =
        ApiConstants.BASE_URL + "/api/Garrages/getByuserId?id=${userId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = GarageModel.fromJson(response);
      ownGarageList.clear();
      ownGarageList.addAll(type.data as Iterable<Garage>);
      notifyListeners();
      return type.data;
    }
  }

  getGarageByGarageId(int userId) async {
    isLoading = true;
    notifyListeners();

    String myUrl =
        ApiConstants.BASE_URL + "/api/grage/getById?id=${userId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = Garage.fromJson(response);
      Garage garage = type;
      notifyListeners();
      return garage;
    }
  }


  getAllGarageServices({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      allGarageServiceList.clear();
    }
    String myUrl =
        ApiConstants.BASE_URL + "/garrage_services/GarageServices/getAll";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = GarageServiceModel.fromJson(response);
      allGarageServiceList.addAll(type.data);
      notifyListeners();
    }
  }

  getAllGarageServicesByGarageId({int currentPage = 0, int? garageId }) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      allGarageServiceListByGarageId.clear();
    }
    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/GarageServices/getAllGSByGarageId?id=${garageId}";
    //  "/garrage_services/GarageServices/getbygarageid?id=${garageId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = GarageServiceModel.fromJson(response);
      allGarageServiceListByGarageId.addAll(type.data);
      notifyListeners();
    }
  }

  getAllGarageServicesByGarageIdServiceId(
      {int currentPage = 0, int? garageId, required int mainserviceId}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      viewallGarageServiceList.clear();
    }
    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/garageservices/getSubServices?garageId=${garageId}&serviceId=${mainserviceId}";
    //  "/garrage_services/GarageServices/getbygarageid?id=${garageId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = viewServicesGarageModel.fromJson(response);
      viewallGarageServiceList.addAll(
          type.data as Iterable<ViewGarageServices>);
      //print("Size is:${viewallGarageServiceList[in].services?.photosUrl.toString()}");
      notifyListeners();
    }
  }

  getAllGarageSubServicesGarage(
      {int currentPage = 0, int? garageId, required int mainserviceId}) async {
    isLoading = true;
    notifyListeners();

    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/garageservices/getByGarrageIdandserviceid?garrageId=${garageId}&ServiceId=${mainserviceId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    listSubServicesGarage.clear();
    debugPrint(req.statusCode.toString());
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      debugPrint(req.body);
      GarageServiceModel type = GarageServiceModel.fromJson(response);
      listSubServicesGarage.addAll(type.data);
    }
    notifyListeners();
  }

  addGarage({
    bool? isActive,
    String? created,
    String? created_by,
    String? closingTime,
    String? openingTime,
    String? lat,
    String? long,
    String? image_url,
    String? photo,
    String? emailId,
    int? mobile,
    int? addressId,
    int? userId,
    bool? isPopular,
    String? updated,
    String? updated_by,
    String? name,
    String? password,
    String? website,
    String? verificationId,
    bool? isVerified,
    int? rating,
    String? description,
    int? noOfratings,
  }) async {
    String myUrl = ApiConstants.SAVE_GARAGE;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "active": true,
      "addressId": addressId,
      "closingTime": closingTime,
      "contactNumber": mobile,
      "created": created,
      "createdBy": created_by,
      "discription": description,
      "emailId": emailId,
      "imageUrl": image_url,
      "latitude": lat,
      "location": 0,
      "longitude": long,
      "name": name,
      "noOfRating": noOfratings,
      "openingTime": openingTime,
      "password": password,
      "photos": photo,
      "populer": isPopular,
      "rating": rating,
      "updated": updated,
      "updatedBy": updated_by,
      "userId": userId,
      "verificatiionId": verificationId,
      "verified": isVerified,
      "websiteUrl": website,
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());
    var response = await json.decode(createResponse.body);
    var list = GarageModel.fromJson(response);
    allGarageList.addAll(list.data as Iterable<Garage>);
    notifyListeners();
  }

  addGarageService({bool? active,
    String? created,
    String? created_by,
    String? cost,
    String? image_url,
    String? description,
    List<int>? subServiceId,
    int? garageId,
    int? serviceId,
    int? userId,
    int? addressId,
    String? updated,
    String? updated_by,
    String? short_desc,
    Vehicletype? vehicletype}) async {
    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/GarageServices/save";
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
      "active": active,
      "cost": cost,
      "created": created,
      "createdBy": created_by,
      "discribtion": description,
      "fuelTypeId": 1,
      "garageId": garageId,
      "photos_url": image_url,
      "serviceId": serviceId,
      "short_discribtion": description,
      "subServiceId": subServiceId,
      "updated": updated,
      "updatedBy": updated_by,
      "usertableId": userId,
      "vehicleTypeId": vehicletype == null ? 1 : vehicletype.id
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}");
    var response = await json.decode(createResponse.body);
    /*var list = GarageService.fromJson(response);
    allGarageServiceList.add(list);*/
    if (response['data'] == null) {
      debugPrint(response['message']);
    }
    print(response);
    return response;
  }

  updateGarageService(
      {bool? active, String? created, String? created_by, String? cost, String? image_url, String? description,
        List<
            int>? subServiceId, int? garageId, int? serviceId, int? userId, String? updated, String? updated_by, String? short_desc,
        Vehicletype? vehicletype, int? id}) async {
    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/GarageServices/update";
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {

      "active": true,
      "cost": cost,
      "created": created,
      "createdBy": created_by,
      "description": description,
      "fuelTypeId": 1,
      "garageId": garageId,
      "id": id,
      "photos_url": image_url,
      "serviceId": serviceId,
      "short_discribtion": short_desc,
      "subServiceId": subServiceId,
      "updated": updated,
      "updatedBy": updated_by,
      "usertableId": userId,
      "vehicleTypeId": vehicletype!.id
      /* "active": active,
      "cost": cost,
      "created": created,
      "createdBy": created_by,
      "discribtion": description,
      "fuelTypeId": 1,
      "id":id,
      "garageId": garageId,
      "photos_url": image_url,
      "serviceId": serviceId,
      "short_discribtion": description,
      "subServiceId": subServiceId,
      "updated": updated,
      "updatedBy": updated_by,
      "usertableId": userId,
      "vehicleTypeId": vehicletype==null?1:vehicletype.id*/

    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.put(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}");
    var response = await json.decode(createResponse.body);
    /*var list = GarageService.fromJson(response);
    allGarageServiceList.add(list);*/
    print(response);
    getAllGarageServicesByGarageId(garageId: garageId);
    notifyListeners();
  }


  deleteGarageService(GarageService gs,) async {
    String myUrl = ApiConstants.BASE_URL +
        '/garrage_services/GarageServices/deleteById?id=${gs.id}';
    var req = await http.delete(Uri.parse(myUrl));
    var deleteResponse = json.decode(req.body);
    allGarageServiceList.remove(gs);
    notifyListeners();
  }

  deleteViewGarageService(ViewGarageServices gs, int gid, int ssid,) async {
    String myUrl = ApiConstants.BASE_URL +
        '/garrage_services/delete/subservice?garageId=${gid}&subServiceId=${ssid}';
    print("Delete Url : ${myUrl}");
    var req = await http.delete(Uri.parse(myUrl));
    var deleteResponse = json.decode(req.body);
    print(deleteResponse);
    viewallGarageServiceList.remove(gs);
    notifyListeners();
  }

  deleteGarageSubService(int id, int index) async {
    String myUrl = ApiConstants.BASE_URL +
        '/garrage_services/GarageServices/deleteById?id=${id}';
    print("Delete Url : ${myUrl}");
    var req = await http.delete(Uri.parse(myUrl));
    var deleteResponse = json.decode(req.body);
    print(deleteResponse);
    listSubServicesGarage.removeAt(index);
    notifyListeners();
  }

  updateGarageinfo({
    bool? active, int? addressId, String? closingTime, String? contactNumber, String? created, String? createdBy,
    String? discription, String? emailId, int? id, String? imageUrl, String? latitude, int? location, String? longitude, String? name, int? noOfRating,
    String? openingTime, String? password, String? photos1, String? photos2, String? photos3, bool? populer, String? rating, String? updated,
    String? updatedBy, int? usertableId, String? verificatiionId, bool? verified,
    String? websiteUrl,}) async {
    String myUrl = ApiConstants.UPDATE_GARAGE;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "active": active ?? ownGarageList[0]!.active,
      "addressId": addressId ?? ownGarageList[0]!.addressId,
      "closingTime": closingTime ?? ownGarageList[0]!.closingTime,
      "contactNumber": contactNumber ?? ownGarageList[0]!.contactNumber,
      "created": created ?? ownGarageList[0]!.created,
      "createdBy": createdBy ?? ownGarageList[0]!.createdBy,
      "discription": discription ?? ownGarageList[0]!.discription,
      "emailId": emailId ?? ownGarageList[0]!.emailId,
      "id": id ?? ownGarageList[0]!.id,
      "imageUrl": imageUrl ?? ownGarageList[0]!.imageUrl,
      "latitude": latitude ?? ownGarageList[0]!.latitude,
      // "location": location ?? ownGarageList[0]!.location,
      "longitude": longitude ?? ownGarageList[0]!.longitude,
      "name": name ?? ownGarageList[0]!.name,
      "noOfRating": noOfRating ?? ownGarageList[0]!.noOfRating,
      "openingTime": openingTime ?? ownGarageList[0]!.openingTime,
      "password": password ?? ownGarageList[0]!.password,
      "photos1": photos1 ?? ownGarageList[0]!.photos1,
      "photos2": photos2 ?? ownGarageList[0]!.photos2,
      "photos3": photos3 ?? ownGarageList[0]!.photos3,
      "populer": populer ?? ownGarageList[0]!.populer,
      "rating": rating ?? ownGarageList[0]!.rating,
      "updated": updated ?? ownGarageList[0]!.updated,
      "updatedBy": updatedBy ?? ownGarageList[0]!.updatedBy,
      "usertableId": usertableId ?? ownGarageList[0]!.userId,
      "verificatiionId": verificatiionId ?? ownGarageList[0]!.verificatiionId,
      "verified": verified ?? ownGarageList[0]!.verified,
      "websiteUrl": websiteUrl ?? ownGarageList[0]!.websiteUrl,

    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.put(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());
    print(createResponse.body);
    var response = await json.decode(createResponse.body);
    var list = Garage.fromJson(response);
    ownGarageList.add(list);

    notifyListeners();
  }

  String? TotalAmt;
  List<PaypalOrder> paypalOrderListByGarage = [];
  String selectedFromDate = '';
  String selectedToDate = '';

  getGarageReport(int garageId, String fromDate, String toDate) async {
    isLoading = true;
    notifyListeners();

    String myUrl =
        ApiConstants.BASE_URL +
            "/api/garageReport/getDetailedGarageReportByEmployeeId?startDate=${fromDate}&endDate=${toDate}&garageId=${garageId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      print(response);
      GarageReportResponse garageReportResponse = GarageReportResponse.fromJson(
          response);
      paypalOrderListByGarage.clear();
      TotalAmt = null;
      TotalAmt = garageReportResponse.data!.totalAmount.toString();
      paypalOrderListByGarage.addAll(
          garageReportResponse.data!.paypalOrder as Iterable<PaypalOrder>);
      notifyListeners();
    } else {
      notifyListeners();
    }
  }


}