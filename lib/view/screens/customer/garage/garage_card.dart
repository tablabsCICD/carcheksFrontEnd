import 'dart:developer';

import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/app_constants.dart';
//import 'package:carcheks/response/garage/getAllGarage.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardStore extends StatefulWidget {
  Garage garage;
  CardStore(this.garage, {super.key});

  @override
  State<CardStore> createState() => _CardStoreState();
}

class _CardStoreState extends State<CardStore> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.garage_details,
              arguments: widget.garage,
            );
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: (Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 90,
                        decoration: widget.garage.imageUrl == ''
                            ? BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    AppConstants.DEFAULT_GARAGE_IMG,
                                  ),
                                ),
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.garage.imageUrl),
                                ),
                              ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 20,
                          width: 45,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.star,
                                size: 15,
                                color: ColorResources.PRIMARY_COLOR,
                              ),
                              Text(
                                widget.garage.rating.toString(),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 0,
                    ),
                    child: Text(
                      widget.garage.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 2,
                    ),
                    child: widget.garage.addressDtls == ''
                        ? Text(
                            "Please Add Garage Address",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        : Text(
                            "${widget.garage.addressDtls!.houseName}, ${widget.garage.addressDtls!.street}, ${widget.garage.addressDtls?.landmark}, ${widget.garage.addressDtls?.cityname}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
