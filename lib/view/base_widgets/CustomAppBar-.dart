import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/screens/customer/service_search.dart';
import 'package:flutter/material.dart';


PreferredSize CustomAppBarWidgetTwo(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, String title){
  return PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: AppBar(
      leadingWidth: 35,
      backgroundColor: ColorResources.PRIMARY_COLOR,
      leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 35,)
      ),
      title: Text(title,style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.bold),),
      actions: <Widget>[
        /*IconButton(
          icon: const Icon(Icons.search,color: Colors.white,size: 30,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>ServiceSearch()));
          },
        ),*/
      ],
    ),
  );
}