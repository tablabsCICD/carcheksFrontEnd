import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/screens/customer/vehicle/add_vehicle_info.dart';
import 'package:carcheks/view/screens/customer/vehicle/edit_vehicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../dialog/animated_custom_dialog.dart';
import '../../../../dialog/my_dialog.dart';

class ViewVehicles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewVehiclesState();
  }
}

class ViewVehiclesState extends State<ViewVehicles> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  AuthProvider authProvider = locator<AuthProvider>();
  // String bikeUrl =
  //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfhkUqt9FG5T4pAS3UBtUzbfE0qMbw705H0A&s";
  // String carUrl =
  //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVnTrFgtjMVR7Uc68QgxHyd1_JduIgW76nSQ&s";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vehicleProvider.getAllVehicleListByUserIdnew(id: authProvider.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    // vehicleProvider.getAllVehicleListByUserId(id: authProvider.user!.id);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWithAction(
        context,
        _scaffoldKey,
        "Vehicle Details",
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVehicleInfo(isdashboard: true),
            ),
          );
        },
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, model, child) => Container(
          padding: EdgeInsets.all(10),
          child: model.vehicleListNew.length == 0
              ? Center(child: Text("No Vehicle Added", style: TextStyle()))
              : ListView.builder(
                  itemCount: model.vehicleListNew.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ---------- HEADER ----------
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    model.vehicleListNew[index].name ??
                                        "Vehicle",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (builder) => EditVehicleInfo(
                                          model.vehicleListNew[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                        title: const Text(
                                          'Delete Vehicle',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: const Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'Are you sure you want to delete this vehicle? This action cannot be undone.',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(
                                                context,
                                              ).pop(); // close confirmation dialog

                                              final success = await model
                                                  .deleteVehicle(
                                                    model
                                                        .vehicleListNew[index]
                                                        .id
                                                        .toString(),
                                                    index,
                                                  );

                                              if (!context.mounted) return;

                                              if (success) {
                                                showAnimatedDialog(
                                                  context,
                                                  MyDialog(
                                                    icon: Icons.check_circle,
                                                    title: 'Vehicle Deleted',
                                                    description:
                                                        'Your vehicle has been deleted successfully.',
                                                  ),
                                                  dismissible: true,
                                                );
                                              } else {
                                                showAnimatedDialog(
                                                  context,
                                                  MyDialog(
                                                    icon: Icons.error,
                                                    title: 'Delete Failed',
                                                    description:
                                                        'Unable to delete vehicle. Please try again later.',
                                                  ),
                                                  dismissible: true,
                                                );
                                              }
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('No'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// ---------- IMAGE ----------
                            Center(
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        model
                                                .vehicleListNew[index]
                                                .vehicletype!
                                                .name!
                                                .toString()
                                                .toLowerCase() ==
                                            'two wheeler'
                                        ? AssetImage(
                                            "assets/images/vehicle2.gif",
                                          )
                                        : AssetImage(
                                            "assets/images/vehicle.gif",
                                          ),
                                    // NetworkImage(
                                    //   model.vehicleListNew[index].photosUrl.toString() == ""
                                    //       ? model.vehicleListNew[index].vehicletype == null
                                    //           ? carUrl
                                    //           : model.vehicleListNew[index].vehicletype!.name ==
                                    //                   "Two Wheeler"
                                    //               ? bikeUrl
                                    //               : carUrl
                                    //       : model.vehicleListNew[index].photosUrl.toString(),
                                    // ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                            const Divider(),

                            /// ---------- DETAILS ----------
                            _infoRow(
                              "Vehicle Type",
                              model.vehicleListNew[index].vehicletype == null
                                  ? " - "
                                  : model
                                        .vehicleListNew[index]
                                        .vehicletype!
                                        .name!,
                            ),
                            _infoRow(
                              "Vehicle Model",
                              model.vehicleListNew[index].vehicleModel,
                            ),
                            _infoRow(
                              "Manufacturer",
                              model.vehicleListNew[index].vehicleManufacturer ==
                                      null
                                  ? " - "
                                  : model
                                        .vehicleListNew[index]
                                        .vehicleManufacturer!
                                        .name!,
                            ),
                            _infoRow(
                              "Fuel Type",
                              model.vehicleListNew[index].fueltype == null
                                  ? " - "
                                  : model.vehicleListNew[index].fueltype!.name,
                            ),
                            _infoRow(
                              "Registration No",
                              model.vehicleListNew[index].registrationNo,
                              valueColor: Colors.green,
                            ),
                            _infoRow(
                              "Manufacturing Year",
                              model.vehicleListNew[index].yearOfManufacturing
                                  .toString(),
                              valueColor: Colors.green,
                            ),
                            _infoRow(
                              "Last Service Date",
                              model.vehicleListNew[index].lastServiceDate
                                  .toString(),
                              valueColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String? value, {
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value ?? " - ",
              style: TextStyle(
                fontSize: 13,
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
