import 'package:carcheks/provider/appointment_provider.dart';
import 'package:carcheks/util/style.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';
import '../../../../util/color-resource.dart';
import '../../../base_widgets/custom_dropdown_list.dart';

class AppointmentStatusChange extends StatefulWidget {
  final AppointmentProvider appointmentProvider =
      locator<AppointmentProvider>();

  final int? garageId;
  final int? appointmentId;
  final int? userId;
  final int? subserviceId;
  final int? vehicleId;
  final String? availableTime;
  final String? date;

  /// 🔴 CURRENT STATUS (IMPORTANT)
  final String currentStatus;

  AppointmentStatusChange({
    Key? key,
    required this.garageId,
    required this.currentStatus,
    this.appointmentId,
    this.userId,
    this.date,
    this.availableTime,
    this.subserviceId,
    this.vehicleId,
  }) : super(key: key);

  @override
  State<AppointmentStatusChange> createState() =>
      _AppointmentStatusChangeState();
}

class _AppointmentStatusChangeState extends State<AppointmentStatusChange> {
  final _formKey = GlobalKey<FormState>();

  /// 🔐 Status flow rules
  final Map<String, List<String>> statusFlow = {
    'New Arrival': ['In Progress', 'Cancelled'],
    'In Progress': ['Completed'],
    'Completed': [],
    'Cancelled': [],
  };

  List<String> statusList = [];
  String selectedStatus = '';
  bool isLocked = false;

  @override
  void initState() {
    super.initState();

    statusList = statusFlow[widget.currentStatus] ?? [];

    if (widget.currentStatus == 'Cancelled' ||
        widget.currentStatus == 'Completed') {
      isLocked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Consumer<AppointmentProvider>(
        builder: (context, model, child) {
          return ListView(
            shrinkWrap: true,
            children: [
              Text("Change Appointment Status", style: Style.APOOINTMENT_TITLE),
              const SizedBox(height: 12),

              /// ℹ️ Current Status
              // Text(
              //   "Current Status: ${widget.currentStatus}",
              //   style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              // ),
              // const SizedBox(height: 12),

              /// 🔒 Locked message
              if (isLocked)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Status cannot be changed after ${widget.currentStatus}.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              /// ✅ Dropdown only if allowed
              if (!isLocked) ...[
                CustomDropdownList(
                  hintText: widget.currentStatus,
                  items: statusList,
                  selectedType: selectedStatus,
                  onChange: (String value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    if (selectedStatus.isEmpty) {
                      showSimpleNotification(
                        Text(
                          "Please select a valid status",
                          style: TextStyle(color: Colors.white),
                        ),
                        background: Colors.red,
                      );
                      return;
                    }

                    final result = await widget.appointmentProvider
                        .UpdateAppointmentStatus(
                          accept: true,
                          active: true,
                          availableTime: widget.availableTime,
                          date: widget.date,
                          garrageId: widget.garageId,
                          id: widget.appointmentId,
                          status: selectedStatus,
                          subServiceId: widget.subserviceId,
                          userId: widget.userId,
                          vehicleId: widget.vehicleId,
                        );

                    if (result == 200) {
                      showSimpleNotification(
                        Text(
                          "Appointment status updated successfully",
                          style: TextStyle(color: Colors.white),
                        ),
                        background: Colors.green,
                      );
                      Navigator.of(context).pop(selectedStatus);
                    } else {
                      showSimpleNotification(
                        Text(
                          "Failed to update appointment status",
                          style: TextStyle(color: Colors.white),
                        ),
                        background: Colors.red,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.BUTTON_COLOR,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
