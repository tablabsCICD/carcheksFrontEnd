import 'dart:io';
import 'dart:typed_data';

import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/user_table_model.dart';
import 'package:carcheks/model/vehicale_model_new.dart';
import 'package:carcheks/model/vehicle_manufacturer_model.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/fuel_provider.dart';
import 'package:carcheks/provider/img_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/route/app_routes.dart';
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

import '../../../base_widgets/Custom_Vehicle_dialog.dart';
import '../../../base_widgets/box_button.dart';
import '../../../base_widgets/cutom_city_textfield.dart';

class EditVehicleInfo extends StatefulWidget {
  Vehicle? vehicle;
    EditVehicleInfo(this.vehicle);

  @override
  _EditVehicleInfoState createState() => _EditVehicleInfoState();
}

class _EditVehicleInfoState extends State<EditVehicleInfo> {
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
  FuelType? fuelType ;
  String selectedFuelType = '';
  User? user;
  List<String> yearList = <String>[
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
  int selectedVehicaleTypeIndex=0;
  String selectedVehicleCompany = '';
  String selectedModel = '';
  FuelProvider fuelTypeProvider = locator<FuelProvider>();
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  ImgProvider imgProvider = locator<ImgProvider>();
  final now = DateTime.now();
  String formatter = '';
  bool isloading = false;

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
        model.setImage(fileName??"");
        vehicleImage = '';
        vehicleImage = await model.uploadImage("0",
            imageBytes: imageBytes,
            objectFile: objFile);
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
    // fuelTypeProvider.getAllFuelType();
    // vehicleProvider.getAllVehicle();
    // vehicleProvider.getAllVehicleManufacture();
    // vehicleProvider.getAllVehicleType();

    vehicleProvider.callApi();

    getData();
    fuelTypeProvider.getAllFuelType();
    vehicleProvider.getAllVehicle();
    vehicleProvider.getAllVehicleManufacture();
    vehicleProvider.getAllVehicleType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: CustomAppBarWidget(
          context, _scaffoldKey, "Edit Vehicle"),
      body: Consumer<VehicleProvider>(
        builder: (context, model, child) => model.isLoadData==true?Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ) :Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                            image: NetworkImage(model.uploadedImage.toString())
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
                ),
                /*Text(
                  "Select Vehicle Manufacturing Year",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Select Your Vehicle Type",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomCityTextField(
                  hintText: 'Select Vehicle Type',
                  controller: selectedVehicleType,
                  onTap: (){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomVehicleTypeDialog(
                              onTap : (int value){
                                setState(() {
                                  selectedVehicaleTypeIndex=value;
                                  vehicleType=vehicleProvider.vehicleTypeList[value];
                                  selectedVehicleType = vehicleProvider.vehicleTypeList[value].name;
                                });
                              }
                          );
                        }
                    ) ;

                  },
                ),
                CustomDropdownList(
                  hintText: "Select Vehicle Type",
                  items: model.vehicleTypeNameList,
                  selectedType: selectedVehicleType,
                  onChange: (String value) {
                    setState(() {
                      selectedVehicleType = value;
                      vehicleType =
                          model.getSelectedVehicleTypeId(selectedVehicleType);
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Select Your Vehicle Company",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
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
                ),*/
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Select Your Vehicle Model",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                /*CustomDropdownList(
                  hintText: "Select Vehicle Model",
                  items: model.vehicleManufacturerNameList,
                  selectedType: selectedModel,
                  onChange: (String value) {
                    setState(() {
                      selectedModel = value;
                    });
                  },
                )*/Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
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
                SizedBox(
                  height: 20,
                ),
               /* Text(
                  "Vehicle Name",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: vehicleNameController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Vehicle Name',
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,),*/
                Text(
                  "Vehicle Registration Number",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: rnoController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Registration Number',
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
               /* Text(
                  "Kilometer Run",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),

                  ),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: kmRunController,
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Vehicle Average",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Number of Serving Done",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
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
                SizedBox(
                  height: 20,
                ),*/
                const Text(
                  "Last Service Date",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    child: TextFormField(
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
                SizedBox(
                  height: 20,
                ),
                // Text(
                //   "Add Vehicle Photo",
                //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(4),
                //   ),
                //   child: Container(
                //     height: 50,
                //     padding: EdgeInsets.only(left: 10),
                //     alignment: Alignment.center,
                //     child: TextFormField(
                //       onTap: () {
                //         pickFile(model);
                //       },
                //       controller: photoController,
                //       decoration: InputDecoration.collapsed(
                //         hintText: 'Click here to add vehicle photo',
                //         border: OutlineInputBorder(
                //             borderRadius: new BorderRadius.circular(0),
                //             borderSide: BorderSide.none),
                //       ),
                //     ),
                //   ),
                // ),


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer<VehicleProvider>(
        builder: (context, provider, child) {
          return provider.isLoadData==true?Container(height: 20,) :Container(
            //  width: MediaQuery.of(context).size.width,

            child: BoxButton(
              buttonText: 'Continue',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: const Text(
                        'Are you sure want to edit vehicle info?',
                        // style: Style.heading,
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Yes", style: Style.okButton),
                          onPressed: () async {

                            getLoader(context, isloading);
                            var result = await vehicleProvider
                                .updateVehicle(
                              userId: user!.id,
                              vehicleId:widget.vehicle!.id,
                              active: true,
                              created: formatter,
                              created_by: authProvider
                                  .user!.firstName,
                              name: vehicleNameController.text,
                              image_url: vehicleImage==""?widget.vehicle!.photosUrl:vehicleImage,
                              last_servecing_date: lastServiceDateController.text,
                              year: widget.vehicle!.yearOfManufacturing,
                              vehicle_model: vehicleModelController.text,
                              regNumber: rnoController.text,
                              avgRun: avgController.text,
                              kiloMeterRun: kmRunController.text,
                              no_Of_servecing:
                              noOfServicingController.text,
                              /*fuelType: fuelTypeProvider
                            .allFuelTypeList[0],*/
                              vehicleType: widget.vehicle!.vehicletype,
                              vehicleManufacturer:
                              widget.vehicle!.vehicleManufacturer,
                              updated: formatter,
                              updated_by: authProvider
                                  .user!.firstName,
                            )
                                .then((value) => {
                              print(value),
                              dismissLoader(context),

                              showAnimatedDialog(
                                  context,
                                  MyDialog(
                                    icon: Icons.check,
                                    title: 'Vehicle',
                                    description:
                                    'Successfully edited vehicle',
                                    isFailed: false,
                                  ),
                                  dismissible: false,
                                  isFlip: false),
                              Navigator.pushReplacementNamed(context, AppRoutes.vehicle_details)
                              // Navigator.pushReplacementNamed(context, AppRoutes.vehicle_details)
                              /*Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    ViewVehicles()))*/
                            });

                            // Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child:
                          Text("No", style: Style.cancelButton),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
                //  Navigator.of(context).pop();
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
  String? fileName,img ;
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
            imageBytes: imageBytes,
            objectFile: objFile);
        debugPrint("IMG::"+img!);
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
    });
  }

  Future<void> getData() async {
    await authProvider.getUserDetails();
    setState(() {
      rnoController.text = widget.vehicle!.registrationNo.toString();
      avgController.text = '0';
      photoController.text = widget.vehicle!.photosUrl.toString();
      kmRunController.text = '0';
      lastServiceDateController.text = widget.vehicle!.lastServiceDate.toString();
      vehicleNameController.text = widget.vehicle!.name.toString();
      vehicleModelController.text = widget.vehicle!.vehicleModel.toString();
      noOfServicingController.text = '0';
    });
  }
}
