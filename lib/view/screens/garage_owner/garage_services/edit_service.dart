import 'dart:io';
import 'dart:typed_data';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../locator.dart';
import '../../../../model/appointment_model.dart';
import '../../../../model/fuel_type_model.dart';
import '../../../../model/services.dart';
import '../../../../model/subservices_model.dart';
import '../../../../model/vehicle_type_model.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/garage_provider.dart';
import '../../../../provider/img_provider.dart';
import '../../../../provider/services_provider.dart';
import '../../../../provider/vehicle_provider.dart';
import '../../../../util/color-resource.dart';
import '../../../../util/style.dart';
import '../../../base_widgets/Custom_Vehicle_dialog.dart';
import '../../../base_widgets/box_button.dart';
import '../../../base_widgets/cutom_city_textfield.dart';

class EditService extends StatefulWidget {

  EditService({required this.garageId, required this.mainserviceId});

  final GarageService mainserviceId;
  final int garageId;


  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {

  TextEditingController addinfoController =  TextEditingController();
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
  int selectedVehicaleTypeIndex=0;


  @override
  void initState() {
//    garageProvider.getAllGarageSubServicesGarage(garageId: garageProvider.ownGarageList[0].id,mainserviceId: widget.mainserviceId);
    getData();
    getGarageServicesData();
    formatter = DateFormat('yMd').format(now);
    serviceProvider.getSubServicesByServiceId(serviceId: widget.mainserviceId.id);
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
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,size: 30,)),
          title: Text("Update Garage Service",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),)
      ),
      body: SingleChildScrollView(
        child: Container(
          color: ColorResources.WHITE,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height-150,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Align(alignment: Alignment.center, child: Text(widget.mainService.name.toString(), style: TextStyle( fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black))),
                        SizedBox(height: 15,),
                       /* Text("Select SubServices Type"),
                        SizedBox(height: 5,),
                        Consumer<ServiceProvider>(
                          builder: (context, model, child) =>Container(
                              child: FormBuilderDropdown(
                                  name: "",
                                  allowClear: false,
                                  isDense: false ,

                                  decoration: InputDecoration.collapsed(
                                    hintText: '',
                                    filled: true,
                                    border:OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(5.0),
                                        borderSide: BorderSide.none
                                    ),
                                  ),
                                  hint: Container(
                                    height: 60,
                                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                                    child: Text(
                                      "Select Service",
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose(
                                      [FormBuilderValidators.required(context)]),
                                  items: model.subServicesNameList
                                      .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                                      child: Text(
                                        '$value',
                                        // style: Style.dropdownValue,
                                      ),
                                    ),
                                  )
                                  )
                                      .toList(),
                                  onChanged: (String? value) {
                                    selectedSubServicesController.text = value!;
                                    subService = model.getSelectedGarageServiceId(selectedSubServicesController.text);
                                  })
                          ),
                        ),
                        SizedBox(height: 10,),*/
                        Text("Sub Service Type"),

                        SizedBox(height: 5,),
                        Container(
                          //width: 100,
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: TextField(
                            readOnly: true,
                            maxLines: 1,
                            controller: selectedSubServicesController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                            ),

                          ),
                        ),
                        // Text(),

                        SizedBox(height: 10,),
                        Text("Add Image"),
                        SizedBox(height: 10,),
                        Consumer<ImgProvider>(
                          builder: (context, model, child) => Container(
                            height:100,
                            padding: EdgeInsets.only(bottom: 16.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(img==null?model.uploadedImage:img.toString())
                                ),
                                border: Border.all()),
                            child: GestureDetector(
                                onTap: (){
                                  img==null?pickProfilePic(model):img=null;
                                },
                                child: Icon(img == null?Icons.add:Icons.delete, size: 30)),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Add Description"),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: TextField(
                            maxLines: 5,
                            controller: addinfoController,
                            decoration: InputDecoration(
                              hintText: "Service Details!",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Text("Price"),
                        SizedBox(height: 10,),
                        Container(
                          //width: 100,
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: TextField(
                            maxLines: 1,
                            controller: priceController,
                            decoration: InputDecoration(
                              hintText: "\$",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                            ),
                          ),
                        ),
                        Text("Select Vehicle Type"),
                        SizedBox(height: 10,),

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
                                          selectedVehicleType = vehicleProvider.vehicleTypeList[value].name!;
                                        });
                                      }
                                  );
                                }
                            ) ;

                          },
                        ),



                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar:  Consumer<GarageProvider>(
        builder: (context, model, child) => model.isLoading==true?Container():Container(
          color: Colors.white,
          child: BoxButton(
            buttonText: "Update",
            onTap: (){
              showDialog(
                  context: context,
                  builder: (_) =>
                      CupertinoAlertDialog(
                        title: const Text(
                          'Are you sure want to update service?',
                          // style: Style.heading,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                                "Yes",
                                style: Style.okButton),
                            onPressed: () {
                              model.updateGarageService(
                                active: true,
                                subServiceId: [widget.mainserviceId.subService!.id],
                                id: widget.mainserviceId.id,
                                description: addinfoController.text,
                                cost: priceController.text,
                                created: formatter,
                                created_by: authProvider.user!.firstName,
                                garageId:widget.mainserviceId.garage!.id,

                                image_url: img,
                                // serviceId:widget.mainService.id,
                                short_desc: addinfoController.text,

                                serviceId: widget.mainserviceId.mainService!.id,
                                updated: formatter,
                                updated_by: authProvider.user!.firstName,
                                userId:authProvider.user!.id,
                                vehicletype: vehicleType,
                                //addressId: garageProvider.ownGarageList[0].addressId,
                              ).then((value) => {
                                print(value),
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Done'),
                                        content: Text('Services Updated Successfuly'),
                                        actions: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: BoxButton(onTap: (){
                                                int count = 0;
                                                Navigator.of(context).popUntil((_) => count++ >= 2);
                                              }, buttonText: 'OK',

                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                              }

                              );
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                                "No",
                                style:
                                Style.cancelButton
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
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
  String? img ,ProfilePic;
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
        model.setImage(fileName??'');
        img = '';
        img = await model.uploadImage("0",
            imageBytes: imageBytes,
            objectFile: objFile);
        debugPrint("service img::"+img!);
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  Garage? garage;
  void getData() async{
    await garageProvider.getGarageByUserId(authProvider.user!.id);
    //debugPrint(garage!.name.toString());
  }

  void getGarageServicesData()async{


   /*// await garageProvider.getAllGarageSubServicesGarage(garageId: garageProvider.ownGarageList[0].id,mainserviceId: widget.mainserviceId);

    priceController.text= garageProvider.listSubServicesGarage[0].cost!.toString();
    addinfoController.text= garageProvider.listSubServicesGarage[0].discribtion.toString();
    selectedSubServicesController.text =garageProvider.listSubServicesGarage[0].subService!.name.toString();
    subService = serviceProvider.getSelectedGarageServiceId(selectedSubServicesController.text);*/

    selectedVehicleType = widget.mainserviceId.vechicletypeid!.name!;
    vehicleType = widget.mainserviceId.vechicletypeid;
    print("Selected Vehicle Type : "+selectedVehicleType);
    priceController.text= widget.mainserviceId.cost.toString();
    addinfoController.text= widget.mainserviceId.discribtion.toString();
    selectedSubServicesController.text =widget.mainserviceId.subService!.name.toString();
    subService = serviceProvider.getSelectedGarageServiceId(selectedSubServicesController.text);
    img = widget.mainserviceId.photosUrl;
    print("Vehicle Type : "+vehicleType!.id.toString());

  }

}
