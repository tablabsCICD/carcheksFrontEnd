import 'dart:io';
import 'dart:typed_data';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/fuel_type_model.dart';
import 'package:carcheks/model/user_table_model.dart';
import 'package:carcheks/model/vehicle_manufacturer_model.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/model/vehicle_type_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/fuel_provider.dart';
import 'package:carcheks/provider/img_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/util/DateTimePickerDialog.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/custom_dropdown_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class AddVehicleInfo extends StatefulWidget {
  bool isdashboard;
  AddVehicleInfo({required this.isdashboard});

  @override
  _AddVehicleInfoState createState() => _AddVehicleInfoState();
}

class _AddVehicleInfoState extends State<AddVehicleInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFormValid = false;

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
  User? user;

  String selectedFuelType = '';
  String selectedYear = '';
  String selectedVehicleType = '';
  String selectedVehicleCompany = '';
  String selectedModel = '';

  List<String> yearList = [
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

  FuelProvider fuelTypeProvider = locator<FuelProvider>();
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  ImgProvider imgProvider = locator<ImgProvider>();
  final authProvider = locator<AuthProvider>();

  final now = DateTime.now();
  String formatter = '';
  bool isloading = false;

  final formKey = GlobalKey<FormState>();

  PlatformFile? objFile;
  TextEditingController photoController = TextEditingController();
  File? imagefile;
  Uint8List? imageBytes;
  String? fileName, img, vehicleImage;

  @override
  void initState() {
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
    setEmptyValue();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Add Vehicle"),
      body: Consumer<VehicleProvider>(
        builder: (context, model, child) {
          if (model.isLoadData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Select Vehicle Manufacturing Year"),
                  CustomDropdownList(
                    hintText: "Select Manufacturing Year",
                    items: yearList,
                    selectedType: selectedYear,
                    onChange: (v) {
                      setState(() => selectedYear = v);
                    },
                  ),

                  _gap(),
                  _title("Select Your Vehicle Type"),
                  CustomDropdownList(
                    hintText: "Select Vehicle Type",
                    items: model.vehicleTypeNameList,
                    selectedType: selectedVehicleType,
                    onChange: (v) {
                      setState(() {
                        selectedVehicleType = v;
                        vehicleType = model.getSelectedVehicleTypeId(v);
                      });
                    },
                  ),

                  _gap(),
                  _title("Select Your Vehicle Company"),
                  CustomDropdownList(
                    hintText: "Select Vehicle",
                    items: model.vehicleManufacturerNameList,
                    selectedType: selectedVehicleCompany,
                    onChange: (v) {
                      setState(() {
                        selectedVehicleCompany = v;
                        vehicleManufacturer = model
                            .getSelectedVehicleManufacturerId(v);
                      });
                    },
                  ),

                  _gap(),
                  _title("Vehicle Registration Number"),
                  _textField(
                    rnoController,
                    "Registration Number",
                    validator: Validators.required('This field is required'),
                  ),

                  _gap(),
                  _title("Select Your Vehicle Model"),
                  _textField(vehicleModelController, "Vehicle Model"),

                  _gap(),
                  _title("Kilometer Run"),
                  _textField(
                    kmRunController,
                    "Kilometer Run",
                    keyboard: TextInputType.number,
                  ),

                  _gap(),
                  _title("Vehicle Average"),
                  _textField(
                    avgController,
                    "Average Run",
                    keyboard: TextInputType.number,
                  ),

                  _gap(),
                  _title("Number of Service Done"),
                  _textField(
                    noOfServicingController,
                    "Number Of Servicing",
                    keyboard: TextInputType.number,
                  ),

                  _gap(),
                  _title("Last Servicing Date"),
                  _dateField(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isloading
              ? const SizedBox(
                  height: 48,
                  child: Center(child: CircularProgressIndicator()),
                )
              : CustomButton(
                  buttonText: 'Continue',
                  isEnable: isFormValid && !isloading,
                  onTap: _onSubmit,
                ),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    ),
  );

  Widget _gap() => const SizedBox(height: 20);

  Widget _textField(
    TextEditingController c,
    String hint, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          controller: c,
          keyboardType: keyboard,
          validator: validator,
          onChanged: (_) => _checkFormValidity(),
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
    );
  }

  Widget _dateField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          readOnly: true,
          controller: lastServiceDateController,
          onTap: () async {
            String selectedDate = await DateTimePickerDialog()
                .pickBeforeDateDialog(context);
            if (selectedDate.isNotEmpty) {
              lastServiceDateController.text = selectedDate;
              _checkFormValidity();
            }
          },
          decoration: const InputDecoration(
            hintText: 'Last Service Date',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
    );
  }

  void _checkFormValidity() {
    final isValid = formKey.currentState?.validate() ?? false;
    final dropdownValid =
        selectedYear.isNotEmpty &&
        selectedVehicleType.isNotEmpty &&
        selectedVehicleCompany.isNotEmpty;

    setState(() => isFormValid = isValid && dropdownValid);
  }

  void _onSubmit() async {
    if (!isFormValid) return;

    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Are you sure you want to add this vehicle?'),
          actions: [
            TextButton(
              child: Text("Yes", style: Style.okButton),
              onPressed: () async {
                Navigator.pop(context);
                setState(() => isloading = true);

                final result = await vehicleProvider.addVehicle(
                  userId: user!.id,
                  active: true,
                  created: formatter,
                  created_by: authProvider.user!.firstName,
                  updated: formatter,
                  updated_by: authProvider.user!.firstName,
                  name: vehicleModelController.text,
                  image_url: vehicleImage,
                  last_servecing_date: lastServiceDateController.text,
                  year: selectedYear,
                  vehicle_model: vehicleModelController.text,
                  regNumber: rnoController.text,
                  avgRun: avgController.text,
                  kiloMeterRun: kmRunController.text,
                  no_Of_servecing: noOfServicingController.text,
                  vehicleType: vehicleType,
                  vehicleManufacturer: vehicleManufacturer,
                );

                setState(() => isloading = false);

                if (result != null) {
                  vehicleProvider.getAllVehicleListByUserIdnew(id: user!.id);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Vehicle Added'),
                      content: const Text(
                        'Your vehicle has been added successfully.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (widget.isdashboard) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Something went wrong'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            TextButton(
              child: Text("No", style: Style.cancelButton),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void setEmptyValue() {
    rnoController.clear();
    avgController.clear();
    photoController.clear();
    kmRunController.clear();
    lastServiceDateController.clear();
    vehicleNameController.clear();
    vehicleModelController.clear();
    noOfServicingController.clear();
    isloading = false;
  }

  Future<void> getData() async {
    await authProvider.getUserDetails();
  }
}
