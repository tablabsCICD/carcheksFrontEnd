import 'dart:convert';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/search_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/custom_navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/garage_services_model.dart';
import '../../../route/app_routes.dart';

class ServiceSearch extends StatefulWidget {
  @override
  _ServiceSearchState createState() => _ServiceSearchState();
}

class _ServiceSearchState extends State<ServiceSearch> {
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final AuthProvider authProvider = locator<AuthProvider>();
  final SearchProvider searchProvider = locator<SearchProvider>();
  final VehicleProvider vehicleProvider = locator<VehicleProvider>();

  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _initLocation();
    _loadVehicleData();
  }

  Future<void> _initLocation() async {
    try {
      currentPosition = await _getGeoLocationPosition();
    } catch (e) {
      print("⚠ Cannot fetch location: $e");
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadVehicleData() async {
    if (vehicleProvider.vehicleListDashboard.isNotEmpty) {
      String name = await vehicleProvider.getSelectedVehicleTypeName(
        vehicleProvider.vehicleListDashboard[0].vehicletype!.id!,
      );

      if (name.isNotEmpty) {
        await searchProvider.getAllData(name);
      }
    }
  }

  // -----------------------------------------------------
  //                 DISTANCE CALCULATION
  // -----------------------------------------------------
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  // -----------------------------------------------------
  //              SHIMMER LOADER FOR CARDS
  // -----------------------------------------------------
  Widget shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 250,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // -----------------------------------------------------
  //              GARAGE + SERVICE MERGED CARD
  // -----------------------------------------------------
  Widget garageServiceCard(GarageService data) {
    if (currentPosition == null) return shimmerCard();

    final garage = data.garage;
    final service = data.subService;
    final mainService = data.mainService;

    // ---------------- IMAGE SELECTION LOGIC ----------------
    String imageUrl = "";

    if (garage?.imageUrl != null && garage!.imageUrl!.isNotEmpty) {
      imageUrl = garage.imageUrl!;
    } else if (mainService?.photosUrl != null &&
        mainService!.photosUrl!.isNotEmpty) {
      imageUrl = mainService.photosUrl!;
    } else if (service?.photosUrl != null &&
        service!.photosUrl!.isNotEmpty) {
      imageUrl = service.photosUrl!;
    } else {
      imageUrl = "https://dummyimage.com/600x400/cccccc/ffffff&text=No+Image"; // fallback image
    }

    // ---------------- DISTANCE ----------------
    final lat = double.tryParse("${garage?.latitude}") ?? 0;
    final lng = double.tryParse("${garage?.longitude}") ?? 0;

    final distance = calculateDistance(
      currentPosition!.latitude,
      currentPosition!.longitude,
      lat,
      lng,
    );

    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          // ---------------- IMAGE ----------------
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey.shade300,
                child: Icon(Icons.image_not_supported, size: 50),
              ),
            ),
          ),

          // ---------------- TEXT & DETAILS ----------------
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  garage?.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 4),

                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 3),
                    Text("${garage?.rating ?? 0} (${garage?.noOfRating ?? 0})",
                        style: TextStyle(fontSize: 12)),
                    Spacer(),
                    Icon(Icons.location_on, color: Colors.red, size: 16),
                    Text("${distance.toStringAsFixed(1)} km",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),

                SizedBox(height: 8),

                Text(
                  service?.name ?? mainService?.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),

                SizedBox(height: 4),

                Text(
                  service?.shortDiscribtion ??
                      mainService?.shortDiscribtion ??
                      "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      "Cost: ${service?.costing ?? data.cost ?? "--"}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.garage_details,
                            arguments: garage);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: ColorResources.PRIMARY_COLOR,
                      ),
                      child:
                      Text("View", style: TextStyle(fontSize: 12, color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  // -----------------------------------------------------
  //                  MAIN UI BUILD
  // -----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: currentPosition == null
          ? Center(
        child: CircularProgressIndicator(color: Colors.blue),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: ProsteBezierCurve(
                    position: ClipPosition.bottom,
                    list: [
                      BezierCurveSection(
                        start: Offset(0, 420),
                        top: Offset(screenWidth / 2, 460),
                        end: Offset(screenWidth, 420),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 300,
                    color: ColorResources.PRIMARY_COLOR,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () =>
                              _scaffoldKey.currentState!.openDrawer(),
                          child: Icon(Icons.menu,
                              color: Colors.white, size: 30),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Service Search",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Please choose your car",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 10),

                        // ----------- VEHICLE DROPDOWN -----------
                        Consumer<VehicleProvider>(
                          builder: (context, model, child) {
                            return SizedBox(
                              height: 65,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Center(
                                    child: FormBuilderDropdown(
                                      name: "car",
                                      initialValue: model.vehicleListDashboard.isNotEmpty
                                          ? model.vehicleListDashboard.first
                                          : null,
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      icon: Icon(Icons.directions_car),
                                      items: model.vehicleListDashboard
                                          .map((veh) {
                                        return DropdownMenuItem(
                                          value: veh,
                                          child: Text(
                                            "${veh.vehicleModel} | ${veh.registrationNo}",
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) async {
                                        String name =
                                        await vehicleProvider
                                            .getSelectedVehicleTypeName(
                                            value!.vehicletype!
                                                .id!);
                                        await searchProvider
                                            .getAllData(name);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recommended Service Garages",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),

            SizedBox(
              height: 400,
              child: Consumer<SearchProvider>(
                builder: (context, model, child) {
                  if (model.isLoading) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          4, (index) => shimmerCard()),
                    );
                  }

                  if (model.garageServiceList.isEmpty) {
                    return Center(child: Text("No results found"));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    itemCount: model.garageServiceList.length,
                    itemBuilder: (context, index) =>
                        garageServiceCard(model.garageServiceList[index]),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------
  //                LOCATION PERMISSION
  // -----------------------------------------------------
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw "Location services disabled";
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw "Permission denied";
    }

    if (permission == LocationPermission.deniedForever) {
      throw "Permissions permanently denied";
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
