import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:carcheks/locator.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/img_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/util/Snackbar.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_dropdown_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../../base_widgets/box_button.dart';

TextEditingController imgController = TextEditingController();

class AddServices extends StatefulWidget {
  MainService mainService;
  AddServices(this.mainService);

  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  TextEditingController addinfoController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController selectedSubServicesController = TextEditingController();

  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  String selectedVehicleType = '';
  Vehicletype? vehicleType;
  SubService? subService;
  FuelType? fuelType;
  String selectedFuelType = '';
  ServiceProvider serviceProvider = locator<ServiceProvider>();
  AuthProvider authProvider = locator<AuthProvider>();
  GarageProvider garageProvider = locator<GarageProvider>();

  final now = DateTime.now();
  String formatter = '';
  int selectedVehicaleTypeIndex = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getData();

    formatter = DateFormat('yMd').format(now);
    serviceProvider.getSubServicesByServiceId(serviceId: widget.mainService.id);
    garageProvider.getGarageByUserId(authProvider.user!.id);
    vehicleProvider.getAllVehicleType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorResources.PRIMARY_COLOR,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          widget.mainService.name.toString().toUpperCase(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          color: ColorResources.WHITE,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Align(alignment: Alignment.center, child: Text(widget.mainService.name.toString(), style: TextStyle( fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black))),
                      const SizedBox(height: 15),
                      const Text("Select SubServices Type"),
                      const SizedBox(height: 5),

                      Consumer<ServiceProvider>(
                        builder: (context, model, child) => Container(
                          child: FormBuilderDropdown(
                            name: "",
                            //allowClear: false,
                            isDense: false,
                            validator: Validators.required(
                              'This field is required',
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: '',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            disabledHint: Container(
                              // height: 60,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 15,
                              ),
                              child: const Text("Select Service"),
                            ),
                            /*validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required(context)]),*/
                            items: model.subServicesNameList
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Container(
                                      // height: 60,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        '$value',
                                        // style: Style.dropdownValue,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              selectedSubServicesController.text = value!;
                              subService = model.getSelectedGarageServiceId(
                                selectedSubServicesController.text,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Text("Add Image"),
                      const SizedBox(height: 10),
                      Consumer<ImgProvider>(
                        builder: (context, model, child) => Container(
                          height: 100,
                          padding: const EdgeInsets.only(bottom: 16.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                img == null
                                    ? ''
                                    : model.uploadedImage.toString(),
                              ),
                            ),
                            border: Border.all(),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              img == null ? pickProfilePic(model) : img = null;
                            },
                            child: Icon(
                              img == null ? Icons.add : Icons.delete,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Add Description"),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          maxLines: 5,
                          controller: addinfoController,
                          decoration: const InputDecoration(
                            hintText: "Service Details!",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const Text("Price"),
                      const SizedBox(height: 10),
                      Container(
                        //width: 100,
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          validator: Validators.required(
                            'This field is required',
                          ),
                          controller: priceController,
                          decoration: const InputDecoration(
                            hintText: "\$",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const Text("Select Vehicle Type"),
                      const SizedBox(height: 10),

                      Consumer<VehicleProvider>(
                        builder: (context, model, child) => CustomDropdownList(
                          hintText: "Select Vehicle Type",
                          items: model.vehicleTypeNameList,
                          selectedType: selectedVehicleType,
                          onChange: (String value) {
                            setState(() {
                              selectedVehicleType = value;
                              vehicleType = vehicleProvider
                                  .getSelectedVehicleTypeId(
                                    selectedVehicleType,
                                  );
                            });
                          },
                        ),
                      ),
                      /*CustomCityTextField(
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
                                        selectedVehicleType = vehicleProvider.vehicleTypeList[value].name!;
                                      });
                                    }
                                );
                              }
                          ) ;

                        },
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<GarageProvider>(
        builder: (context, model, child) => model.isLoading == true
            ? Container()
            : Container(
                color: Colors.white,
                child: BoxButton(
                  buttonText: "Add",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: const Text(
                            'Are you sure want to add service?',
                            // style: Style.heading,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Yes", style: Style.okButton),
                              onPressed: () async {
                                var result = await model.addGarageService(
                                  active: true,
                                  created: formatter,
                                  created_by: authProvider.user!.firstName,
                                  cost: priceController.text,
                                  image_url: img,
                                  description: addinfoController.text,
                                  short_desc: addinfoController.text,
                                  subServiceId: [subService!.id],
                                  serviceId: widget.mainService.id,
                                  userId: authProvider.user!.id,
                                  garageId: garageProvider.ownGarageList[0].id,
                                  vehicletype: vehicleType,
                                  addressId:
                                      garageProvider.ownGarageList[0].addressId,
                                  updated: formatter,
                                  updated_by: authProvider.user!.firstName,
                                );
                                if (result['data'] == null) {
                                  showSnackBar(context, result['message']);
                                  Navigator.of(context).pop();
                                } else {
                                  showSnackBar(
                                    context,
                                    "service added successfully",
                                  );
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            TextButton(
                              child: Text("No", style: Style.cancelButton),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
      ),
    );
  }

  PlatformFile? objFile;
  File? imagefile;
  Uint8List? imageBytes;
  String? fileName;
  String? img, ProfilePic;
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
        img = '';
        img = await model.uploadImage(
          "0",
          imageBytes: imageBytes,
          objectFile: objFile,
        );
        debugPrint("service img::" + img!);
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  Garage? garage;
  void getData() async {
    await garageProvider.getGarageByUserId(authProvider.user!.id);
    //debugPrint(garage!.name.toString());
  }
}
