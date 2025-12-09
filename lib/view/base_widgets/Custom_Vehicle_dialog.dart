import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../../model/vehicle_model.dart';
import '../../model/vehicle_type_model.dart';
import '../../provider/vehicle_provider.dart';
import '../../util/api_constants.dart';
import '../../util/app_constants.dart';
import 'package:http/http.dart' as http;

class CustomVehicleTypeDialog extends StatefulWidget {
  Function onTap;
  CustomVehicleTypeDialog({required this.onTap});


  @override
  State<CustomVehicleTypeDialog> createState() => _CustomVehicleTypeDialogState();
}

class _CustomVehicleTypeDialogState extends State<CustomVehicleTypeDialog> {
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  List<dynamic> foundVehicletype = [];
  //List<dynamic> uniquFoundCity = [];
  List<dynamic> vehicletypeList = [];

  List<Vehicletype> vehicleList = [];
  List<String> vehicleNameList = [];


  getAllVehicleType() async {
    String myUrl = ApiConstants.BASE_URL +"/VehicleType/VehicleType/getAll";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));

      var response = json.decode(req.body);
      print("response$response");
   /* Map<String, dynamic> map = json.decode(req.body);
    List<dynamic> response = map["dataKey"];*/
    // var type = VehicleTypeModel.fromJson(response);

    var type = VehicleTypeModel.fromJson(response);
    print("responseType:$type");
    vehicleNameList.clear();
    vehicleList.clear();
    vehicleList.addAll(type.data);
    print("vehicleList:$vehicleList");
    vehicleList.forEach((element) {
      vehicleNameList.add(element.name!);
    });

      setState(() {
        vehicletypeList = vehicleNameList;
      });
      foundVehicletype = vehicletypeList.toSet().toList();
  }

  @override
  void initState() {

    getAllVehicleType();
    foundVehicletype = vehicletypeList..toSet().toList();
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = vehicletypeList;
    } else {
      results = vehicletypeList
          .where((user) =>
          user.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundVehicletype = results.toSet().toList();
      //  foundCity = uniquFoundCity;
    });
    print("VEHICLE LIST$foundVehicletype");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Vehicle Type'),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 500,
                width: 300,
                child: foundVehicletype.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: foundVehicletype.length,
                  itemBuilder: (context, index) =>
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              widget.onTap(index);
                              Navigator.of(context).pop();
                            },
                            title: Text(foundVehicletype[index]),
                          ),
                          Divider(),
                        ],
                      ),

                )
                    : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
