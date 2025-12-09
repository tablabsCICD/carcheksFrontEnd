import 'package:carcheks/locator.dart';
import 'package:carcheks/model/services.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/view/screens/customer/service/sub_service_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../util/app_constants.dart';
import '../../garage_owner/garage_services/view_services.dart';

class ServiceCard extends StatefulWidget {
  MainService service;
  bool? cost;
  bool? isFromGuarge=false;
  ServiceCard(this.service, {Key? key, this.cost,this.isFromGuarge}) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {

  final authProvider = locator<AuthProvider>();
  final garageProvider = locator<GarageProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {

      if(widget.isFromGuarge==true){
        int? id = await authProvider.getUserId();
        await garageProvider.getGarageByUserId(id!);
        Navigator.of(context).push(MaterialPageRoute(builder:(context) =>ViewServices( mainServiceId: widget.service.id,)));

      } else{

        if(AppConstants.vehicle.id==0){

          const snackBar = SnackBar(
            content: Text('Select the Vehicle'),
          );

       ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }else{
          showDialog(context: context,
              builder: (BuildContext context){
                return SubServiceCustomDialogBox(
                    widget.service,widget.cost
                );
              }
          );
        }
      }

          },
          child: Stack(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: widget.service.isServiceSelected == true
                          ? Colors.white
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        widget.service.isServiceSelected == true
                            ? const BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          color: Colors.grey,
                        )
                            : const BoxShadow()
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: widget.service.photosUrl==""?BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(AppConstants.DEFAULT_SERVICE_IMG))
                        ):BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.service.photosUrl))
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(widget.service.name,overflow:TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,),textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ),
              widget.service.isServiceSelected == true
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
        ),
      ),
    );
  }
}
