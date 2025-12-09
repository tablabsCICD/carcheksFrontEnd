
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/vehicle_manufacturer_model.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';

class AppConstants {

  static String APP_VERSION = "1.0.0";//1

  static String DEFAULT_SERVICE_IMG =
      "https://cdn.vectorstock.com/i/preview-1x/40/42/car-service-vector-3874042.webp";
  static String DEFAULT_SUBSERVICE_IMG =
      "https://img.freepik.com/free-vector/auto-service-illustration_1284-20618.jpg?w=740&t=st=1706589298~exp=1706589898~hmac=53a42681acd6871b63ae8833f298aecb42f80a902da57c4df1a6f140054d8152";
  static String DEFAULT_GARAGE_IMG =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7LvL8MmZJVR-ai8ZhGV1b764DsnfoWKw6myVQyoyWEA&s";
  static String DEFAULT_VEHICAL_IMG =
      "http://ec2-13-201-190-26.ap-south-1.compute.amazonaws.com:8080/carcheks/up/samveImage";

  static const String money = '\$';

  static const String payPal_ClientId =
      "AXqn8_LxoPKw8ZuQM5vADuVXMsntHCI5X7cCxQXHRM-7hL4T7U8-chUD4r7x_pij1M8CQeEcUeLB-fiD";
  static const String PayPal_SecretKey =
      "EA7l-G226TBGxoyTsMOBMnlLG_U3cUSHcUwPdCTp9CDFHBKBJuTzDzeFCXsUu4CZwP80fbUxTfJOvdYH";

  /*static const String payPal_ClientId= "AQ5fqUqBbaMwD5bX5d6K9m3V8TmHtUee4ktczVIZmRczR3nAbJCU9XrAfokLVJZKYur9eKgmEPb_Y7Wg";
 static const String PayPal_SecretKey= "EJAluPtkT9Mdd-Zinjm8Eb1xYysJZA4GaHqs1K9pav9tBjZsN356P9BI1EUFsOc2ki66hNDyw46bsjZ2";*/

  static const String google_api_key =
      "AIzaSyDtAZoTy--RMsfvtQv9lONGZ6ui5kG4vDI";

  static const privacyPolicyUrl = "https://carcheks-img.s3.ap-south-1.amazonaws.com/498f6f93-ce4f-41c7-aa17-f9989a97dfa4-privacy-policy.html";

  static const playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.napesoft.carcheks";

  static const appStoreUrl =
      "https://play.google.com/store/apps/details?id=com.napesoft.carcheks";

  static String AddressCon = "Getting Your Current Location...";
  static String LocationCon = "";
  static double CurrentLatitude = 0;
  static double CurrentLongtitude = 0;
  static Vehicle vehicle = Vehicle(
      id: 0,
      created: "created",
      createdBy: "createdBy",
      updated: "updated",
      updatedBy: "updatedBy",
      active: true,
      userId: 0,
      vehicleManufacturer: VehicleManufacturer(
          id: 0,
          created: '',
          createdBy: '',
          updated: '',
          updatedBy: '',
          active: true,
          name: ''),
      vehicleModel: "vehicleModel",
      fueltype:
          FuelType(id: 0, created: '', createdBy: '', active: true, name: ''),
      photosUrl: 'photosUrl',
      vehicletype: Vehicletype(
          id: 0, created: '', createdBy: '', active: true, name: '')!,
      yearOfManufacturing: 'yearOfManufacturing',
      registrationNo: "registrationNo",
      lastServiceDate: "lastServiceDate",
      name: "name");

}
