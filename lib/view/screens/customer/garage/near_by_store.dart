
import 'dart:async';

import 'package:carcheks/locator.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/screens/customer/garage/garage_card.dart';
import 'package:carcheks/view/screens/customer/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../model/vehicle_model.dart';


class NearByStore extends StatefulWidget {

  List<SubService>? selectedList;
  GarageProvider garageProvider = locator<GarageProvider>();
  VehicleProvider vehicleProvider = locator<VehicleProvider>();
  String? fromScreen="Dashboard";
  Vehicle? vehicale;

  NearByStore({Key? key, this.selectedList,this.fromScreen,this.vehicale}){
    //garageProvider.getAllGarageNearByUser();
    fromStringData();
   // garageProvider.getAllFilter(1,5);
  }

  fromStringData(){
    switch (fromScreen){
      case 'Dashboard':
        garageProvider.getAllGarage();
        break;
      case 'Filter':
        List<int>selectedId=[];
        for(int i = 0;i<selectedList!.length;i++){
          selectedId.add(selectedList![i].id);
        }
        print("selected subservices${selectedId.toString()}");
        print('Selected type id is ${vehicleProvider.selectedUserVehicle!.id}');

        garageProvider.getAllFilter(vehicleProvider.selectedUserVehicle!.vehicletype!.id!,selectedId);
      break;

      case'NearByALL':
        garageProvider.getAllGarageNearByUser();
        break;
      case 'Search':
        print('the id is ${vehicale!.vehicletypeId}');
        garageProvider.getAllGarageNearByVehicleType(vehicleType:vehicale!.vehicletype!.id! );
        break;


    }
  }

  @override
  _NearByStoreState createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget container = Container();
  bool isMapSelected = false,isPopularSelected = false;
  GarageProvider garageProvider = locator<GarageProvider>();
  @override
  void initState() {
    container = getAllData(garageProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context,_scaffoldKey,"All near by stores"),
      body: Consumer<GarageProvider>(
        builder: (context, model, child) =>model.allGarageList.length==0 && model.isLoading==true?Center(
          child: CircularProgressIndicator(),
        ):
        model.allGarageList.length==0 && model.isLoading==false
            ?Center(child: Text("No data found "),)
            :Container(
         // padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          isPopularSelected = !isPopularSelected;
                         // isMapSelected = !isMapSelected;
                        });
                        if(isPopularSelected == true)
                        {isMapSelected=false;};
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isPopularSelected? Colors.green[200
                          ]:Colors.transparent
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.pool_outlined),
                            //SvgPicture.asset("assets/svg/up_down_arrow.svg",height: 15,width: 15,),
                            SizedBox(width: 5,),
                            Text("Popular",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          isMapSelected = !isMapSelected;
                        //  isPopularSelected = !isPopularSelected;
                        });
                        if(isMapSelected == true)
                        {isPopularSelected=false;};

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isMapSelected? Colors.green[200]:Colors.transparent
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.map),
                            //SvgPicture.asset("assets/svg/map.svg",height: 15,width: 15,),
                            SizedBox(width: 5,),
                            Text("On Map",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15,),
              isPopularSelected?getPopularData(model):isMapSelected?MapScreen():getAllData(model)
            ],
          ),
        ),
      ),
    );
  }

  getAllData(GarageProvider model){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("All Near By Stores",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: model.allGarageList.length,
                itemBuilder: (context, index) => CardStore(model.allGarageList[index]),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getPopularData(GarageProvider model){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("All Popular Near By Stores",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: model.isPopularGarageList.length,
                itemBuilder: (context, index) => CardStore(model.isPopularGarageList[index]),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
 }
