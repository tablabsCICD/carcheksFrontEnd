import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/garage_owner_navigation_drawer.dart';
import 'package:provider/provider.dart';
import '../appointment/all_appointment.dart';
import 'add_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../base_widgets/custom_button.dart';

class ChooseServices extends StatefulWidget {
  @override
  _ChooseServicesState createState() => _ChooseServicesState();
}

class _ChooseServicesState extends State<ChooseServices> {
  final _scaffoldKey1 = GlobalKey<ScaffoldState>();
  Widget container = Container();
  bool isMapSelected = false, isPopularSelected = false;
  ServiceProvider serviceProvider = locator<ServiceProvider>();

  @override
  void initState() {
    serviceProvider.getAllServices();
    container = getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey1,
      appBar: CustomAppBarWidget(context,_scaffoldKey1,"Choose Services"),
      body: Consumer<ServiceProvider>(
        builder: (context, model, child) =>model.isLoading==true?Container(): Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                    child: Text("Choose the services you provide",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
              ),
              SizedBox(height: 15,),
              getServices(),
              SizedBox(
                height: 5,
              ),

            ],
          ),
        )),
    );
  }

  getServices(){
    return Consumer<ServiceProvider>(
      builder: (context, model, child) =>model.isLoading==true?Center(child:CircularProgressIndicator() ,): Expanded(
       // height: 400,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: model.allServices.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio: 2 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
           return InkWell(
             onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (builder)=>AddServices(model.allServices[index])));
               Navigator.pushNamed(context, AppRoutes.add_service,arguments: model.allServices[index]);
             },
             child: Container(
               width: 250,
               height: 370,
               padding: const EdgeInsets.all(0),
               decoration: BoxDecoration(
                   color:  Colors.white,
                   borderRadius: BorderRadius.circular(5),
                   boxShadow: [
                    const BoxShadow(
                       offset: Offset(1, 1),
                       blurRadius: 5,
                       color: Colors.grey,
                     )

                   ]),

               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   ClipRRect(
                     borderRadius: BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8)),
                     child: Image.network(
                       model.allServices[index].photosUrl,
                       fit: BoxFit.fill,
                        height: 90.0,
                        width: 500,
                     ),
                   ),

                   SizedBox(
                     height: 10,
                   ),
                   Text(
                     model.allServices[index].name.toString(),
                     textAlign: TextAlign.center,
                     style: TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.bold,
                         color: ColorResources.BLACK),
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Container(
                     height: 25,
                     child: ElevatedButton(
                         onPressed: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (builder)=>AddServices(model.allServices[index])));
                           Navigator.pushNamed(context, AppRoutes.add_service,arguments: model.allServices[index]);
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: ColorResources.PRIMARY_COLOR,
                           foregroundColor: Colors.white,
                           elevation: 3,
                           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                         ),
                         child: Text("Add")),
                   ),

                 ],
               ),
             ),
           );
          },
         /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0
          ),*/
        ),
      ),
    );
  }

  getAllData() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCard(Icons.local_car_wash, "Car Wash"),
                getCard(Icons.tire_repair, "Falt Tire"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCard(Icons.battery_alert, "Battery Replacement"),
                getCard(Icons.car_repair, "Car Repair"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCard(Icons.format_paint, "Car Paint"),
                getCard(Icons.car_repair, "Car Repair"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getCard(IconData icon, String service_name) {
    return InkWell(
      onTap: (){
      /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => AddServices()));*/
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50,),
              Text(
                service_name,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
