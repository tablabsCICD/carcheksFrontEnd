import 'dart:io';

import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/util/DateTimePickerDialog.dart';
import 'package:carcheks/util/color-resource.dart';

import 'package:carcheks/util/style.dart';

import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/registration_text_field.dart';
import 'package:carcheks/view/screens/auth/login_page.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/loader.dart';

class RegistrationScreen extends StatefulWidget {
  bool isgarageOwner;

  RegistrationScreen(this.isgarageOwner, {Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isLoading = false;
  bool isFormValid = false; // 🔹 NEW

  final formKey = GlobalKey<FormState>();

  // ---------------- CONTROLLERS ----------------
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController streetController = TextEditingController();
  TextEditingController subLocalityController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  TextEditingController garageNameController = TextEditingController();
  TextEditingController garageInfoController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController garageMobileNoController = TextEditingController();
  TextEditingController garageEmailIdController = TextEditingController();
  TextEditingController garageStreetController = TextEditingController();
  TextEditingController garageLocalityController = TextEditingController();
  TextEditingController garageCityController = TextEditingController();
  TextEditingController garageZipCodeController = TextEditingController();
  TextEditingController garageStateController = TextEditingController();
  TextEditingController garageCountryController = TextEditingController();
  TextEditingController openHrsController = TextEditingController();
  TextEditingController closeHrsController = TextEditingController();

  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController garageSubLocalityController = TextEditingController();
  String? openingTime, closingTime;

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _attachListeners();
  }

  // ---------------- LISTENERS ----------------
  void _attachListeners() {
    final controllers = [
      fnameController,
      lnameController,
      mobileController,
      emailController,
      passwordController,
      cityController,
      zipCodeController,
      stateController,
      countryController,
      garageNameController,
      garageMobileNoController,
      garageEmailIdController,
      garageStreetController,
      garageCityController,
      garageZipCodeController,
      garageStateController,
      garageCountryController,
      openHrsController,
      closeHrsController,
    ];

    for (final c in controllers) {
      c.addListener(_validateForm);
    }
  }

  // ---------------- VALIDATION LOGIC ----------------
  void _validateForm() {
    bool valid = formKey.currentState?.validate() ?? false;

    if (widget.isgarageOwner) {
      valid =
          valid &&
          garageNameController.text.isNotEmpty &&
          garageMobileNoController.text.isNotEmpty &&
          garageEmailIdController.text.isNotEmpty &&
          garageStreetController.text.isNotEmpty &&
          garageCityController.text.isNotEmpty &&
          garageZipCodeController.text.isNotEmpty &&
          garageStateController.text.isNotEmpty &&
          garageCountryController.text.isNotEmpty &&
          openHrsController.text.isNotEmpty &&
          closeHrsController.text.isNotEmpty;
    } else {
      valid =
          valid &&
          cityController.text.isNotEmpty &&
          zipCodeController.text.isNotEmpty &&
          stateController.text.isNotEmpty &&
          countryController.text.isNotEmpty;
    }

    if (valid != isFormValid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  String location = 'Null, Press Button';
  double? currentPlaceLat;

  double? currentPlaceLong;
  String address = 'searching current location.......';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
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
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Placemark? place;

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    place = placemarks[0];
    address =
        '${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.subAdministrativeArea}, ${place!.postalCode}, ${place!.country}';
    print("PLACE: $place");
    setState(() {});
  }

  getCurrentLocation() async {
    Position position = await _getGeoLocationPosition();
    currentPlaceLat = position.latitude;
    currentPlaceLong = position.longitude;
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    getAddressFromLatLong(position);
  }

  final now = DateTime.now();
  String formatter = '';
  AddressProvider addressProvider = locator<AddressProvider>();
  GarageProvider garageProvider = locator<GarageProvider>();

  bool isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{6,}$');
    return regex.hasMatch(password);
  }


  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    formatter = DateFormat('yMd').format(now);
    final authProvider = context.read<AuthProvider>();
    return Scaffold(
      body: Form(
        key: formKey,
        onChanged: _validateForm,
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: DrawClip2(),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffa58fd2), Color(0xffddc3fc)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: DrawClip(),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorResources.PRIMARY_COLOR,
                          Color(0xff91c5fc),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Profile Image
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: (imageUrl == null)
                          ? null
                          : NetworkImage(imageUrl!),
                      child: (imageUrl == null)
                          ? Icon(Icons.account_circle_outlined, size: 50)
                          : null,
                    ),
                  ),
                ),

                Positioned(
                  top: 125,
                  left: size.width / 2 + 20,
                  child: InkWell(
                    onTap: () async {
                      imageUrl = await authProvider.pickAndUploadImage(
                        context,
                        true,
                      );
                      setState(() {
                        print(imageUrl);
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[500],
                      ),
                      child: const Icon(Icons.add, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            // Expanded Form Fields
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // User Info Fields
                    RegistrationTextFeild(
                      controller: fnameController,
                      hintText: "First Name",
                      isName: true,
                      textInputType: TextInputType.text,
                      iconData: Icons.person,
                    ),
                    RegistrationTextFeild(
                      controller: lnameController,
                      hintText: "Last Name",
                      isName: true,
                      textInputType: TextInputType.text,
                      iconData: Icons.person,
                    ),
                    RegistrationTextFeild(
                      controller: mobileController,
                      hintText: "Mobile Number",
                      isPhoneNumber: true,
                      textInputType: TextInputType.phone,
                      iconData: Icons.phone_android,
                    ),
                    RegistrationTextFeild(
                      controller: emailController,
                      hintText: "Email Id",
                      isEmail: true,
                      textInputType: TextInputType.emailAddress,
                      iconData: Icons.email,
                    ),
                    RegistrationTextFeild(
                      controller: passwordController,
                      hintText: "Password",
                      isPassword: true,
                      textInputType: TextInputType.visiblePassword,
                      iconData: Icons.lock,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 25, top: 4),
                      child: Text(
                        "Hint: Minimum 6 characters, must include 1 number",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),

                    // Customer Address Section
                    if (!widget.isgarageOwner) ...[
                      useCurrentLocationButton(isCustomer: true),
                      RegistrationTextFeild(
                        controller: streetController,
                        hintText: "Street Name1",
                        textInputType: TextInputType.text,
                        iconData: Icons.apartment,
                      ),
                      RegistrationTextFeild(
                        controller: subLocalityController,
                        hintText: "Street Name2",
                        textInputType: TextInputType.text,
                        iconData: Icons.location_pin,
                      ),
                      RegistrationTextFeild(
                        controller: localityController,
                        hintText: "Location",
                        textInputType: TextInputType.text,
                        iconData: Icons.apartment,
                      ),
                      RegistrationTextFeild(
                        controller: cityController,
                        hintText: "City",
                        textInputType: TextInputType.text,
                        iconData: Icons.location_city,
                        isValidator: true,
                      ),
                      RegistrationTextFeild(
                        controller: zipCodeController,
                        hintText: "Zip Code",
                        textInputType: TextInputType.number,
                        iconData: Icons.location_pin,
                        isValidator: true,
                      ),
                      RegistrationTextFeild(
                        controller: stateController,
                        hintText: "State",
                        textInputType: TextInputType.text,
                        iconData: Icons.location_city,
                        isValidator: true,
                      ),
                      RegistrationTextFeild(
                        controller: countryController,
                        hintText: "Country",
                        textInputType: TextInputType.text,
                        iconData: Icons.location_pin,
                        isValidator: true,
                      ),
                    ],

                    // Garage Owner Section
                    if (widget.isgarageOwner)
                      ...garageOwnerFields(authProvider),

                    const SizedBox(height: 20),

                    // Register Button
                    Container(
                      width: size.width - 100,
                      child: CustomButton(
                        buttonText: isLoading ? "Please wait..." : "Register",
                        isEnable: isFormValid && !isLoading,
                        onTap: () async {
                          if (!formKey.currentState!.validate()) return;

                          try {
                            await getLatLong(
                              "${garageStreetController.text} "
                              "${garageLocalityController.text} "
                              "${garageCityController.text} "
                              "${garageStateController.text} "
                              "${garageCountryController.text}",
                            );

                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Registration'),
                                content: const Text(
                                  'Are you sure you want to register with these details?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                            Colors.green,
                                          ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              if (isFormValid && !isLoading) {
                                setState(() => isLoading = true);

                                try {
                                  RegistrationFun(authProvider);
                                } finally {
                                  setState(() => isLoading = false);
                                }
                              }
                            }
                          } on SocketException {
                            _showError(
                              context,
                              "Network Error, please try again",
                            );
                          } catch (e) {
                            _showError(
                              context,
                              "Something went wrong, please try again",
                            );
                          }
                        },
                      ),
                    ),

                    // Login Section
                    loginSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have account?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 7),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (builder) => LoginPage()),
              );
            },
            child: const Text(
              "Login",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff5172b4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget useCurrentLocationButton({required bool isCustomer}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50),
      child: InkWell(
        child: const Text(
          "Use Current Location to fill All Address Details",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.cyan,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: Text(
                isCustomer
                    ? 'Are you sure want to use your current location to fill All Address Details?'
                    : 'Are you sure want to use your current location to fill Garage Address Details?',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Yes', style: Style.okButton),
                  onPressed: () {
                    if (isCustomer) {
                      streetController.text = place!.thoroughfare ?? '';
                      localityController.text = place!.locality ?? '';
                      subLocalityController.text = place!.subLocality ?? '';
                      nameController.text = place!.name ?? '';
                      zipCodeController.text = place!.postalCode ?? '';
                      cityController.text = place!.subAdministrativeArea ?? '';
                      stateController.text = place!.administrativeArea ?? '';
                      countryController.text = place!.country ?? '';
                    } else {
                      garageStreetController.text = place!.thoroughfare ?? '';
                      garageLocalityController.text = place!.locality ?? '';
                      garageSubLocalityController.text =
                          place!.subLocality ?? '';
                      garageZipCodeController.text = place!.postalCode ?? '';
                      garageCityController.text =
                          place!.subAdministrativeArea ?? '';
                      garageStateController.text =
                          place!.administrativeArea ?? '';
                      garageCountryController.text = place!.country ?? '';
                      latController.text = currentPlaceLat.toString();
                      longController.text = currentPlaceLong.toString();
                    }
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('No', style: Style.cancelButton),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> garageOwnerFields(AuthProvider authProvider) {
    return [
      RegistrationTextFeild(
        controller: garageNameController,
        hintText: "Garage Name",
        isValidator: true,
        textInputType: TextInputType.text,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageInfoController,
        hintText: "Garage Info",
        textInputType: TextInputType.text,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: websiteController,
        hintText: "Website",
        textInputType: TextInputType.text,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageMobileNoController,
        hintText: "Garage Mobile Number",
        textInputType: TextInputType.phone,
        isPhoneNumber: true,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageEmailIdController,
        hintText: "Garage Email Id",
        isEmail: true,
        textInputType: TextInputType.emailAddress,
        iconData: Icons.lock,
      ),
      useCurrentLocationButton(isCustomer: false),
      RegistrationTextFeild(
        controller: garageStreetController,
        hintText: "Garage Address",
        textInputType: TextInputType.streetAddress,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageLocalityController,
        hintText: "Landmark",
        textInputType: TextInputType.streetAddress,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageCityController,
        hintText: "City",
        textInputType: TextInputType.text,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageZipCodeController,
        hintText: "Zipcode",
        textInputType: TextInputType.number,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageStateController,
        hintText: "State",
        textInputType: TextInputType.text,
        iconData: Icons.lock,
      ),
      RegistrationTextFeild(
        controller: garageCountryController,
        hintText: "Country",
        textInputType: TextInputType.text,
        iconData: Icons.lock,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RegistrationTextFeild(
              onTap: () async {
                openingTime = await DateTimePickerDialog().selectTime(context);
                openHrsController.text = openingTime ?? "Select Opening Time";
                setState(() {});
              },
              controller: openHrsController,
              hintText: "Opening Time",
              isValidator: true,
              readOnly: true,
              textInputType: TextInputType.text,
              iconData: Icons.lock,
            ),
          ),
          Expanded(
            child: RegistrationTextFeild(
              onTap: () async {
                closingTime = await DateTimePickerDialog().selectTime(context);
                closeHrsController.text = closingTime ?? "Select Closing Time";
                setState(() {});
              },
              controller: closeHrsController,
              hintText: "Closing Time",
              isValidator: true,
              readOnly: true,
              textInputType: TextInputType.text,
              iconData: Icons.lock,
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: InkWell(
          onTap: () async {
            await authProvider.pickAndUploadImage(context, false);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: "Garage Photo",
              border: OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  authProvider.uploadedGarageImg?.isNotEmpty == true
                      ? "Garage photo selected"
                      : "Click here to add garage photo",
                  style: TextStyle(
                    color: authProvider.uploadedGarageImg?.isNotEmpty == true
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
                const Icon(Icons.camera_alt),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Future<void> getLatLong(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          latController.text = locations[0].latitude.toString();
          longController.text = locations[0].longitude.toString();
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  String TimeCnt = "";
  String? _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) selectedTime = picked;
    _hour = selectedTime.hour.toString();
    _minute = selectedTime.minute.toString();

    _hour = _hour!.length == 1 ? "0$_hour" : _hour;
    _minute = _minute!.length == 1 ? "0$_minute" : _minute;
    _time = _hour! + ' : ' + _minute!;

    if (picked?.periodOffset.toString() == '0') {
      TimeCnt = (_time).toString();
    } else if (picked?.periodOffset.toString() == '12') {
      TimeCnt = (_time).toString();
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void RegistrationFun(AuthProvider model) async {
    getLoader(context, isLoading);

    if (fnameController.text.isNotEmpty &&
        lnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      Map<String, dynamic> result = await model.saveUser(
        created: formatter,
        created_by: fnameController.text,
        updated_by: fnameController.text,
        updated: formatter,
        first_name: fnameController.text,
        last_name: lnameController.text,
        emailid: emailController.text,
        mobilenumber: mobileController.text,
        password: passwordController.text,
        image_url: model.uploadedProfileImg,
        garrage_Owner: widget.isgarageOwner ? true : false,
        payment_mode: true,
        garageName: garageNameController.text,
        garageInfo: garageInfoController.text,
        garageImg: model.uploadedGarageImg,
        garageEmailId: garageEmailIdController.text,
        garageMobile: widget.isgarageOwner
            ? int.parse(garageMobileNoController.text)
            : 0,
        openingTime: openHrsController.text,
        closingTime: closeHrsController.text,
        lat: latController.text,
        long: longController.text,
        garageStreet: garageStreetController.text,
        garageLandmark: garageLocalityController.text,
        garageCity: garageCityController.text,
        garageState: garageStateController.text,
        garageCountry: garageCountryController.text,
        garageZipcode: garageZipCodeController.text,
        isPopular: true,
        garagePassword: passwordController.text,
        website: websiteController.text,
        verificationId: '',
        isVerified: true,
        rating: 0,
        description: garageInfoController.text,
        noOfratings: 0,
        city: widget.isgarageOwner
            ? garageCityController.text
            : cityController.text,
        addressName: widget.isgarageOwner
            ? garageLocalityController.text
            : localityController.text,
        state: widget.isgarageOwner
            ? garageStateController.text
            : stateController.text,
        country: widget.isgarageOwner
            ? garageCountryController.text
            : countryController.text,
        street: widget.isgarageOwner
            ? garageStreetController.text
            : streetController.text,
        landmark: widget.isgarageOwner
            ? garageSubLocalityController.text
            : subLocalityController.text,
        zipcode: widget.isgarageOwner
            ? garageZipCodeController.text
            : zipCodeController.text,
        garrageAddress: widget.isgarageOwner ? true : false,
      );

      dismissLoader(context);

      if (result['success'] == true) {
        // 🎉 Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text(
              'Thank you for registering!\n\nYou can now continue to the login page.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: const Text('Continue to Login'),
              ),
            ],
          ),
        );
      } else {
        showSimpleNotification(
          Text(
            result["message"].toString(),
            style: const TextStyle(color: Colors.white),
          ),
          background: Colors.black,
        );
      }
    } else {
      dismissLoader(context);
      const snackBar = SnackBar(content: Text('Please Fill All Fields'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(
      size.width / 4,
      size.height,
      3 * size.width / 4,
      size.height / 2,
      size.width,
      size.height * 0.8,
    );
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
    path.cubicTo(
      size.width / 4,
      size.height,
      3 * size.width / 4,
      size.height / 2,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
