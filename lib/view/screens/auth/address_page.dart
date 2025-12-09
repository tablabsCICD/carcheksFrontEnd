import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/CustomCityListDialog.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/cutom_city_textfield.dart';
import 'package:carcheks/view/base_widgets/registration_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController streetController = TextEditingController();
  TextEditingController subLocalityController = new TextEditingController();
  TextEditingController localityController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  final authProvider = locator<AuthProvider>();
  final addressProvider = locator<AddressProvider>();
  final now = DateTime.now();
  String formatter = '';

  String location = 'Null, Press Button';
  String Address = AppConstants.AddressCon;

  Future<Position> _getGeoLocationPosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    // Check permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied by user.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('Location permission permanently denied.');
    }

    // Permissions are granted, return current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Placemark? place;

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    place = placemarks[0];
    Address = AppConstants.AddressCon;
    // '${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.subAdministrativeArea}, ${place!.postalCode}, ${place!.country}';
    setState(() {});
  }

  getCurrentLocation() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);
  }

  setAddressValue() {
    print("Getting current user address");
    streetController.text = addressProvider.addressObj!.street.toString();
    localityController.text = addressProvider.addressObj!.houseName.toString();
    subLocalityController.text =
        addressProvider.addressObj!.landmark.toString();
    nameController.text = addressProvider.addressObj!.houseName.toString();
    zipCodeController.text = addressProvider.addressObj!.zipCode.toString();
    cityController.text = addressProvider.addressObj!.cityname.toString();
    stateController.text = addressProvider.addressObj!.state.toString();
    countryController.text = addressProvider.addressObj!.country.toString();
  }

  getData() async {
    int? id = await authProvider.getUserId();
    AddressClass? addressClass = await addressProvider.getAddressForUser(id!);
    addressClass != null
        ? setAddressValue()
        : showSimpleNotification(
            const Text(
              "Please Fill Address Details",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.black);
    ;
  }

  String? selectedCity = '';
  String? city_id;
  @override
  void initState() {
    getData();
    getCurrentLocation();
    formatter = DateFormat('yMd').format(now);
    setAddressValue();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Address Details"),
      body: SingleChildScrollView(
        child: Consumer<AddressProvider>(
          builder: (context, model, child) => model.isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 50),
                      child: InkWell(
                        child: Text(
                          "Use Current Location to fill All Address Details",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffea6935),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                    title: Text(
                                      'Are you sure want to use your current location to fill All Address Details?',
                                      style: Style.heading,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child:
                                            Text('Yes', style: Style.okButton),
                                        onPressed: () {
                                          streetController.text =
                                              place!.street!.toString();
                                          localityController.text =
                                              place!.locality!.toString();
                                          subLocalityController.text =
                                              place!.subLocality!.toString();
                                          nameController.text =
                                              place!.name!.toString();
                                          zipCodeController.text =
                                              place!.postalCode!.toString();
                                          cityController.text = place!
                                              .subAdministrativeArea!
                                              .toString();
                                          stateController.text = place!
                                              .administrativeArea!
                                              .toString();
                                          countryController.text =
                                              place!.country!.toString();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('No',
                                            style: Style.cancelButton),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ));
                        },
                      ),
                    ),
                    RegistrationTextFeild(
                      controller: streetController,
                      hintText: "Street Name",
                      textInputType: TextInputType.text,
                      iconData: Icons.apartment,
                    ),
                    RegistrationTextFeild(
                      controller: subLocalityController,
                      hintText: "Sub Locality",
                      textInputType: TextInputType.text,
                      iconData: Icons.location_pin,
                    ),
                    RegistrationTextFeild(
                        controller: localityController,
                        hintText: "Locality",
                        textInputType: TextInputType.text,
                        iconData: Icons.apartment),
                    Visibility(
                      visible: false,
                      child: CustomCityTextField(
                        hintText: 'Select City',
                        controller: selectedCity!,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomCityListDialog(
                                    onTap: (String value) {
                                  // city_id = model.getSelectedCityId(value);
                                  setState(() {
                                    selectedCity = value;
                                    city_id = model.getSelectedCityId(
                                        selectedCity.toString());
                                  });
                                });
                              });
                        },
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: RegistrationTextFeild(
                          controller: cityController,
                          hintText: "City",
                          textInputType: TextInputType.text,
                          iconData: Icons.location_city),
                    ),
                    RegistrationTextFeild(
                      controller: zipCodeController,
                      hintText: "Zip Code",
                      textInputType: TextInputType.number,
                      iconData: Icons.location_pin,
                    ),
                    /*                addressProvider.garageAddress==null?SizedBox.shrink():addressProvider.garageAddress!.garrageAddress?RegistrationTextFeild(
                  controller: stateController,
                  hintText: "State",
                  textInputType: TextInputType.text,
                  iconData: Icons.location_city):SizedBox(),
              model.garageAddress!.garrageAddress?RegistrationTextFeild(
                  controller: countryController,
                  hintText: "Country",
                  textInputType: TextInputType.text,
                  iconData: Icons.location_pin):SizedBox(),*/
                    CustomButton(
                        onTap: () async {
                          model
                              .updateAddress(
                                active: true,
                                id: addressProvider.addressObj!.id,
                                created: formatter,
                                created_by: authProvider.user!.firstName,
                                updated: formatter,
                                updated_by: authProvider.user!.firstName,
                                userId: authProvider.user!.id,
                                cityname: cityController.text == ""
                                    ? addressProvider.addressObj!.cityname
                                    : cityController.text,
                                state: stateController.text == ""
                                    ? addressProvider.addressObj!.state
                                    : stateController.text,
                                country: countryController.text == ""
                                    ? addressProvider.addressObj!.country
                                    : countryController.text,
                                garrageAddress: false,
                                houseName: localityController.text == ""
                                    ? addressProvider.addressObj!.houseName
                                    : localityController.text,
                                landmark: subLocalityController.text == ""
                                    ? addressProvider.addressObj!.landmark
                                    : subLocalityController.text,
                                street: streetController.text == ""
                                    ? addressProvider.addressObj!.street
                                    : streetController.text,
                                zipCode: zipCodeController.text == ""
                                    ? addressProvider.addressObj!.zipCode
                                    : zipCodeController.text,
                              )
                              .then((value) => {
                                    print(value),
                                    showAnimatedDialog(
                                        context,
                                        MyDialog(
                                          icon: Icons.check,
                                          title: 'Update Address',
                                          description:
                                              'Your address updated successfully',
                                          isFailed: false,
                                        ),
                                        dismissible: false,
                                        isFlip: false),
                                  });
                        },
                        buttonText: 'Save'),
                  ],
                ),
        ),
      ),
    );
  }

  bool _isObscure = true;

  Widget input(String hint, bool pass) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        child: TextFormField(
          obscureText: pass ? _isObscure : false,
          //obscuringCharacter: pass? '*' : '',
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.ubuntu(color: Colors.grey),
              contentPadding: EdgeInsets.only(top: 15, bottom: 15),
              prefixIcon: pass
                  ? Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    )
                  : Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
              suffixIcon: pass
                  ? IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        /*setState(() {
                          _isObscure = !_isObscure;
                        });*/
                      },
                    )
                  : null,
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}

class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height / 2, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DrawClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height / 2, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
