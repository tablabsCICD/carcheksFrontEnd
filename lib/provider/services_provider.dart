import 'dart:convert';
import 'dart:developer';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/model/offer_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/response/add_address_response.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/garage_home.dart';
import '../util/api_constants.dart';
import '../view/screens/customer/customer_dashboard.dart';

class ServiceProvider extends ChangeNotifier {
  List<MainService> allServices = [];
  List<MainService> serviceListByGarageId = [];
  List<SubService> subServiceListByServiceId = [];

  List<MainService> dashboardServices = [];

  List<GarageService> allGarageServices = [];
  List<GarageService> garageServiceListByGarageId = [];
  List<SubService> subServiceListByGarageServiceId = [];

  List<String> subServicesNameList = [];
  List<Offer> offerList = [];
  bool isLoading = false;
  int count = 0;
  int totalAmt = 0;
  Guarage_home guarage_home = Guarage_home(
      workInProgress: 0,
      pending: 0,
      newAppointment: 0,
      numberOfRequest: 0,
      completed: 0,
      cancled: 0,
      delivered: 0);

  AddressClass? addressClass;
  getAddressByAddressId(int id) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL + "/api/address/getById?id=${id}";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      addressClass = null;
      var response = json.decode(req.body);
      var type = SaveAddressResponse.fromJson(response);
      addressClass = type.data;
      notifyListeners();
    }
  }

  List<ImageCarousel> imageUrls = [];
  getAllOffer() async {
    isLoading = true;
    notifyListeners();
    offerList.clear();
    String myUrl = ApiConstants.BASE_URL + "/api/offer/getAll";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = OfferModel.fromJson(response);
      offerList.clear();
      offerList.addAll(type.data);
      offerList.forEach((element) {
        imageUrls.add(
            ImageCarousel(element.imageUrl, element.name, element.discription));
      });

      // log(offerList[0]);
      notifyListeners();
    }
  }

  getAllGarageServices({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      allGarageServices.clear();
    }
    String myUrl =
        ApiConstants.BASE_URL + "/garrage_services/GarageServices/getAll";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = GarageServiceModel.fromJson(response);
      allGarageServices.clear();
      allGarageServices.addAll(type.data);
      //  log(allGarageServices[0]);
      notifyListeners();
    }
  }

  getServicesByGarageId(int garageId) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL +
        "/Services/service/getbygarages?garrage_id=${garageId}";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = ServiceModel.fromJson(response);
      serviceListByGarageId.clear();
      serviceListByGarageId.addAll(type.data);
      log(serviceListByGarageId[0].toString());
      notifyListeners();
    }
  }

  getGarageServicesByGarageId(int garageId, {int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      garageServiceListByGarageId.clear();
    }
    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/GarageServices/getAllGSByGarageId?id=${garageId}";
    //  "/garrage_services/GarageServices/getbygarageid?id=${garageId}";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      garageServiceListByGarageId.clear();
      var response = json.decode(req.body);
      var type = GarageServiceModel.fromJson(response);
      garageServiceListByGarageId.addAll(type.data);

      notifyListeners();
    }
  }

  getAllServices({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      allServices.clear();
    }
    String myUrl = ApiConstants.BASE_URL + "/Services/Services/getAll";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    log('services response:========= ${req.body}');

    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = ServiceModel.fromJson(response);
      allServices.clear();
      allServices.addAll(type.data);
      //  log(allServices[0]);
      isLoading = false;
      notifyListeners();
    }
  }

  List<int> subServiceIdList = [];
  getSubServicesByServiceId({int currentPage = 0, int? serviceId}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      subServiceListByServiceId.clear();
    }
    String myUrl = ApiConstants.BASE_URL +
        "/Subservice/Subservice/getbyparentService?id=${serviceId}";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));

    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = SubServiceModel.fromJson(response);
      subServiceListByServiceId.clear();
      subServiceIdList.clear();
      subServicesNameList.clear();
      subServiceListByServiceId.addAll(type.data);
      subServiceListByServiceId.forEach((element) {
        subServicesNameList.add(element.name);
        subServiceIdList.add(element.id);
      });
      isLoading = false;
      notifyListeners();
      return subServiceIdList;
    }
  }

  int? selectedSubServiceId;
  SubService? subService;
  getSelectedGarageServiceId(String serviceName) {
    subServiceListByServiceId.forEach((element) {
      if (element.name == serviceName) {
        selectedSubServiceId = element.id;
        subService = element;
      }
    });
    return subService;
  }

  getSelectedServiceCount() {
    allServices.forEach((element) {
      if (element.isServiceSelected == true) {
        count++;
      }
    });
    return count;
  }

  setSelectedService(MainService service) {
    service.isServiceSelected = !service.isServiceSelected;
  }

  /*getAllByid(int VehicleTypeId) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL +"/garrage_services/getbyvechicletypeid?id=1";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = ServiceModel.fromJson(response);
      allServices.clear();
      allServices.addAll(type.data);
      //  log(allServices[0]);
      notifyListeners();
    }
  }*/
  getAllByid(int VehicleTypeId) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstants.BASE_URL +
        "/garrage_services/services/byVehicleType2?vehicleTypeId=1";
    log(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = ServiceModel.fromJson(response);
      allServices.clear();
      allServices.addAll(type.data);
      //  log(allServices[0]);
      notifyListeners();
    }
  }

  getAppointmentData(int id) async {
    isLoading = true;
    var req = await http.get(Uri.parse(
        ApiConstants.BASE_URL + "/api/Appointment/getCount?garageId=${id}"));
    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      guarage_home = Guarage_home.fromJson(response);
      await getAllServices();
    }
  }
}
