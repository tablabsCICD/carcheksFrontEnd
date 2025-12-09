import 'package:carcheks/provider/appointment_provider.dart';
import 'package:flutter/material.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../../util/color-resource.dart';
import '../../../base_widgets/getImage.dart';
import 'appointmentDetails.dart';
class AllAppointmnet extends StatefulWidget {
  const AllAppointmnet({Key? key}) : super(key: key);

  @override
  State<AllAppointmnet> createState() => _AllAppointmnetState();
}

class _AllAppointmnetState extends State<AllAppointmnet> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget container = Container();
  AppointmentProvider appointmentProvider= locator<AppointmentProvider>();
  @override
  void initState() {
    super.initState();
    container= getAllData(appointmentProvider);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context,_scaffoldKey,"Appoitments"),
      body: Consumer<AppointmentProvider>(
        builder: (context,model,child)=> Column(
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

            Container(
              padding: EdgeInsets.all(10),
              child: getAllData(model),
            )

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
          model.fiterListAsperStatus(selectedTab);

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


}



getAllData(AppointmentProvider model){

  return Expanded(child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("All Appointments",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        SizedBox(height: 15,),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.AppointmentByUserId.length,
              itemBuilder: (BuildContext context, int index) {
                int? userid=model.AppointmentByUserId[index].id;
                return GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) => AppointmentDetailsUser(model.AppointmentByUserId[index])));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      leading: getImage(''),

                      title: Text("Ashish Mishra" ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( model.AppointmentByUserId[index].date.toString()),
                          SizedBox(height: 7,),
                          Container(
                              height: 25,
                              child:ElevatedButton(
                                onPressed: (){
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (builder) => AppointmentDetailsUser(model.AppointmentByUserId[index])));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorResources.BUTTON_COLOR,
                                  foregroundColor:  Colors.greenAccent,
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
                      trailing: Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                );
                // child: GServiceCard(model.garageServiceListByGarageId[index],widget.garage));
              }
          ),
        )
      ],
    ),
  ),);


}


