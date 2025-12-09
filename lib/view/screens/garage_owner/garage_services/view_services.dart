import 'dart:ui';

import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/loader.dart';
import 'package:carcheks/view/screens/customer/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'edit_service.dart';

class ViewServices extends StatefulWidget {

  ViewServices( {key,required this.mainServiceId}) : super(key: key);

  final int mainServiceId;



  @override
  State<ViewServices> createState() => _ViewServicesState();

}

class _ViewServicesState extends State<ViewServices> {
  final authProvider = locator<AuthProvider>();
  final garageProvider = locator<GarageProvider>();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
   // garageProvider.getAllGarageServicesByGarageIdServiceId(garageId: garageProvider.ownGarageList[0].id,mainserviceId: widget.mainServiceId);
  getData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Garage Services"),
      body: Consumer<GarageProvider>(
        builder: (context, model, child) =>
        model.listSubServicesGarage.length==0?
        const Center(child: Text("No data found "),)
            :
            Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          0.0,
                          0.0,
                        ),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ]),
                child: ListView.builder(
                    itemCount: model.listSubServicesGarage.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 90,
                                    alignment: Alignment.center,
                                    decoration: model.listSubServicesGarage[index].photosUrl==""?BoxDecoration(
                                        border: Border.all(),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            //image:  AssetImage("assets/images/1.jpg")
                                            image: NetworkImage(model.listSubServicesGarage[index].subService!.photosUrl.toString())
                                        ),
                                        borderRadius: BorderRadius.circular(5)):BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                            image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(model.listSubServicesGarage[index].photosUrl.toString()))
                                    ),
                                    //  child: Icon(Icons.add)
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppConstants.money + model.listSubServicesGarage[index].subService!.costing.toString(),
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
                                        AppConstants.money + model.listSubServicesGarage[index].cost.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.listSubServicesGarage[index].subService!.name.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),

                                  Text(
                                      "* ${model.listSubServicesGarage[index].shortDiscribtion}"??'',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "* Service Warranty : ${model.listSubServicesGarage[index].mainService!.serviceWarranty}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                              
                                  SizedBox(
                                    height: 9,
                                  ),
                              
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            SizedBox(
                              width: 30,

                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Container(
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(50),
                                        ),
                                        child:
                                        InkWell(
                                          onTap: (){
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    CupertinoAlertDialog(
                                                      title: const Text(
                                                        'Are you sure want to delete this?',
                                                        // style: Style.heading,
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                              "Yes",
                                                              style: Style.okButton),
                                                          onPressed: () {
                                                            model.deleteGarageSubService(model.listSubServicesGarage[index].id!,index)
                                                                .then((value) => {

                                                              showAnimatedDialog(
                                                                  context,
                                                                  MyDialog(
                                                                    icon: Icons
                                                                        .check,
                                                                    title:
                                                                    'Service Delete',
                                                                    description:
                                                                    'Service deleted successfully',
                                                                    isFailed:
                                                                    false,
                                                                  ),
                                                                  dismissible:
                                                                  false,
                                                                  isFlip: false)
                                                            });
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
                                                    )
                                            );
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        )
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pushNamed(context, AppRoutes.edit_service,arguments: {garageProvider.ownGarageList[0].id,model.listSubServicesGarage[index]});
                                       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>EditService(garageId: garageProvider.ownGarageList[0].id,mainserviceId: model.listSubServicesGarage[index])));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                )
            ),
      ),
    );
  }

  Future<void> getData() async {
    await garageProvider.getAllGarageSubServicesGarage(garageId: garageProvider.ownGarageList[0].id,mainserviceId: widget.mainServiceId);
  }
}
