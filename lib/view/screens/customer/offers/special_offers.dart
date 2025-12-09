import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'offers_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SpecialOffers extends StatefulWidget {
  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  final authProvider = locator<AuthProvider>();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBarWidget(context, _scaffoldKey, "Special Offers"),
        body: getSpecialOffers());
  }

  getSpecialOffers() {
    return Consumer<ServiceProvider>(
      builder: (context, model, child) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount:10,// model.alGaragelServices.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                width: 170,
                height: 150,
                margin: EdgeInsets.all(5),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/1.jpg"))),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 20,
                              width: 50,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Center(
                                child: Text(
                                  "20% off",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          /*Align(
                            alignment: Alignment.center,
                            child:  Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 0),
                                    child: Text(
                                      "20% sale off",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: ColorResources.PRIMARY_COLOR),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 0),
                                    child: Text(
                                      "Repair class glass",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: ColorResources.PRIMARY_COLOR),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 2),
                                    child: Text(
                                      "Redbricks Services",
                                      style: TextStyle(
                                          fontSize: 11, fontWeight: FontWeight.normal),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )*/
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 0),
                              child: Text(
                                "20% sale off",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ColorResources.PRIMARY_COLOR),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 0),
                              child: Text(
                                "Repair class glass",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ColorResources.PRIMARY_COLOR),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 2),
                              child: Text(
                                "Redbricks Services",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.normal),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorResources.BUTTON_COLOR,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                              child: Text("Book Services",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }
}
