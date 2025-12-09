import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/screens/customer/service_search.dart';
import 'package:flutter/material.dart';

PreferredSize CustomAppBarWidget(
    BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: AppBar(
      leadingWidth: 35,
      backgroundColor: ColorResources.PRIMARY_COLOR,
      leading: IconButton(
          onPressed: () {
            if (title == "Vehicle Details") {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.customer_home,
                (Route<dynamic> route) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 35,
          )),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
      ),

      /*actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search,color: Colors.white,size: 30,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>ServiceSearch()));
          },
        ),
      ],*/
    ),
  );
}

PreferredSize CustomAppBarWithAction(BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey, String title, Function onTap) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: AppBar(
      leadingWidth: 35,
      backgroundColor: ColorResources.PRIMARY_COLOR,
      leading: IconButton(
          onPressed: () {
            if (title == "Vehicle Details") {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.customer_home,
                (Route<dynamic> route) => false,
              );
            } else {
              //Navigator.of(context).pop();
            }
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 35,
          )),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 12, bottom: 12),
          child: ElevatedButton(
            child: Text(
              "Add Vehicle",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
            onPressed: () {
              onTap();
            },
            style: ElevatedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              backgroundColor: ColorResources.BUTTON_COLOR,
              disabledBackgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
          ),
        ),
      ],
    ),
  );
}
