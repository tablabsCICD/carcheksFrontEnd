
import 'dart:async';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/screens/customer/cart/my_cart.dart';
import 'package:carcheks/view/screens/customer/notes.dart';
import '../../../base_widgets/CustomAppBar-.dart';
import 'service_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class GetAllServices extends StatefulWidget {

   Vehicle? vehicle;
   String? from="Dashboard";
   GetAllServices({this.vehicle,this.from}){}
  // GetAllServices(this.vehicle,this.from){
  //
  // }

  @override
  _GetAllServicesState createState() => _GetAllServicesState();
}

class _GetAllServicesState extends State<GetAllServices> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget container = Container();
  bool isMapSelected = false,isPopularSelected = false;
  ServiceProvider serviceProvider = locator<ServiceProvider>();

  @override
  void initState() {
   // container = getAllData(serviceProvider);
    if(widget.from==null){
      serviceProvider.getAllServices();
      serviceProvider.getSelectedServiceCount();
    }else{
      AppConstants.vehicle= widget.vehicle!;
      serviceProvider.getAllByid(widget.vehicle!.vehicletype!.id!);

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context,_scaffoldKey,"Book Services"),
      body:Consumer<ServiceProvider>(
        /*builder: (context, model, child) => Container(
          padding: EdgeInsets.all(10),
          child: getAllData(model),
         ),*/
        builder: (context, model, child) =>
        model.allServices.length==0 && model.isLoading==true?Center(
          child: CircularProgressIndicator(),
        ):
        model.allServices.length==0 && model.isLoading==false?Center(child: Text("No data found "),):
            Container(
              padding: EdgeInsets.all(10),
              child: getAllData(model),
             ),
      ),
    );
  }

  /*getAllData(ServiceProvider model){
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model.allServices.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              setState(() {
                //model.setSelectedService(model.allServices[index]);
              });
            },
            child: Stack(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color:  model.allServices[index].isServiceSelected == true
                            ? Colors.green[50]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          model.allServices[index].isServiceSelected == true
                              ? const BoxShadow(
                            offset: Offset(1, 1),
                            blurRadius: 5,
                            color: Colors.grey,
                          )
                              : const BoxShadow()
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                    width: 100,
                                    height: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage("assets/images/1.jpg")),
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                   // child: Icon(Icons.add)
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 25,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          model.allServices[index].isServiceSelected = !model.allServices[index].isServiceSelected;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorResources.BUTTON_COLOR,
                                        onPrimary: Colors.white,
                                        elevation: 3,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      ),
                                      child: Text(model.allServices[index].isServiceSelected == false
                                          ?"Add To Cart":"Added",),
                                    ))
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.allServices[index].name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  "* Every 5000 kms/3 Months",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "* Takes 4 hrs",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "* 1 Month Warrenty",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "* Include 9 services",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      AppConstants.money + "3,399",
                                      style: TextStyle(
                                          fontSize: 14,
                                          decoration: TextDecoration
                                              .lineThrough,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      AppConstants.money + "2,399",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black54,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                size: 15,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Save \$100 compaired to other services",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                model.allServices[index].isServiceSelected == true
                    ? const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 20,
                    ),
                  ),
                )
                    : const SizedBox.shrink()
              ],
            ),
          );
        }

      ),
    );
  }*/

  getAllData(ServiceProvider model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("All Services",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          GridView.builder(
            shrinkWrap: true,
            itemCount: model.allServices.length,
            itemBuilder: (context, index) => ServiceCard(model.allServices[index]),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          )
        ],
      ),
    );
  }

}
