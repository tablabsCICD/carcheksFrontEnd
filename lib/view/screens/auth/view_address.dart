import 'package:carcheks/locator.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/loader.dart';
import 'package:carcheks/view/base_widgets/registration_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../dialog/animated_custom_dialog.dart';
import '../../../dialog/my_dialog.dart';
import '../../../util/style.dart';
import '../../base_widgets/custom_button.dart';

class ViewAddress extends StatefulWidget {
  @override
  State<ViewAddress> createState() => _ViewAddressState();
}

class _ViewAddressState extends State<ViewAddress> {
  TextEditingController streetController = TextEditingController();
  TextEditingController subLocalityController =  TextEditingController();
  TextEditingController localityController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController latController = new TextEditingController();
  TextEditingController longController = new TextEditingController();


  final authProvider = locator<AuthProvider>();

  final now = DateTime.now();

  String formatter = '';

  String location = 'Null, Press Button';

  String Address = 'searching current location.......';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Placemark? place;

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    place = placemarks[0];
    Address =
        '${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.subAdministrativeArea}, ${place!.postalCode}, ${place!.country}';
    setState(() {});
  }

  getCurrentLocation() async {
    getLoader(context, true);
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);
    dismissLoader(context);
  }

  final addressProvider = locator<AddressProvider>();

  fetchValue() {
    streetController.text = addressProvider.addressObj!.street.toString();
    localityController.text = addressProvider.addressObj!.houseName.toString();
    subLocalityController.text = addressProvider.addressObj!.landmark.toString();
    nameController.text = addressProvider.addressObj!.houseName.toString();
    zipCodeController.text = addressProvider.addressObj!.zipCode.toString();
    cityController.text = addressProvider.addressObj!.cityname.toString();
    stateController.text = addressProvider.addressObj!.state.toString();
    countryController.text = addressProvider.addressObj!.country.toString();
    latController.text = addressProvider.addressObj!.lat.toString();
    longController.text = addressProvider.addressObj!.long.toString();
  }

  getData() async {
    int? id = await authProvider.getUserId();
    AddressClass? addressClass = await addressProvider.getAddressForUser(id!);
    addressClass != null
        ? fetchValue()
        : showSimpleNotification(
            const Text(
              "Please Fill Address Details",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.black);
    print("abcd");
    print("addressProvider:${addressProvider.addressObj!.garrageAddress.toString()}");
  }

  @override
  void initState() {
    getData();
    getCurrentLocation();
    authProvider.getUserDetails();
    formatter = DateFormat('yMd').format(now);
    // fetchValue();
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
          builder: (context, model, child) => model.isLoading==true?Container(child: Center(child: CircularProgressIndicator(),)):Form(
            key: _formKey,
            child: Column(
              children: [

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
                  textInputType: TextInputType.phone,
                  iconData: Icons.apartment,

                ),
                RegistrationTextFeild(
                    controller: cityController,
                    hintText: "City",
                    textInputType: TextInputType.text,

                    iconData: Icons.location_city),
                RegistrationTextFeild(
                  controller: zipCodeController,
                  hintText: "Zip Code",
                  textInputType: TextInputType.text,
                  iconData: Icons.location_pin,
                ),
                RegistrationTextFeild(
                    controller: stateController,
                    hintText: "State",
                    textInputType: TextInputType.phone,

                    iconData: Icons.location_city),
                RegistrationTextFeild(
                    controller: countryController,
                    hintText: "Country",
                    textInputType: TextInputType.emailAddress,

                    iconData: Icons.location_pin),
                addressProvider.addressObj!.garrageAddress?RegistrationTextFeild(
                    controller: latController,
                    hintText: "Latitude",
                    textInputType: TextInputType.text,
                    isValidator: true,
                    ):SizedBox(),
                addressProvider.addressObj!.garrageAddress?RegistrationTextFeild(
                  controller: longController,
                  hintText: "Longitude",
                  textInputType: TextInputType.text,
                  isValidator: true,
                ):SizedBox(),
                Center(
                  child: CustomButton(
                      onTap: () async {
      if (_formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text(
                                'Are you sure want to update your Garage Address?',
                                style: Style.heading,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('yes', style: Style.okButton),
                                  onPressed: () {
                                    model.updateAddress(

                                      active:addressProvider.addressObj!.active,
                                      created: formatter,
                                      created_by:addressProvider.addressObj!.createdBy,
                                      updated:formatter,
                                      updated_by :addressProvider.addressObj!.updatedBy,
                                      id: addressProvider.addressObj!.id,
                                      cityname: cityController.text,
                                      country: countryController.text,
                                      garrageAddress: addressProvider.addressObj!.garrageAddress,
                                      houseName: localityController.text,
                                      landmark: subLocalityController.text,
                                      latitude:latController.text,
                                      longitude:longController.text,
                                      state: stateController.text,
                                      street: streetController.text,
                                      userId: addressProvider.addressObj!.userId,
                                      zipCode: zipCodeController.text,
                                    ).then((value) => {
                                      print(value),
                                      showAnimatedDialog(
                                          context,
                                          MyDialog(
                                            icon: Icons.check,
                                            title: 'Edit Garage Address',
                                            description:
                                            'Your Garage Address Updated Successfully',
                                            isFailed: false,
                                          ),
                                          dismissible: false,
                                          isFlip: false),
                                    });
                                    Navigator.of(context).pop();
                                    dismissLoader(context);


                                  },
                                ),
                                TextButton(
                                  child: Text('no', style: Style.cancelButton),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));}
                      },
                      buttonText: 'Save'),
                ),

                /* CustomButton(
                    onTap: () async {
                      CityModel cityModel =  CityModel(
                          id: 1,
                          created: formatter,
                          createdBy: "Tablabs",
                          active: true,
                          city: cityController.text,
                          state: stateController.text,
                          country: countryController.text);
                      AddressModel addressModel = AddressModel(
                          id: 1,
                          created:  formatter,
                          createdBy: "Tablabs",
                          updated: formatter,
                          updatedBy: "Tablabs",
                          active: true,
                          name: nameController.text,
                          street: streetController.text,
                          city: cityModel,
                          zipCode: zipCodeController.text,
                          landmark: localityController.text);
                      print(cityModel.city);
                      print(addressModel.landmark);
                      showDialog(
                          context: context,
                          builder: (_) => new CupertinoAlertDialog(
                            title: Text(
                              'Are you sure want to update your address?',
                              style: Style.heading,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('yes', style: Style.okButton),
                                onPressed: () {
                                  model
                                      .updateUser(
                                      address: addressModel )
                                      .then((value) => {
                                    showAnimatedDialog(
                                        context,
                                        MyDialog(
                                          icon: Icons.check,
                                          title: 'Edit Profile',
                                          description:
                                          'Your Profile Updated successfully',
                                          isFailed: false,
                                        ),
                                        dismissible: false,
                                        isFlip: false),
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('no', style: Style.cancelButton),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                    },
                    buttonText: 'Save'),*/
              ],
            ),
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
