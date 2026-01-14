import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/getImage.dart';
import 'package:carcheks/view/screens/garage_owner/appointment/appointment_details.dart';
import 'package:carcheks/view/screens/garage_owner/appointment/appointments_status_change.dart';
import 'package:flutter/material.dart';
import 'package:carcheks/provider/appointment_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../model/appointment_model.dart';
import '../../../../provider/garage_provider.dart';
import '../../../base_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AllAppointment extends StatefulWidget {
  String? type;
  AllAppointment({this.type});

  @override
  _AllAppointmentState createState() => _AllAppointmentState();
}

class _AllAppointmentState extends State<AllAppointment> {
  List<AppointmentData> allAppointments = [];

  AppointmentProvider appointmentProvider = locator<AppointmentProvider>();
  GarageProvider garageProvider = locator<GarageProvider>();
  AuthProvider authProvider = locator<AuthProvider>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController regNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isSelected = false, isSelectedCustomer = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedTab;

  /*@override
  void initState() {

  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTab = widget.type!;
    getData();
  }

  getData() async {
    await appointmentProvider.getAppointmentByGarageId(
      garageProvider.ownGarageList[0].id,
    );
    await appointmentProvider.fiterListAsperStatus(widget.type!);
  }

  @override
  Widget build(BuildContext context) {
    print(
      "APPOINTMENT LENGTHHHHH:${appointmentProvider.appointmentByGarageId.length}",
    );
    return Scaffold(
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Appointment"),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 5, top: 10),
              child: ListView(
                padding: EdgeInsets.all(2),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  getCircularContainer("All", (selectedTab == "All"), 0),
                  getCircularContainer(
                    "New Arrival",
                    (selectedTab == "New Arrival"),
                    1,
                  ),
                  // getCircularContainer(
                  //   "Pending",
                  //   (selectedTab == "Pending"),
                  //   2,
                  // ),
                  getCircularContainer(
                    "In Progress",
                    (selectedTab == "In Progress"),
                    2,
                  ),
                  getCircularContainer(
                    "Completed",
                    (selectedTab == "Completed"),
                    3,
                  ),
                  getCircularContainer(
                    "Cancelled",
                    (selectedTab == "Cancelled"),
                    4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            getAppointmentList(),
          ],
        ),
      ),
    );
  }

  getAppointmentList() {
    return Expanded(
      //height: MediaQuery.of(context).size.height-120,
      child: Consumer<AppointmentProvider>(
        builder: (context, model, child) =>
            model.appointmentByGarageId.length == 0 && model.isLoading == true
            ? Center(child: CircularProgressIndicator())
            : model.appointmentByGarageId.length == 0 &&
                  model.isLoading == false
            ? Center(child: Text("No data found "))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: model.appointmentByGarageId.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => AppointmentDetails(
                            model.appointmentByGarageId[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(7),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          //border: Border.all(color: widget.appointmentList[index].color),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          leading: getImage(
                            model
                                .appointmentByGarageId[index]
                                .userOrderId!
                                .userTable!
                                .imageUrl
                                .toString(),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${model.appointmentByGarageId[index].userOrderId!.userTable!.firstName.toString()} ${model.appointmentByGarageId[index].userOrderId!.userTable!.lastName.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                //Text(model.appointmentByGarageId[index].userOrderId!.userTable!.mobilenumber.toString()),
                                IconButton(
                                  onPressed: () {
                                    launch(
                                      "tel://${model.appointmentByGarageId[index].userOrderId!.userTable!.mobilenumber.toString()}",
                                    );
                                  },
                                  icon: Icon(Icons.call, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Appointment date: ",
                                      style: Style.APOOINTMENT_SUBTITLE,
                                    ),
                                    Text(
                                      model.appointmentByGarageId[index].date
                                          .toString(),
                                      style: Style.APOOINTMENT_TITLE,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Appointment Time: ",
                                      style: Style.APOOINTMENT_SUBTITLE,
                                    ),
                                    Text(
                                      model
                                          .appointmentByGarageId[index]
                                          .availableTime
                                          .toString(),
                                      style: Style.APOOINTMENT_TITLE,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Service selected: ",
                                      style: Style.APOOINTMENT_SUBTITLE,
                                    ),
                                    Text(
                                      model
                                          .appointmentByGarageId[index]
                                          .garageServices!
                                          .subService!
                                          .name
                                          .toString(),
                                      style: Style.APOOINTMENT_TITLE,
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Total Cost: ",
                                      style: Style.APOOINTMENT_SUBTITLE,
                                    ),
                                    Text(
                                      "\$ ${model.appointmentByGarageId[index].garageServices!.cost}",
                                      style: Style.APOOINTMENT_TITLE,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Payment status: ",
                                      style: Style.APOOINTMENT_SUBTITLE,
                                    ),
                                    Text("-", style: Style.APOOINTMENT_TITLE),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                height: 25,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (model
                                            .appointmentByGarageId[index]
                                            .status
                                            .toString()
                                            .toLowerCase() ==
                                        "completed") {
                                      showSimpleNotification(
                                        Text(
                                          "Appointment Closed",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        background: Colors.red,
                                      );
                                    } else {
                                      callDailog(index);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorResources.BUTTON_COLOR,
                                    //primary:  widget.appointmentList[index].color,
                                    elevation: 3,
                                    // side: BorderSide(color: Colors.red, width: 1.5),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      model.appointmentByGarageId[index].status
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //trailing: Icon(Icons.keyboard_arrow_down_outlined),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  getCircularContainer(String title, bool isSelected, int i) {
    return Consumer<AppointmentProvider>(
      builder: (context, model, child) => InkWell(
        onTap: () {
          selectedTab = title;
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
            decoration: BoxDecoration(
              color: selectedTab.compareTo(title) == 0
                  ? Colors.blue
                  : Color(0xfff0f0f0),
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
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  void callDailog(int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        insetPadding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(18),
          width: MediaQuery.of(context).size.width - 20,
          child: Stack(
            children: [
              AppointmentStatusChange(
                garageId: garageProvider.ownGarageList[0].id,
                appointmentId:
                    appointmentProvider.appointmentByGarageId[index].id,
                currentStatus:
                    appointmentProvider.appointmentByGarageId[index].status ??
                    'New Arrival',
                userId: appointmentProvider
                    .appointmentByGarageId[index]
                    .userOrder!
                    .userTable!
                    .id,
                availableTime: appointmentProvider
                    .appointmentByGarageId[index]
                    .availableTime,
                date: appointmentProvider.appointmentByGarageId[index].date,
                subserviceId: appointmentProvider
                    .appointmentByGarageId[index]
                    .garageServices!
                    .subService!
                    .id,
                vehicleId: appointmentProvider
                    .appointmentByGarageId[index]
                    .garageServices!
                    .vechicletypeid!
                    .id,
              ),
            ],
          ),
        ),
      ),
    ).then((valueFromDialog) {
      final currentStatus =
          appointmentProvider.appointmentByGarageId[index].status;

      appointmentProvider.appointmentByGarageId[index].status =
          valueFromDialog ?? currentStatus;

      appointmentProvider.fiterListAsperStatus(selectedTab);
      appointmentProvider.notifyListeners();
    });

    ;
  }
}
