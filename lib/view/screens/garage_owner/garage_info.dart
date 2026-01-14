import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/DateTimePickerDialog.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carcheks/locator.dart';
import 'package:provider/provider.dart';

import '../../../dialog/animated_custom_dialog.dart';
import '../../../dialog/my_dialog.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/garage_provider.dart';
import '../../../util/style.dart';
import '../../base_widgets/custom_button.dart';
import '../../base_widgets/loader.dart';
import '../../base_widgets/registration_text_field.dart';
import '../auth/view_address.dart';
import '../customer/garage/garage_dashboard.dart';

class GarageInfo extends StatefulWidget {
  @override
  State<GarageInfo> createState() => _GarageInfoState();
}

class _GarageInfoState extends State<GarageInfo> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isloading = false;

  TextEditingController garagenameController = TextEditingController();
  TextEditingController garagewebsiteController = new TextEditingController();
  TextEditingController garageemailController = new TextEditingController();
  TextEditingController garagemobileController = new TextEditingController();
  TextEditingController garageRatingController = new TextEditingController();
  TextEditingController garageOpeningTimeController =
      new TextEditingController();
  TextEditingController garageClosingTimeController =
      new TextEditingController();
  TextEditingController garageLatitudeController = new TextEditingController();
  TextEditingController garageLongitudeController = new TextEditingController();
  TextEditingController garageRatingCountController =
      new TextEditingController();
  TextEditingController garageAddressController = new TextEditingController();

  final garageProvider = locator<GarageProvider>();
  final authProvider = locator<AuthProvider>();

  List<ImageCarousel> _imageUrls = [
    ImageCarousel(
      'assets/images/1.jpg',
      "Grow your business",
      "Lorem ipsum dolor sit amet, consectetur adipiscing\nelit. Suspendisse arcu dui.",
    ),
    ImageCarousel(
      'assets/images/2.jpg',
      "Grow your own business",
      "Lorem ipsum dolor sit amet, consectetur adipiscing\nelit. Suspendisse arcu dui.",
    ),
    ImageCarousel(
      'assets/images/3.jpg',
      "Grow your tkd business",
      "Lorem ipsum dolor sit amet, consectetur adipiscing\nelit. Suspendisse arcu dui.",
    ),
  ];
  int _current = 0;
  int index = -1;

  @override
  void initState() {
    getGarageInfo();
  }

  getImageSlider() {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160.0,
            aspectRatio: 16 / 9,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: _imageUrls.map((i) {
            index++;
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/1.jpg"),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imageUrls.map((i) {
                int index = _imageUrls.indexOf(i);
                return Container(
                  width: 7.0,
                  height: 7.0,
                  margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? ColorResources.PRIMARY_COLOR
                        : Colors.black.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String? openingTime, closeingTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Business Details"),
      body: SingleChildScrollView(
        child: Consumer<GarageProvider>(
          builder: (context, model, child) => Container(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getImageSlider(),
                  Divider(),
                  RegistrationTextFeild(
                    controller: garagenameController,
                    hintText: "Business Name",
                    textInputType: TextInputType.text,
                    iconData: Icons.person,
                  ),
                  RegistrationTextFeild(
                    controller: garagemobileController,
                    hintText: "Business Contact Number",
                    textInputType: TextInputType.text,
                    iconData: Icons.person,
                  ),
                  RegistrationTextFeild(
                    controller: garageemailController,
                    hintText: "Business Email",
                    textInputType: TextInputType.text,
                    iconData: Icons.person,
                  ),
                  RegistrationTextFeild(
                    controller: garagewebsiteController,
                    hintText: "Business Website",
                    textInputType: TextInputType.text,
                    iconData: Icons.person,
                  ),
                  // RegistrationTextFeild(
                  //   controller: garageRatingController,
                  //   hintText: "Business Rating",
                  //   textInputType: TextInputType.text,
                  //   iconData: Icons.person,
                  // ),
                  RegistrationTextFeild(
                    onTap: () async {
                      openingTime = await DateTimePickerDialog().selectTime(
                        context,
                      );
                      if (openingTime == null) {
                        garageOpeningTimeController.text =
                            "Select Opening Time";
                      } else {
                        garageOpeningTimeController.text = openingTime!;
                      }
                      setState(() {});
                    },
                    controller: garageOpeningTimeController,
                    hintText: "Business Opening Time",
                    textInputType: TextInputType.text,
                    iconData: Icons.person,
                  ),
                  RegistrationTextFeild(
                    onTap: () async {
                      closeingTime = await DateTimePickerDialog().selectTime(
                        context,
                      );
                      if (closeingTime == null) {
                        garageClosingTimeController.text =
                            "Select Closing Time";
                      } else {
                        garageClosingTimeController.text = closeingTime!;
                      }
                      setState(() {});
                    },
                    controller: garageClosingTimeController,
                    hintText: "Business Closing Time",
                    textInputType: TextInputType.text,
                    iconData: Icons.person,
                  ),

                  // RegistrationTextFeild(
                  //   controller: garageLatitudeController,
                  //   hintText: "Latitude",
                  //   textInputType: TextInputType.text,
                  //   iconData: Icons.person,
                  // ),
                  // RegistrationTextFeild(
                  //   controller: garageLongitudeController,
                  //   hintText: "Longitude",
                  //   textInputType: TextInputType.text,
                  //   iconData: Icons.person,
                  // ),
                  // RegistrationTextFeild(
                  //   controller: garageRatingCountController,
                  //   hintText: "Rating Count",
                  //   textInputType: TextInputType.text,
                  //   iconData: Icons.person,
                  // ),
                  Center(
                    child: CustomButton(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (_) => new CupertinoAlertDialog(
                            title: Text(
                              'Are you sure want to update your Business info?',
                              style: Style.heading,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('yes', style: Style.okButton),
                                onPressed: () {
                                  getLoader(context, isloading);
                                  model
                                      .updateGarageinfo(
                                        name: garagenameController.text,
                                        contactNumber:
                                            garagemobileController.text,
                                        emailId: garageemailController.text,
                                        websiteUrl:
                                            garagewebsiteController.text,
                                        rating: garageRatingController.text,
                                        openingTime:
                                            garageOpeningTimeController.text,
                                        closingTime:
                                            garageClosingTimeController.text,
                                        latitude: garageLatitudeController.text,
                                        longitude:
                                            garageLongitudeController.text,
                                        imageUrl:
                                            model.ownGarageList[0].imageUrl,
                                        noOfRating: int.parse(
                                          garageRatingCountController.text,
                                        ),
                                      )
                                      .then(
                                        (value) => {
                                          print(value),
                                          showAnimatedDialog(
                                            context,
                                            MyDialog(
                                              icon: Icons.check,
                                              title: 'Edit Business Info',
                                              description:
                                                  'Your Business Info Updated Successfully',
                                              isFailed: false,
                                            ),
                                            dismissible: false,
                                            isFlip: false,
                                          ),
                                        },
                                      );
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
                          ),
                        );
                      },
                      buttonText: 'Save',
                      isEnable: true,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Text(
                          "Address Details",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffea6935),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.garage_address,
                          );
                          /*Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ViewAddress()),
                                );*/
                        },
                      ),
                    ],
                  ),

                  /*  Row(
                  children: [
                    Text("Garage Name: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text(model.ownGarageList[0].name,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Contact Number: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text(model.ownGarageList[0].contactNumber,style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("EmailId: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.emailId",style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Website: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.websiteUrl",style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Rating: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.rating".toString(),style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Opening Time: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.openingTime",style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Closing Time: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.closingTime",style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Latitude: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.latitude",style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Longitude: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.longitude",style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Rating Count: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Text("model.garage!.noOfRating.toString()",style: TextStyle(color: Colors.black,fontSize: 15),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Address: ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                    Expanded(child: Text(model.ownGarageList[0].addressDtls.name,maxLines: 3,style: TextStyle(color: Colors.black,fontSize: 15),)),
                  ],
                ),   */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getGarageInfo() async {
    int? id = await authProvider.getUserId();
    await garageProvider.getGarageByUserId(id!);

    garagenameController.text = garageProvider.ownGarageList[0].name.toString();
    garagewebsiteController.text = garageProvider.ownGarageList[0].websiteUrl
        .toString();
    garageemailController.text = garageProvider.ownGarageList[0].emailId
        .toString();
    garagemobileController.text = garageProvider.ownGarageList[0].contactNumber
        .toString();
    garageRatingController.text = garageProvider.ownGarageList[0].rating
        .toString();
    garageOpeningTimeController.text = garageProvider
        .ownGarageList[0]
        .openingTime
        .toString();
    garageClosingTimeController.text = garageProvider
        .ownGarageList[0]
        .closingTime
        .toString();
    garageLatitudeController.text = garageProvider.ownGarageList[0].latitude
        .toString();
    garageLongitudeController.text = garageProvider.ownGarageList[0].longitude
        .toString();
    garageRatingCountController.text = garageProvider
        .ownGarageList[0]
        .noOfRating
        .toString();
    garageAddressController.text = garageProvider
        .ownGarageList[0]
        .addressDtls!
        .houseName
        .toString();
  }
}
