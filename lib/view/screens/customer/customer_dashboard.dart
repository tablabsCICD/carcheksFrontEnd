import 'dart:convert';
import 'dart:developer';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/util/api_constants.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_navigation_drawer_widget.dart';
import 'package:carcheks/view/base_widgets/getCart.dart';
import 'package:carcheks/view/base_widgets/getImage.dart';
import 'package:carcheks/view/screens/auth/profile_page.dart';
import 'package:carcheks/view/screens/customer/garage/garage_card.dart';
import 'package:carcheks/view/screens/customer/garage/near_by_store.dart';
import 'package:carcheks/view/screens/customer/service/get_all_services.dart';
import 'package:carcheks/view/screens/customer/service/service_card.dart';
import 'package:carcheks/view/screens/customer/vehicle/add_vehicle_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../model/dashbord_model.dart';
import '../../../model/vehicle_model.dart';
import '../../../provider/cart_provider.dart';
import 'package:http/http.dart' as http;

import '../../../provider/vehicle_provider.dart';

class ImageCarousel {
  String image1;
  String title;
  String subTitle;

  ImageCarousel(this.image1, this.title, this.subTitle);
}

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  _CustomerDashboardState createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  List<ImageCarousel> staticImgList = [
    ImageCarousel(
      'https://images.pexels.com/photos/35967/mini-cooper-auto-model-vehicle.jpg?cs=srgb&dl=pexels-pixabay-35967.jpg&fm=jpg',
      " ",
      " ",
    ),
    ImageCarousel(
      'https://media.newyorker.com/photos/5c362cbd13070229940300f2/master/w_2560%2Cc_limit/Saval-The-Return-of-the-Garage.jpg',
      " ",
      " ",
    ),
  ];
  int _current = 0;
  TextEditingController searchTextController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Providers
  late final ServiceProvider serviceProvider;
  late final GarageProvider garageProvider;
  late final CartProvider cartProvider;
  late final AddressProvider addressProvider;
  late final AuthProvider authProvider;
  late final VehicleProvider vehicleProvider;

  String location = 'Getting Your Current Location...';

  @override
  void initState() {
    super.initState();

    // Initialize providers using service locator
    serviceProvider = locator<ServiceProvider>();
    garageProvider = locator<GarageProvider>();
    cartProvider = locator<CartProvider>();
    addressProvider = locator<AddressProvider>();
    authProvider = locator<AuthProvider>();
    vehicleProvider = locator<VehicleProvider>();
    getVehicalData();
    // Fetch initial data
    serviceProvider.getAllServices();
    callApi();
  }

  void callApi() async {
    String myUrl = ApiConstants.GET_NEAR_BY_GARAGES(
      authProvider.user!.id,
      AppConstants.CurrentLatitude,
      AppConstants.CurrentLongtitude,
    );
    log(myUrl);
    vehicleProvider.vehicleListDashboard.clear();
    var req = await http.get(Uri.parse(myUrl));
    log(req.body);

    if (req.statusCode == 200) {
      var response = json.decode(req.body);
      Dashboard dashboard = Dashboard.fromJson(response);

      if (vehicleProvider.vehicleListDashboard.isEmpty) {
        vehicleProvider.vehicleListDashboard.addAll(dashboard.data!.vehicles!);
      }

      serviceProvider.dashboardServices.clear();
      serviceProvider.dashboardServices.addAll(
        dashboard.data!.services!.content!,
      );

      garageProvider.dashboardGarageList.clear();
      garageProvider.dashboardGarageList.addAll(dashboard.data!.garages!);

      setState(() {}); // <-- required to refresh the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorResources.APPBAR_COLOR,
        title: Text(
          authProvider.user!.firstName + " " + authProvider.user!.lastName,
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: ColorResources.BUTTON_COLOR,
          ), //SvgPicture.asset("assets/svg/hamburger.svg"),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, model, child) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: getImage(model.user!.imageUrl.toString()),
            ),
          ),
          const SizedBox(width: 10),
          GetCart(userId: authProvider.user!.id),
          const SizedBox(width: 10),
        ],
      ),
      drawer: DrawerWidget(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/location.svg"),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        AppConstants.AddressCon,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              selectCardDashbord(),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              getImageSlider(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All Services",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => GetAllServices(
                            vehicle: vehicleProvider.selectedUserVehicle,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        color: ColorResources.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              getServices(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Near By Stores",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      log(vehicleProvider.selectedUserVehicle!.name.toString());
                      log(
                        "Selected Vehicle:" +
                            vehicleProvider.selectedUserVehicle!.name!,
                      );
                      if (vehicleProvider.selectedUserVehicle!.name == "") {
                        const snackBar = SnackBar(
                          content: Text('Please select vehicle'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) =>
                                NearByStore(fromScreen: 'NearByALL'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        color: ColorResources.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              getNearByStore(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  int index = 0;

  getImageSlider() {
    if (serviceProvider.imageUrls.isEmpty) {
      serviceProvider.imageUrls = staticImgList;
    }
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160.0,
            aspectRatio: 16 / 9,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: serviceProvider.imageUrls.map((i) {
            //index++;
            int index = serviceProvider.imageUrls.indexOf(i);
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        serviceProvider.imageUrls[index].image1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Center(
                          child: Text(
                            serviceProvider.imageUrls[index].title,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text(
                        serviceProvider.imageUrls[index].subTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: serviceProvider.imageUrls.map((i) {
                int index = serviceProvider.imageUrls.indexOf(i);
                return Container(
                  width: 7.0,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? ColorResources.PRIMARY_COLOR
                        : Colors.black.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getServices() {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, _) {
        final services = serviceProvider.allServices;

        if (services.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'No services available.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final service = services[index];
              debugPrint("Rendering service: ${service.name}");
              return SizedBox(
                width: 150,
                child: ServiceCard(service, cost: false),
              );
            },
          ),
        );
      },
    );
  }

  getNearByStore() {
    return Consumer<GarageProvider>(
      builder: (context, model, child) => Container(
        height: 180,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: model
              .dashboardGarageList
              .length, //model.garageListNearByUser.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 170,
              width: 160,
              margin: const EdgeInsets.all(5),
              child: CardStore(model.dashboardGarageList[index]),
            );
          },
        ),
      ),
    );
  }

  selectCardDashbord() {
    if (vehicleProvider.vehicleListDashboard.isNotEmpty) {
      AppConstants.vehicle = vehicleProvider.vehicleListDashboard[0];
      vehicleProvider.selectedUserVehicle =
          vehicleProvider.vehicleListDashboard[0];
    }
    return SizedBox(
      height: vehicleProvider.vehicleListDashboard.isEmpty ? 30 : 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: vehicleProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vehicleProvider.vehicleListDashboard.isNotEmpty
            ? FormBuilderDropdown(
                name: vehicleProvider.vehicleListDashboard[0].name.toString(),
                initialValue: vehicleProvider.vehicleListDashboard[0],
                isDense: false,
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.directions_car, color: Colors.black),
                ),
                decoration: InputDecoration.collapsed(
                  hintText: "Select Your Vehicle",
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
                  fillColor: Colors.grey[150],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: vehicleProvider.vehicleListDashboard
                    .map(
                      (vehicle) => DropdownMenuItem(
                        value: vehicle,
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${vehicle.vehicleModel}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${vehicle.registrationNo}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (vehicle) {
                  setState(() {
                    AppConstants.vehicle = vehicle!;
                    vehicleProvider.selectedUserVehicle = vehicle;
                  });
                },
              )
            : InkWell(
                child: const Text(
                  'Add Your Vehicle',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    color: ColorResources.PRIMARY_COLOR,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddVehicleInfo(isdashboard: true),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void getVehicalData() async {
    await vehicleProvider.getAllVehicleListByUserIdnew(
      id: authProvider.user!.id,
    );
  }
}
