import 'package:carcheks/entry_screen.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/view/screens/auth/join_us_screen.dart';
import 'package:carcheks/view/screens/auth/login_page.dart';
import 'package:carcheks/view/screens/auth/profile_page.dart';
import 'package:carcheks/view/screens/auth/registration_page.dart';
import 'package:carcheks/view/screens/auth/view_address.dart';
import 'package:carcheks/view/screens/customer/cart/my_cart.dart';
import 'package:carcheks/view/screens/customer/customer_dashboard.dart';
import 'package:carcheks/view/screens/customer/date_screen.dart';
import 'package:carcheks/view/screens/customer/estimate_details.dart';
import 'package:carcheks/view/screens/customer/garage/garage_dashboard.dart';
import 'package:carcheks/view/screens/customer/garage/garage_details.dart';
import 'package:carcheks/view/screens/customer/garage/near_by_store.dart';
import 'package:carcheks/view/screens/customer/notes.dart';
import 'package:carcheks/view/screens/customer/service/get_all_services.dart';
import 'package:carcheks/view/screens/customer/service_search.dart';
import 'package:carcheks/view/screens/customer/vehicle/add_vehicle_info.dart';
import 'package:carcheks/view/screens/customer/vehicle/view_vehicles.dart';
import 'package:carcheks/view/screens/customer/wallet.dart';
import 'package:carcheks/view/screens/garage_owner/appointment/all_appointment.dart';
import 'package:carcheks/view/screens/customer/appointment/view_user_appoinment.dart';
import 'package:carcheks/view/screens/garage_owner/garage_info.dart';
import 'package:carcheks/view/screens/garage_owner/garage_services/add_services.dart';
import 'package:carcheks/view/screens/garage_owner/garage_services/choose_services.dart';
import 'package:carcheks/view/screens/garage_owner/garage_services/edit_service.dart';
import 'package:carcheks/view/screens/garage_owner/garage_services/view_services.dart';
import 'package:flutter/material.dart';
import '../view/screens/about_us/about_us.dart';
import '../view/screens/contact_us/contact_us.dart';
import '../view/screens/customer/service/service_history.dart';
import '../view/screens/rate_raview/rate_review_screen.dart';
import '../view/screens/support/support_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.entryScreen:
        return buildRoute(EntryScreen(), settings: settings);

      case AppRoutes.select_type:
        return buildRoute(JoinUsScreen(), settings: settings);

      case AppRoutes.register:
        final set = settings.arguments as Set<bool>;
        bool isSelectedCustomer = set.first;
        return buildRoute(
          RegistrationScreen(isSelectedCustomer),
          settings: settings,
        );

      case AppRoutes.login:
        return buildRoute(LoginPage(), settings: settings);

      case AppRoutes.search:
        return buildRoute(ServiceSearch(), settings: settings);

      case AppRoutes.customer_home:
        return buildRoute(CustomerDashboard(), settings: settings);

      case AppRoutes.garage_home:
        return buildRoute(GarageDashboard(), settings: settings);

      case AppRoutes.garage_details:
        Garage garage = settings.arguments as Garage;
        return buildRoute(GarageDetails(garage), settings: settings);

      case AppRoutes.garage_info:
        return buildRoute(GarageInfo(), settings: settings);

      case AppRoutes.choose_service:
        return buildRoute(ChooseServices(), settings: settings);

      case AppRoutes.date:
        final set = settings.arguments as Set<dynamic>;
        Garage garage = set.first as Garage;
        String notes = set.last as String;
        return buildRoute(
          ChooseDate(garage: garage, notes: notes),
          settings: settings,
        );

      case AppRoutes.garage_address:
        return buildRoute(ViewAddress(), settings: settings);

      case AppRoutes.customer_address:
        return buildRoute(ViewAddress(), settings: settings);

      case AppRoutes.garageOwner_profile:
        bool isFromGarage = settings.arguments as bool;
        return buildRoute(
          ProfilePage(isFromGarage: isFromGarage),
          settings: settings,
        );

      case AppRoutes.edit_service:
        final set = settings.arguments as Set<dynamic>;
        int? garageId = set.first as int;
        GarageService? mainService = set.last as GarageService;
        return buildRoute(
          EditService(garageId: garageId, mainserviceId: mainService),
          settings: settings,
        );

      case AppRoutes.view_service:
        final set = settings.arguments as Set<dynamic>;
        Vehicle? vehicle = set.first as Vehicle;
        String? from = set.last as String;
        return buildRoute(
          GetAllServices(vehicle: vehicle, from: from),
          settings: settings,
        );

      case AppRoutes.view_garage_service:
        int? serviceId = settings.arguments as int;
        return buildRoute(
          ViewServices(mainServiceId: serviceId),
          settings: settings,
        );

      case AppRoutes.add_service:
        MainService service = settings.arguments as MainService;
        return buildRoute(AddServices(service), settings: settings);

      case AppRoutes.customer_profile:
        bool isFromGarage = settings.arguments as bool;
        return buildRoute(
          ProfilePage(isFromGarage: isFromGarage),
          settings: settings,
        );

      case AppRoutes.add_vehicle:
        bool isdashboard = settings.arguments as bool;

        return buildRoute(
          AddVehicleInfo(isdashboard: isdashboard),
          settings: settings,
        );

      case AppRoutes.vehicle_details:
        return buildRoute(ViewVehicles(), settings: settings);

      case AppRoutes.near_by_store:
        String type = settings.arguments as String;
        return buildRoute(NearByStore(fromScreen: type), settings: settings);

      case AppRoutes.cart:
        return buildRoute(MyCart(), settings: settings);

      case AppRoutes.notes:
        Garage garage = settings.arguments as Garage;
        return buildRoute(Notes(garage: garage), settings: settings);

      case AppRoutes.service_history:
        return MaterialPageRoute(builder: (_) => const ServiceHistoryScreen());

      case AppRoutes.support_center:
        return MaterialPageRoute(builder: (_) => SupportScreen());

      case AppRoutes.contact_us:
        return MaterialPageRoute(builder: (_) => ContactUsScreen());

      case AppRoutes.about_us:
        return MaterialPageRoute(builder: (_) => AboutUsScreen());

      case AppRoutes.payment:
        Set<dynamic> set = settings.arguments as Set<dynamic>;
        int pos = 0;
        String? time, notes, date;
        Garage? garage;
        set.forEach((element) {
          switch (pos) {
            case 0:
              garage = element as Garage;
              break;
            case 1:
              date = element as String;
              break;
            case 2:
              time = element as String;
              break;
            case 3:
              notes = element as String;
              break;
          }
          pos++;
        });

        return buildRoute(
          Wallet(garage: garage, date: date, time: time, notes: notes),
          settings: settings,
        );

      case AppRoutes.estimate_details:
        Set<dynamic> set = settings.arguments as Set<dynamic>;
        int pos = 0;
        String? time, notes, date;
        Garage? garage;
        set.forEach((element) {
          switch (pos) {
            case 0:
              garage = element as Garage;
              break;
            case 1:
              date = element as String;
              break;
            case 2:
              time = element as String;
              break;
            case 3:
              notes = element as String;
              break;
          }
          pos++;
        });

        return buildRoute(
          EstimateDetails(garage: garage, date: date, time: time, notes: notes),
          settings: settings,
        );

      case AppRoutes.appointment:
        String type = settings.arguments as String;
        return buildRoute(AllAppointment(type: type), settings: settings);

      case AppRoutes.my_appointment:
        return buildRoute(ViewUserAppointment(), settings: settings);

      default:
        return buildRoute(EntryScreen(), settings: settings);
    }
  }

  static MaterialPageRoute buildRoute(
    Widget child, {
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => child,
    );
  }

  static Route _createRoute(Widget root) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => root,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
        ;
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Exit App',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 450.0,
                    width: 450.0,
                    //child: Lottie.asset('assets/lottie/error.json'),
                  ),
                  Text(
                    'Seems the route you\'ve navigated to doesn\'t exist!!',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
