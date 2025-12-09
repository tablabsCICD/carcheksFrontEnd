import 'package:carcheks/provider/appointment_provider.dart';
import 'package:carcheks/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../../dialog/animated_custom_dialog.dart';
import '../../../../dialog/my_dialog.dart';
import '../../../../locator.dart';
import '../../../../util/color-resource.dart';
import '../../../base_widgets/custom_dropdown_list.dart';
import '../../customer/garage/garage_dashboard.dart';
import 'all_appointment.dart';

class AppointmentStatusChange extends StatefulWidget {
  AppointmentProvider appointmentProvider = locator<AppointmentProvider>();
  final int? garageId;
  final int? appointmentId;
  final int? userId;
  final int? subserviceId;
  final int? vehicleId;
  final String? availableTime, date;
  int count = 0;

  AppointmentStatusChange(
      {Key? key,
      @required this.garageId,
      this.appointmentId,
      this.userId,
      this.date,
      this.availableTime,
      this.subserviceId,
      this.vehicleId})
      : super(key: key);

  @override
  State<AppointmentStatusChange> createState() =>
      _AppointmentStatusChangeState();
}

class _AppointmentStatusChangeState extends State<AppointmentStatusChange> {
  List<String> statusList = <String>[
    'New Arrival',
    'Pending',
    'In Progress',
    'Completed',
    'Canceled',
    'Delivered',
  ];
  String status = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // status = statusList[0];
  }

  @override
  Widget build(BuildContext context) {
    print("This is Garage ID: ${widget.garageId}");
    print("This is Appointment ID: ${widget.appointmentId}");
    print("This is Users ID: ${widget.userId}");
    return Form(
      key: _formKey,
      child: Consumer<AppointmentProvider>(
        builder: (context, model, child) => Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Change Appointment Status",
                style: Style.APOOINTMENT_TITLE,
              ),
              SizedBox(
                height: 10,
              ),
              CustomDropdownList(
                hintText: "Select Status",
                items: statusList,
                selectedType: status,
                onChange: (String value) {
                  setState(() {
                    status = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if(status==''){
                    showSimpleNotification(
                        Text(
                          "Please select status",
                          style: TextStyle(color: Colors.white),
                        ),
                        background: Colors.red);
                  }else{
                  if (_formKey.currentState!.validate()) {
                    var result = await widget.appointmentProvider
                        .UpdateAppointmentStatus(
                            accept: true,
                            active: true,
                            availableTime: widget.availableTime,
                            date: widget.date,
                            garrageId: widget.garageId,
                            id: widget.appointmentId,
                            status: status,
                            subServiceId: widget.subserviceId,
                            userId: widget.userId,
                            vehicleId: widget.vehicleId)
                        .then((value) => {
                              if (value == 200)
                                {
                                  showSimpleNotification(
                                      Text(
                                        "Appointment status changed..",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      background: Colors.green),
                                  Navigator.of(context).pop(status)
                                }
                              else
                                {
                                  showSimpleNotification(
                                      Text(
                                        "Appointment status not changed..",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      background: Colors.red)
                                }
                            });
                  }}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.BUTTON_COLOR,
                  //primary:  widget.appointmentList[index].color,
                  elevation: 3,
                  // side: BorderSide(color: Colors.red, width: 1.5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text("Submit",
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
