import 'dart:convert';
import 'dart:developer';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/user_vehicle_model.dart';
import 'package:carcheks/model/vehicle_manufacturer_model.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/response/vehicle/add_vehicle_response.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/vehicale_model_new.dart';
import '../util/api_constants.dart';

class VehicleProvider extends ChangeNotifier {
  List<Vehicle> vehicleList = [];
  List<String> vehicleNameList = [];

  List<Vehicletype> vehicleTypeList = [];
  List<String> vehicleTypeNameList = [];

  List<Vehicle> vehicleListByUserId = [];
  List<UserVehicle> userVehicleList = [];

  List<VehicleManufacturer> vehicleManufacturerList = [];
  List<String> vehicleManufacturerNameList = [];

  List<Vehicle> vehicleListNew = [];

  List<Vehicle> vehicleListDashboard = [];

  bool isLoadData = false;

  Vehicle? vehicleObj;
  bool isLoading = false;

  String? image;
  Future setImage(img) async {
    this.image = img;
    this.notifyListeners();
  }

  getAllVehicle({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      vehicleList.clear();
    }
    String myUrl = ApiConstants.ALL_VEHICLE;
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = VehicleModel.fromJson(response);
      vehicleNameList.clear();
      vehicleList.clear();
      vehicleList.addAll(type.data as Iterable<Vehicle>);
      vehicleList.forEach((element) {
        vehicleNameList.add(element.name!);
      });
      notifyListeners();
    }
  }

  getAllVehicleType({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      vehicleTypeList.clear();
    }
    String myUrl = ApiConstants.allVehicleType;
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    log(req.body);
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = VehicleTypeModel.fromJson(response);
      vehicleTypeList.clear();
      vehicleTypeNameList.clear();
      vehicleTypeList.addAll(type.data);
      vehicleTypeList.forEach((element) {
        vehicleTypeNameList.add(element.name!);
      });
      log(vehicleTypeNameList.length.toString() +
          'vehical type name list length');
      log(vehicleTypeList.length.toString() + 'vehical type list length');
      notifyListeners();
    }
  }

  getAllVehicleManufacture({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      vehicleManufacturerList.clear();
    }
    String myUrl = ApiConstants.allVehicleManufacturer;

    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = VehicleManufacturerModel.fromJson(response);
      vehicleManufacturerList.clear();
      vehicleManufacturerNameList.clear();
      vehicleManufacturerList.addAll(type.data);
      vehicleManufacturerList.forEach((element) {
        vehicleManufacturerNameList.add(element.name!);
      });
      notifyListeners();
    }
  }

  getAllVehicleListByUserId({int currentPage = 0, int? id}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      vehicleListByUserId.clear();
    }
    String myUrl = ApiConstants.getVehiclesByUserId(id);
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    log('Vehical response ======= ${req.body}');
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = VehicleModel.fromJson(response);
      vehicleListByUserId.addAll(type.data as Iterable<Vehicle>);
      vehicleListDashboard.clear();
      vehicleListDashboard.addAll(vehicleListByUserId);

      notifyListeners();
    }
  }

  getAllVehicleListByUserIdnew({int currentPage = 0, int? id}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      vehicleListByUserId.clear();
    }
    String myUrl = ApiConstants.getVehiclesByUserId(id);
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;

    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = VehicaleModelNew.fromJson(response);
      vehicleListNew.clear();
      vehicleListByUserId.clear();
      vehicleListDashboard.clear();
      vehicleListNew.addAll(type.data!);
      vehicleListDashboard.addAll(type.data!);
      vehicleListByUserId.addAll(type.data!);
      notifyListeners();
    }
  }

  int? selectedVehicleTypeId;
  Vehicletype? vehicleType;
  Vehicle? selectedUserVehicle;
  getSelectedVehicleTypeId(String vehicleName) {
    vehicleTypeList.forEach((element) {
      if (element.name == vehicleName) {
        selectedVehicleTypeId = element.id;
        vehicleType = element;
      }
    });
    return vehicleType;
  }

  String? vehicleTypeName;
  getSelectedVehicleTypeName(int id) async {
    await getAllVehicleType();
    vehicleTypeList.forEach((element) {
      if (element.id == id) {
        vehicleTypeName = element.name;
      }
    });
    return vehicleTypeName;
  }

  int? selectedVehicleId;
  Vehicle? vehicle;
  getSelectedVehicleId(String vehicleName) {
    vehicleList.forEach((element) {
      if (element.name == vehicleName) {
        selectedVehicleId = element.id;
        vehicle = element;
      }
    });
    return vehicle;
  }

  int? selectedVehicleManufacturerId;
  VehicleManufacturer? vehicleManufacturer;
  getSelectedVehicleManufacturerId(String vehicleManufacturerName) {
    vehicleManufacturerList.forEach((element) {
      if (element.name == vehicleManufacturerName) {
        selectedVehicleManufacturerId = element.id;
        vehicleManufacturer = element;
      }
    });
    return vehicleManufacturer;
  }

  Future<Vehicle?> addVehicle(
      {bool? active,
      String? created,
      String? created_by,
      String? last_servecing_date,
      String? name,
      String? vehicle_model,
      String? year,
      String? image_url,
      String? regNumber,
      int? userId,
      Vehicletype? vehicleType,
      VehicleManufacturer? vehicleManufacturer,
      String? updated,
      String? updated_by,
      String? avgRun,
      String? kiloMeterRun,
      String? no_Of_servecing}) async {
    isLoading = true;
    String myUrl = ApiConstants.ADD_VEHICLE;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "active": active,
      "created": created,
      "createdBy": created_by,
      "fueltypeId": 1,
      "lastServiceDate": last_servecing_date,
      "name": name,
      "photos_url": image_url,
      "registrationNo": regNumber,
      "updated": updated,
      "updatedBy": updated_by,
      "userId": userId,
      "vehicleManufacturerId": vehicleManufacturer!.id,
      "vehicle_model": vehicle_model,
      "vehicletypeId": vehicleType!.id,
      "year_of_manufacturing": year
    };
    var body = json.encode(data);
    log(data.toString());
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    log("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());
    if (createResponse.statusCode == 200) {
      var response = await json.decode(createResponse.body);
      var list = AddVehicleResponse.fromJson(response);
      vehicleList.add(list.data);
      vehicleObj = null;
      vehicleObj = list.data;
      notifyListeners();
      return vehicleObj;
    } else {
      return null;
    }
  }

  updateVehicle(
      {bool? active,
      String? created,
      String? created_by,
      String? last_servecing_date,
      String? name,
      String? vehicle_model,
      String? year,
      String? image_url,
      String? regNumber,
      int? userId,
      int? vehicleId,
      FuelType? fuelType,
      Vehicletype? vehicleType,
      VehicleManufacturer? vehicleManufacturer,
      String? updated,
      String? updated_by,
      String? avgRun,
      String? kiloMeterRun,
      String? no_Of_servecing}) async {
    String myUrl = ApiConstants.updateVehicle;
    log(myUrl);
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "id": vehicleId,
      "active": active,
      "created": created,
      "createdBy": created_by,
      "fueltype": {
        "active": true,
        "created": "string",
        "createdBy": "string",
        "id": 1,
        "name": "string"
      },
      "lastServiceDate": last_servecing_date,
      "name": name,
      "photos_url": image_url,
      "registrationNo": regNumber,
      "updated": updated,
      "updatedBy": updated_by,
      "userId": userId,
      "vehicleManufacturer": {
        "active": true,
        "created": "string",
        "createdBy": "string",
        "id": vehicleManufacturer!.id,
        "name": "string",
        "updated": "string",
        "updatedBy": "string"
      },
      "vehicle_model": vehicle_model,
      "vehicletype": {
        "active": true,
        "created": "string",
        "createdBy": "string",
        "id": vehicleType!.id,
        "name": "string"
      },
      "year_of_manufacturing": year
    };
    var body = json.encode(data);
    log(data.toString());
    var createResponse = await http.put(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    log("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());
    log(createResponse.body);
    var response = await json.decode(createResponse.body);
    var res = AddVehicleResponse.fromJson(response);
    vehicleObj = res.data;

    notifyListeners();
  }

  addUserVehicle(
      {bool? active,
      String? created,
      String? created_by,
      String? last_servecing_date,
      String? name,
      String? vehicle_model,
      String? year,
      String? image_url,
      String? regNumber,
      int? userId,
      FuelType? fuelType,
      Vehicletype? vehicleType,
      VehicleManufacturer? vehicleManufacturer,
      String? updated,
      String? updated_by,
      String? avgRun,
      String? kiloMeterRun,
      String? no_Of_servecing,
      Vehicle? vehicle}) async {
    String myUrl = ApiConstants.ADD_VEHICLE;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "active": active,
      "created": created,
      "createdBy": created_by,
      "fueltype": {
        "active": true,
        "created": "string",
        "createdBy": "string",
        "id": fuelType!.id,
        "name": "string"
      },
      "lastServiceDate": last_servecing_date,
      "name": name,
      "photos_url": image_url,
      "registrationNo": regNumber,
      "updated": updated,
      "updatedBy": updated_by,
      "userId": userId,
      "vehicleManufacturer": {
        "active": true,
        "created": "string",
        "createdBy": "string",
        "id": vehicleManufacturer!.id,
        "name": "string",
        "updated": "string",
        "updatedBy": "string"
      },
      "vehicle_model": vehicle_model,
      "vehicletype": {
        "active": true,
        "created": "string",
        "createdBy": "string",
        "id": vehicleType!.id,
        "name": "string"
      },
      "year_of_manufacturing": year
    };
    var body = json.encode(data);
    log(data.toString());
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    log("${createResponse.statusCode}" +
        " --- " +
        createResponse.body.toString());
    var response = await json.decode(createResponse.body);
    var list = UserVehicleModel.fromJson(response);
    userVehicleList = list.data;
    userVehicleList = list.data;
    notifyListeners();
  }

  deleteVehicle(i, index) async {
    String myUrl =ApiConstants.deleteVehicle(i);
       ;
    //log("DELETED VEHICLE");
    var req = await http.delete(Uri.parse(myUrl));
    var deleteResponse = json.decode(req.body);
    vehicleListByUserId.removeAt(index);
    vehicleListNew.removeAt(index);

    notifyListeners();
  }

  void callApi() async {
    isLoadData = true;
    await getAllVehicle();
    await getAllVehicleManufacture();
    await getAllVehicleType();
    isLoadData = false;
    notifyListeners();
  }
}
