import 'dart:async';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/bid_provider.dart';
import 'package:carcheks/provider/cart_provider.dart';
import 'package:carcheks/provider/feddback_provider.dart';
import 'package:carcheks/provider/fuel_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/img_provider.dart';
import 'package:carcheks/provider/payment_provider.dart';
import 'package:carcheks/provider/search_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/provider/settlement_provider.dart';
import 'package:carcheks/provider/transaction_provider.dart';
import 'package:carcheks/provider/user_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/provider/withdrawal_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/route/routes.dart';
import 'package:carcheks/view/screens/notification/local_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'provider/appointment_provider.dart';
import 'provider/review_provider.dart';
import 'provider/user_order_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //LocalNotificationService.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     // options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  // if (Platform.isIOS) {
  //   //LocalNotificationService.initialize();
  //   FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  //   FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  //   FirebaseMessaging.onMessage.listen(backgroundHandler);
  //   FirebaseMessaging.onMessageOpenedApp.listen(backgroundHandler);

  //   final message = await FirebaseMessaging.instance.getInitialMessage();
  //   if (message != null) {
  //     LocalNotificationService.createanddisplaynotification(message);
  //   }
  //   getFCMToken();
  // }

  await setupLocator();

  runApp(
    OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<FuelProvider>()),
          ChangeNotifierProvider(create: (_) => locator<GarageProvider>()),
          ChangeNotifierProvider(create: (_) => locator<ServiceProvider>()),
          ChangeNotifierProvider(create: (_) => locator<VehicleProvider>()),
          ChangeNotifierProvider(create: (_) => locator<AddressProvider>()),
          ChangeNotifierProvider(create: (_) => locator<BidProvider>()),
          ChangeNotifierProvider(create: (_) => locator<TransactionProvider>()),
          ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
          ChangeNotifierProvider(create: (_) => locator<AuthProvider>()),
          ChangeNotifierProvider(create: (_) => locator<AppointmentProvider>()),
          ChangeNotifierProvider(create: (_) => locator<ImgProvider>()),
          ChangeNotifierProvider(create: (_) => locator<CartProvider>()),
          ChangeNotifierProvider(
            create: (_) => locator<UserOrderServicesProvider>(),
          ),
          ChangeNotifierProvider(create: (_) => locator<ReviewProvider>()),
          ChangeNotifierProvider(create: (_) => locator<PaymentProvider>()),
          ChangeNotifierProvider(create: (_) => locator<SearchProvider>()),
          ChangeNotifierProvider(create: (_) => locator<FeedbackProvider>()),
          ChangeNotifierProvider(create: (_) => locator<WithdrawalProvider>()),
          ChangeNotifierProvider(create: (_) => SettlementProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Notification Received :::::: ${message.data}");
  LocalNotificationService.createanddisplaynotification(message);
}

late Stream<String> _tokenStream;
getFCMToken() {
  FirebaseMessaging.instance.getToken().then(setToken);
  _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
  _tokenStream.listen(setToken);
}

void setToken(String? token) {
  print('FCM Token: $token');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarCheks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.entryScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
// 14 jan 2026