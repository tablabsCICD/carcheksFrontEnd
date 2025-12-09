import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/getImage.dart';
import 'package:carcheks/view/screens/customer/garage/garage_dashboard.dart';
import 'package:carcheks/view/screens/garage_owner/appointment/appointment_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carcheks/provider/appointment_provider.dart';
import '../../../base_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
class ViewUserAppointment extends StatefulWidget {

//  MaterialColor color;
  ViewUserAppointment();

  @override
  _ViewUserAppointmentState createState() => _ViewUserAppointmentState();
}

class _ViewUserAppointmentState extends State<ViewUserAppointment> {
  AppointmentProvider appointmentProvider = locator<AppointmentProvider>();
  AuthProvider authProvider = locator<AuthProvider>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appointmentProvider.getAppointmentByUsertableID(authProvider.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(context,_scaffoldKey,"My Appointment"),
      body:  Container(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.only(left: 5,top: 10),
            child: ListView(
              padding: EdgeInsets.all(2),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                getCircularContainer(
                    "All", (selectedTab == "All Appointments"), 0),
                getCircularContainer("Pending",
                    (selectedTab == "Pending"), 1),
                getCircularContainer("In Progress",
                    (selectedTab == "In Progress"), 2),
                getCircularContainer("Completed",
                    (selectedTab == "Completed"), 3),
                getCircularContainer("Canceled",
                    (selectedTab == "Canceled"), 4),
              ],
            ),
          ),
          SizedBox(height: 20,),
          getAppointmentList(),
        ],
        ),
      ),
    );
  }


  var selectedTab = 'All';
  getCircularContainer(String title, bool isSelected, int i) {
    return Consumer<AppointmentProvider>(
      builder: (context, model, child) => InkWell(
        onTap: () {
          selectedTab=title;
          model.filterListByUser(selectedTab);

        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 2.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 25,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              color: selectedTab.compareTo(title)==0 ? Colors.blue : Color(0xfff0f0f0),
              border: isSelected ? null : Border.all(color: Color(0xffd1ccc4)),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  getAppointmentList() {
    return Expanded(
      //height: MediaQuery.of(context).size.height-120,
      child: Consumer<AppointmentProvider>(
        builder: (context, model, child) => ListView.builder(
            shrinkWrap: true,
            itemCount: model.AppointmentByUserId.length,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: ListTile(
                  leading: getImage(''),
                  title: Text( model.AppointmentByUserId[index].garageServices!.garage!.name!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text( model.AppointmentByUserId[index].date.toString()),
                          SizedBox(width: 7,),
                          Text("at ${model.AppointmentByUserId[index].time.toString()}")
                        ],
                      ),
                      SizedBox(height: 7,),
                      Container(
                          height: 25,
                          child:ElevatedButton(
                            onPressed: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (builder) => AppointmentDetails(model.AppointmentByUserId[index])));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.BUTTON_COLOR,
                              foregroundColor:  Colors.lime,
                              elevation: 3,
                              // side: BorderSide(color: Colors.red, width: 1.5),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                              child: Text( model.AppointmentByUserId[index].status.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white
                                  )),
                            ),
                          )

                      )
                    ],
                  ),
                  trailing: Text('\$ ${model.AppointmentByUserId[index].garageServices!.cost}',
                      style: TextStyle(fontSize: 15, color: Colors.green)),

                ),
              );
            }),
      ),
    );
  }
}
