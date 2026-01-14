import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';

import 'package:carcheks/util/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// import '../model/Appointment.dart';
import '../model/appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  //List<Appointment> allAppointment = [];
  List<AppointmentData> allAppointment = [];
  List<AppointmentData> appointmentByGarageId = [];
  List<AppointmentData> appointmentByGarageIdDummy = [];

  List<AppointmentData> AppointmentBySubServiceID = [];
  List<AppointmentData> AppointmentByUserId = [];
  List<AppointmentData> AppointmentByUserIdDummy = [];
  List<MainService> allServices = [];
  List<SubService> allSubServices = [];
  List<String> subServicesNameList = [];
  bool isLoading = false;

  getAppointmentByGarageId(int? garageId) async {
    isLoading = true;
    notifyListeners();
    String myUrl =
        ApiConstants.Get_Appointment_By_Garage_ID + "?id=${garageId}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));

    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type1 = AppointmentModel.fromJson(response);
      appointmentByGarageId.clear();
      appointmentByGarageIdDummy.clear();

      appointmentByGarageId.addAll(type1.data as Iterable<AppointmentData>);
      appointmentByGarageIdDummy.addAll(appointmentByGarageId);
      isLoading = false;
      notifyListeners();
    }
  }

  getAppointmentByUsertableID(int? UserID) async {
    isLoading = true;
    AppointmentByUserId.clear();
    AppointmentByUserIdDummy.clear();
    notifyListeners();
    String myUrl =
        ApiConstants.Get_Appointment_By_User_ID + "?UserId=${UserID}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type2 = AppointmentModel.fromJson(response);
      AppointmentByUserId.addAll(type2.data as Iterable<AppointmentData>);
      AppointmentByUserIdDummy.addAll(
        (type2.data as Iterable<AppointmentData>),
      );
      notifyListeners();
      return type2;
    }
  }

  getAppointmentBySubServiceID(int? SubServiceID) async {
    isLoading = true;
    notifyListeners();
    String myUrl =
        ApiConstants.BASE_URL +
        "/api/Appointment/getBySubserviceId?id=${SubServiceID}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type3 = AppointmentModel.fromJson(response);
      AppointmentBySubServiceID.clear();
      AppointmentBySubServiceID.addAll(type3.data as Iterable<AppointmentData>);
      notifyListeners();
    }
  }

  final authProvider = locator<AuthProvider>();
  final addressProvider = locator<AddressProvider>();
  SaveAppointment({
    bool? accept,
    bool? active,
    String? availableTime,
    String? date,
    int? orderId,
    int? id,
    String? status,
    String? time,
    String? paypalId,
    int? garageServiceId,
  }) async {
    int? id = await authProvider.getUserId();
    AddressClass? addressClass = await addressProvider.getAddressForUser(id!);
    String myUrl = ApiConstants.BASE_URL + "/api/Appointment/save";
    Uri uri = Uri.parse(myUrl);
    print(myUrl);
    Map<String, dynamic> data = {
      "accept": accept,
      "active": active,
      "availableTime": availableTime,
      "date": date,
      "garageServicesId": garageServiceId,
      "orderId": orderId,
      "paypalId": paypalId,
      "status": status,
      "time": time,
      "userAddress":
          "${addressClass!.landmark}, ${addressClass.cityname}, ${addressClass.state}, ${addressClass.country}, ${addressClass.zipCode}",
      "userOrder": {
        "active": true,
        "created": "string",
        "createdBy": "string",
        "id": orderId,
        "invoiceNumber": "string",
        "isBid": true,
        "status": "string",
        "total_amout": 0,
        "updated": "string",
        "updatedBy": "string",
        "usertableId": 0,
        "vechicleId": 0,
      },
    };

    var body = json.encode(data);
    print(data);
    print(body);
    var createResponse = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(
      "${createResponse.statusCode}" + " --- " + createResponse.body.toString(),
    );
    var response = await json.decode(createResponse.body);
    var list = AppointmentModel.fromJson(response);
    allAppointment.addAll(list.data as Iterable<AppointmentData>);
    notifyListeners();
  }

  Future<int> UpdateAppointmentStatus({
    bool? accept,
    bool? active,
    int? garrageId,
    int? id,
    int? userId,
    int? subServiceId,
    int? vehicleId,
    String? availableTime,
    String? date,
    String? status,
  }) async {
    String myUrl = ApiConstants.BASE_URL + "/api/Appointment/update";
    Uri uri = Uri.parse(myUrl);
    print(myUrl);
    Map<String, dynamic> data = {
      "accept": active,
      "active": accept,
      "availableTime": availableTime,
      "date": date,
      "garrageId": garrageId,
      "id": id,
      "status": status,
      "subServiceId": subServiceId,
      "userId": userId,
      "vehicleId": vehicleId,
    };
    print(data);
    var body = json.encode(data);
    print(body);
    var createResponse = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(
      "${createResponse.statusCode}" + " --- " + createResponse.body.toString(),
    );
    await json.decode(createResponse.body);
    notifyListeners();
    return createResponse.statusCode;
  }

  fiterListAsperStatus(String status) {
    print('the selected tab is ${status}');
    appointmentByGarageId.clear();
    if (status.compareTo("All") == 0) {
      appointmentByGarageId.addAll(appointmentByGarageIdDummy);
    } else {
      appointmentByGarageId = appointmentByGarageIdDummy
          .where(
            (i) =>
                i.status!.toString().toLowerCase().compareTo(
                  status.toLowerCase(),
                ) ==
                0,
          )
          .toList();
    }
    notifyListeners();
  }

  void filterListByUser(String status) {
    AppointmentByUserId.clear();

    if (status == "All") {
      AppointmentByUserId.addAll(AppointmentByUserIdDummy);
    } else {
      AppointmentByUserId.addAll(
        AppointmentByUserIdDummy.where(
          (i) =>
              i.status != null &&
              i.status!.toLowerCase() == status.toLowerCase(),
        ),
      );
    }

    notifyListeners();
  }
}
