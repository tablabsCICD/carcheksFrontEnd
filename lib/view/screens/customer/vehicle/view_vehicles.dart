import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/route/app_routes.dart';
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
  String bikeUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfhkUqt9FG5T4pAS3UBtUzbfE0qMbw705H0A&s";
  String carUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVnTrFgtjMVR7Uc68QgxHyd1_JduIgW76nSQ&s";

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
      appBar:
          CustomAppBarWithAction(context, _scaffoldKey, "Vehicle Details", () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehicleInfo(
                    isdashboard: true,
                  )),
        );
      }),
      body: Consumer<VehicleProvider>(
        builder: (context, model, child) => Container(
          padding: EdgeInsets.all(10),
          child: model.vehicleListNew.length == 0
              ? Center(
                  child: Text(
                  "No Vehicle Added",
                  style: TextStyle(),
                ))
              : ListView.builder(
                  itemCount: model.vehicleListNew.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 7,
                      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  EditVehicleInfo(model
                                                      .vehicleListNew[index])));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.blue,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      //model.deleteVehicle(model.vehicleListByUserId[index].id, index);
                                      showDialog(
                                          context: context,
                                          builder: (_) =>
                                              new CupertinoAlertDialog(
                                                title: Text(
                                                    'Are you sure you want to delete this vehicle?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        model
                                                            .deleteVehicle(
                                                                model
                                                                    .vehicleListNew[
                                                                        index]
                                                                    .id,
                                                                index)
                                                            .then((value) => {
                                                                  showAnimatedDialog(
                                                                    context,
                                                                    MyDialog(
                                                                      icon: Icons
                                                                          .check,
                                                                      title:
                                                                          'Vehicle Delete',
                                                                      description:
                                                                          'Your vehicle deleted successfully!',
                                                                      //isFailed: false,
                                                                    ),
                                                                    dismissible:
                                                                        false,
                                                                  )
                                                                });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('yes')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('no'))
                                                ],
                                              ));
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                            Center(
                                child: Container(
                                    width: 200.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                        //shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(model
                                                        .vehicleListNew[index]
                                                        .photosUrl
                                                        .toString() ==
                                                    ""
                                                ? model.vehicleListNew[index]
                                                            .vehicletype ==
                                                        null
                                                    ? carUrl
                                                    : model
                                                                .vehicleListNew[
                                                                    index]
                                                                .vehicletype!
                                                                .name ==
                                                            "Two Wheeler"
                                                        ? bikeUrl
                                                        : carUrl
                                                : model.vehicleListNew[index]
                                                    .photosUrl
                                                    .toString()))))),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Vehicle Type: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text(model.vehicleListNew[index].vehicletype ==
                                        null
                                    ? " - "
                                    : model.vehicleListNew[index].vehicletype!
                                        .name!),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Vehicle Name: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text("${model.vehicleListNew[index].name}"),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Vehicle Model: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text(
                                    " ${model.vehicleListNew[index].vehicleModel}"),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Vehicle Manufacturer: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text(model.vehicleListNew[index]
                                            .vehicleManufacturer ==
                                        null
                                    ? " - "
                                    : model.vehicleListNew[index]
                                        .vehicleManufacturer!.name!),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Fuel Type: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text(
                                    model.vehicleListNew[index].fueltype == null
                                        ? " - "
                                        : model.vehicleListNew[index].fueltype!
                                            .name),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Vehicle Registration Number: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text(
                                  "${model.vehicleListNew[index].registrationNo}",
                                  style:
                                      TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Manufacturing Year: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text(
                                  "${model.vehicleListNew[index].yearOfManufacturing}",
                                  style:
                                      TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "Last Servicing date Year: ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Text(
                                  "${model.vehicleListNew[index].lastServiceDate}",
                                  style:
                                      TextStyle(color: Colors.green),
                                ),
                              ],
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
}
