
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base_widgets/CustomAppBar-.dart';
import '../../customer/service/service_card.dart';
class GetAllGarageSer extends StatefulWidget {
  @override
  State<GetAllGarageSer> createState() => _GetAllGarageSerState();
}

class _GetAllGarageSerState extends State<GetAllGarageSer> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget container = Container();
  bool isMapSelected = false,isPopularSelected = false;
  ServiceProvider serviceProvider = locator<ServiceProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidgetTwo(context,_scaffoldKey,"View Services"),
      body:Consumer<ServiceProvider>(
        builder: (context, model, child) => Container(
          padding: EdgeInsets.all(10),
          child: getAllData(model),
        ),
      ),
    );
  }



  getAllData(ServiceProvider model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("All Services",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: model.allServices.length,
              itemBuilder: (context, index) => ServiceCard(model.allServices[index],isFromGuarge: true,),
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
    );
  }

}


