import 'dart:async';
import 'dart:io';

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
import 'package:carcheks/provider/transaction_provider.dart';
import 'package:carcheks/provider/user_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/provider/withdrawal_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/route/routes.dart';
import 'package:carcheks/service/deep_link_service.dart';
import 'package:carcheks/view/screens/auth/login_page.dart';
import 'package:carcheks/view/screens/customer/customer_dashboard.dart';
import 'package:carcheks/view/screens/customer/garage/garage_dashboard.dart';
import 'package:carcheks/view/screens/notification/local_notification.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/appointment_provider.dart';
import 'provider/review_provider.dart';
import 'provider/user_order_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


   if (Platform.isAndroid) {
     LocalNotificationService.initialize();
     FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

     FirebaseMessaging.onBackgroundMessage(backgroundHandler);
     FirebaseMessaging.onMessage.listen(backgroundHandler);
     FirebaseMessaging.onMessageOpenedApp.listen(backgroundHandler);
   final message = await FirebaseMessaging.instance.getInitialMessage();
   if (message != null) {
     LocalNotificationService.createanddisplaynotification(message);
   }
  getFCMToken();
 }

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deepLinkService = DeepLinkService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthProvider>();
    _deepLinkService.init(context, auth);
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
     return MaterialApp(
       title: 'CarCheks',
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
         primarySwatch: Colors.blue,
         fontFamily: 'Poppins', // ✅ offline & crash-proof
       ),
       initialRoute: AppRoutes.entryScreen,
       home: Consumer<AuthProvider>(
         builder: (context, auth, _) {
           if (auth.isLoading) {
             return const Scaffold(
               body: Center(child: CircularProgressIndicator()),
             );
           }

           if (auth.user == null) {
             return LoginPage();
           }

           if (auth.user!.garrageOwner == true) {
             return GarageDashboard();
           }

           return CustomerDashboard();
         },
       ),
       onGenerateRoute: RouteGenerator.generateRoute,

     );
   }
}
