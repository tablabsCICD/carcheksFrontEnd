import 'package:carcheks/util/app_constants.dart';

class ApiConstants {
  static String BASE_URL = "https://api.carcheks.com/carchecks";
  /*static String BASE_URL =
      "http://ec2-3-111-52-135.ap-south-1.compute.amazonaws.com:8080/carchecks";*/

  static String LOGIN = "$BASE_URL/UserTable/authLogin/";
  static String REGISTRATION = "$BASE_URL/UserTable/saveUserByAddress";
  static String UPDATE_USER_PROFILE = "$BASE_URL/UserTable/UserTable/update";
  static String DELETE_USER(id) => "$BASE_URL/UserTable/softDelete?id=$id";
  static String GET_ALL_USER = "$BASE_URL/UserTable/UserTable/getAll";
  static String SAVE_GARAGE = "$BASE_URL/api/garage/save";
  static String UPDATE_GARAGE = "$BASE_URL/api/Garages/update";
  static String ADD_VEHICLE = "$BASE_URL/Vehicle/Vehicle/save";
  static String UPLOAD_IMG = "$BASE_URL/up/samveImage";

  //address-controller
  static String DELETE_Address = "$BASE_URL/api/address/deleteById?id=1";
  static String SAVE_Address = "$BASE_URL/api/address/save";
  static String GET_All_Address = "$BASE_URL/api/address/getAll";
  static String Get_By_City_Id = "$BASE_URL/api/address/getByCityId";
  static String Get_Address_By_Id = "$BASE_URL/api/address/getById";
  static String UPDATE_Address = "$BASE_URL/api/address/update";
  static String Get_Address_by_ZipCode = "$BASE_URL/api/getAddressbyzipcode";
  static String Get_Address_For_User = "$BASE_URL/api/getAddressForUser";

  static String ALL_VEHICLE =
      "${ApiConstants.BASE_URL}/VehicleType/VehicleType/getAll";
  static String GET_NEAR_BY_GARAGES(userId, lat, long) =>
      "${ApiConstants.BASE_URL}/api/getnearbyGaragesbyuserId?usertableId=${userId}&latitude=${lat}&longitude=${long}";
  static String GET_ALL_CITY = "${ApiConstants.BASE_URL}/api/city/getAll";
  static String saveBidding = "${ApiConstants.BASE_URL}/api/bidding/save";
  static String cartGetByUserId(userId) =>
      "${ApiConstants.BASE_URL}/api/CartCotroller/getByUserId?userId=${userId}";
  static String saveCart = "${ApiConstants.BASE_URL}/api/CartCotroller/save";
  static String removeCart(cartId) =>
      '${ApiConstants.BASE_URL}/api/CartCotroller/deleteById?id=${cartId}';
  static String allVehicleType =
      "${ApiConstants.BASE_URL}/VehicleType/VehicleType/getAll";
  static String allVehicleManufacturer =
      "${ApiConstants.BASE_URL}/VehicleManufacturer/GarageServices/getAll";
  static String getVehiclesByUserId(userId) =>
      "${ApiConstants.BASE_URL}/Vehicle/user/getbyuserid?id=${userId}";
  static String updateVehicle =
      "${ApiConstants.BASE_URL}/Vehicle/Vehicle/update";
  static String deleteVehicle(id) =>
      "${ApiConstants.BASE_URL}/Vehicle/Vehicle/deleteById?id=${id}";

  static String allFuelType = "${ApiConstants.BASE_URL}/api/fuelType/getAll";
  //Appointment
  static String DELETE_Appointment = "$BASE_URL/api/Appointment/deleteById";
  static String SAVE_Appointment = "$BASE_URL/api/Appointment/save";
  static String GET_Appointment_BY_ID = "$BASE_URL/api/Appointment/getById";
  static String GET_All_Appointment = "$BASE_URL/api/Appointment/getAll";
  static String Get_Appointment_By_Garage_ID =
      "$BASE_URL/api/Appointment/getByGarrageId";
  static String Get_Appointment_By_User_ID =
      "$BASE_URL/api/Appointment/getByUserId2";
  //Transaction
  static String SAVE_Transaction =
      "$BASE_URL/TrasactionPayment/TrasactionPayment/save";
  static String GET_All_Transactions =
      "$BASE_URL/TrasactionPayment/TrasactionPayment/getAll";

  static String saveFeedback = "$BASE_URL/api/help/add";
  static String getFeedback(id) => "$BASE_URL/api/help/getByUserId?userId=$id";
}
