import 'dart:io';
import 'dart:typed_data';

import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/user_table_model.dart';
import 'package:carcheks/model/vehicle_manufacturer_model.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/fuel_provider.dart';
import 'package:carcheks/provider/img_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/DateTimePickerDialog.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/custom_dropdown_list.dart';
import 'package:carcheks/view/base_widgets/custom_textfield.dart';
import 'package:carcheks/view/base_widgets/loader.dart';
import 'package:carcheks/view/base_widgets/registration_text_field.dart';
import 'package:carcheks/view/screens/customer/customer_dashboard.dart';
import 'package:carcheks/view/screens/customer/vehicle/view_vehicles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../../base_widgets/Custom_Vehicle_dialog.dart';
import '../../../base_widgets/box_button.dart';
import '../../../base_widgets/cutom_city_textfield.dart';

class AddVehicleInfo extends StatefulWidget {
  bool isdashboard;
  AddVehicleInfo({required this.isdashboard});

  @override
  _AddVehicleInfoState createState() => _AddVehicleInfoState();
}

class _AddVehicleInfoState extends State<AddVehicleInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController rnoController = TextEditingController();
  TextEditingController noOfServicingController = TextEditingController();
  TextEditingController avgController = TextEditingController();
  TextEditingController kmRunController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController lastServiceDateController = TextEditingController();
  Vehicle? vehicle;
  Vehicletype? vehicleType;
  VehicleManufacturer? vehicleManufacturer;
  FuelType? fuelType;
  String selectedFuelType = '';
  User? user;
  List<String> yearList = <String>[
    '2025',
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000',
  ];

  String selectedYear = '';
  String selectedVehicleType = '';
  int selectedVehicaleTypeIndex = 0;
  String selectedVehicleCompany = '';
  String selectedModel = '';
  FuelProvider fuelTypeProvider = locator<FuelProvider>();
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  ImgProvider imgProvider = locator<ImgProvider>();
  final now = DateTime.now();
  String formatter = '';
  bool isloading = false;
  final formKey = GlobalKey<FormState>();

  pickProfilePic(ImgProvider model) async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      try {
        fileName = result.files.first.name;
        print(result.files.first.toString());
        //imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        objFile = result.files.single;
        print(fileName);
        model.setImage(fileName ?? "");
        vehicleImage = '';
        vehicleImage = await model.uploadImage("0",
            imageBytes: imageBytes, objectFile: objFile);
        //debugPrint("service img::"+vehicleImage!);
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    formatter = DateFormat('yMd').format(now);
    user = authProvider.user;
    vehicleProvider.callApi();

    getData();
    fuelTypeProvider.getAllFuelType();
    vehicleProvider.getAllVehicle();
    vehicleProvider.getAllVehicleManufacture();
    vehicleProvider.getAllVehicleType();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setEmptyValue();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Add Vehicle"),
      body: Consumer<VehicleProvider>(
        builder: (context, model, child) => model.isLoadData == true
            ? Center(
                child: Container(
                  child: const CircularProgressIndicator(),
                ),
              )
            : Form(
                key: formKey,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*  Text(
                      "Add Vehicle Photo",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  Consumer<ImgProvider>(
                    builder: (context, model, child) => Container(
                      height:100,
                      padding: EdgeInsets.only(bottom: 16.0),
                      margin: EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(model.uploaded_image.toString())
                          ),
                          border: Border.all()),
                      child: GestureDetector(
                          onTap: (){
                            img==null?pickProfilePic(model):img=null;
                          },
                          child: Icon(img == null?Icons.add:Icons.delete, size: 30)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),*/
                        const Text(
                          "Select Vehicle Manufacturing Year",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomDropdownList(
                          hintText: "Select Manufacturing Year",
                          items: yearList,
                          selectedType: selectedYear,
                          onChange: (String value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Select Your Vehicle Type",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomDropdownList(
                          hintText: "Select Vehicle Type",
                          items: model.vehicleTypeNameList,
                          selectedType: selectedVehicleType,
                          onChange: (String value) {
                            setState(() {
                              selectedVehicleType = value;
                              vehicleType = model.getSelectedVehicleTypeId(
                                  selectedVehicleType);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Select Your Vehicle Company",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomDropdownList(
                          hintText: "Select Vehicle",
                          items: model.vehicleManufacturerNameList,
                          selectedType: selectedVehicleCompany,
                          onChange: (String value) {
                            setState(() {
                              selectedVehicleCompany = value;
                              vehicleManufacturer =
                                  model.getSelectedVehicleManufacturerId(
                                      selectedVehicleCompany)!;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Select Your Vehicle Model",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: vehicleModelController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Vehicle Model',
                                border: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Vehicle Registration Number",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: rnoController,
                              keyboardType: TextInputType.text,
                              validator:
                                  Validators.required('This field is required'),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Registration Number',
                                border: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Kilometer Run",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: kmRunController,
                              //keyboardType: TextInputType.text,
                              //validator: Validators.required('This field is required'),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Kilometer Run',
                                border: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Vehicle Average",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: avgController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Average Run',
                                border: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Number of Service Done",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: noOfServicingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Number Of Servicing',
                                border: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Last Servicing Date",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: TextFormField(
                              readOnly: true,
                              onTap: () async {
                                String selectedDate =
                                    await DateTimePickerDialog()
                                        .pickBeforeDateDialog(context);
                                if (selectedDate == null) {
                                  selectedDate = "Select From Date";
                                } else {
                                  lastServiceDateController.text = selectedDate;
                                }
                                setState(() {});
                              },
                              controller: lastServiceDateController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Last Service Date',
                                border: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Consumer<VehicleProvider>(
        builder: (context, provider, child) {
          return provider.isLoadData == true
              ? Container(
                  height: 20,
                )
              : Container(
                  //  width: MediaQuery.of(context).size.width,

                  child: isloading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                        )
                      : BoxButton(
                          buttonText: 'Continue',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                  title: const Text(
                                      'Are you sure you want to add this vehicle?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Yes", style: Style.okButton),
                                      onPressed: () async {
                                        Navigator.of(context)
                                            .pop(); // Close the confirmation dialog
                                        setState(() =>
                                            isloading = true); // Start loader

                                        final result =
                                            await vehicleProvider.addVehicle(
                                          userId: user!.id,
                                          active: true,
                                          created: formatter,
                                          created_by:
                                              authProvider.user!.firstName,
                                          updated: formatter,
                                          updated_by:
                                              authProvider.user!.firstName,
                                          name: vehicleModelController.text,
                                          image_url: vehicleImage,
                                          last_servecing_date:
                                              lastServiceDateController.text,
                                          year: selectedYear,
                                          vehicle_model:
                                              vehicleModelController.text,
                                          regNumber: rnoController.text,
                                          avgRun: avgController.text,
                                          kiloMeterRun: kmRunController.text,
                                          no_Of_servecing:
                                              noOfServicingController.text,
                                          vehicleType: vehicleType,
                                          vehicleManufacturer:
                                              vehicleManufacturer,
                                        );

                                        setState(() =>
                                            isloading = false); // Stop loader

                                        if (result != null) {
                                          provider.getAllVehicleListByUserIdnew(
                                              id: user!.id);

                                          // Show success dialog
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title:
                                                  const Text('Vehicle Added'),
                                              content: const Text(
                                                  'Your vehicle has been added successfully.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    if (widget.isdashboard) {
                                                      Navigator.of(context)
                                                          .pop(); // Close dialog
                                                      Navigator.of(context)
                                                          .pop(); // Close form
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop(); // Close dialog
                                                      Navigator.of(context)
                                                          .pop(); // Close form
                                                      Navigator.of(context)
                                                          .pop(); // Go back
                                                    }
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Something went wrong'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    TextButton(
                                      child:
                                          Text("No", style: Style.cancelButton),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                );
        },
      ),
    );
  }

  PlatformFile? objFile;
  TextEditingController photoController = TextEditingController();
  final authProvider = locator<AuthProvider>();
  File? imagefile;
  Uint8List? imageBytes;
  String? fileName, img;
  String? vehicleImage;
  final _formKey = GlobalKey<FormState>();

  pickFile(VehicleProvider model) async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
      });
      try {
        fileName = result.files.first.name;
        print(result.files.first.toString());
        imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        print(fileName);
        photoController.text = fileName!;
        model.setImage(fileName);
        img = await imgProvider.uploadImage("0",
            imageBytes: imageBytes, objectFile: objFile);
        debugPrint("IMG::" + img!);
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  setEmptyValue() {
    setState(() {
      rnoController.text = '';
      avgController.text = '';
      photoController.text = '';
      kmRunController.text = '';
      lastServiceDateController.text = '';
      vehicleNameController.text = '';
      vehicleModelController.text = '';
      noOfServicingController.text = '';
      isloading = false;
    });
  }

  Future<void> getData() async {
    await authProvider.getUserDetails();
  }
}
