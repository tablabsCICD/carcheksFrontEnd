

import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/bid_provider.dart';
import 'package:carcheks/provider/cart_provider.dart';
import 'package:carcheks/provider/feddback_provider.dart';
import 'package:carcheks/provider/fuel_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/img_provider.dart';
import 'package:carcheks/provider/payment_provider.dart';
import 'package:carcheks/provider/review_provider.dart';
import 'package:carcheks/provider/search_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/provider/transaction_provider.dart';
import 'package:carcheks/provider/user_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/appointment_provider.dart';
import 'provider/user_order_service_provider.dart';

GetIt locator = GetIt.asNewInstance();

Future<void> setupLocator() async {

  locator.registerLazySingleton(() => FuelProvider());
  locator.registerLazySingleton(() => GarageProvider());
  locator.registerLazySingleton(() => ServiceProvider());
  locator.registerLazySingleton(() => VehicleProvider());
  locator.registerLazySingleton(() => AddressProvider());
  locator.registerLazySingleton(() => BidProvider());
  locator.registerLazySingleton(() => TransactionProvider());
  locator.registerLazySingleton(() => UserProvider());
  locator.registerLazySingleton(() => AuthProvider());
  locator.registerLazySingleton(() => AppointmentProvider());
  locator.registerLazySingleton(() => ImgProvider());
 locator.registerLazySingleton(() => CartProvider());
 locator.registerLazySingleton(() => UserOrderServicesProvider());
  locator.registerLazySingleton(() => ReviewProvider());
  locator.registerLazySingleton(() => PaymentProvider());
  locator.registerLazySingleton(() => SearchProvider());
  locator.registerLazySingleton(() => FeedbackProvider());
 // locator.registerLazySingleton(() => LocalizationProvider(sharedPreferences: locator()));
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
}
