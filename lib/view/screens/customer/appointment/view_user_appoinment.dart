import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/appointment_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/getImage.dart';
import 'package:carcheks/view/screens/garage_owner/appointment/appointment_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base_widgets/custom_appbar.dart';

class ViewUserAppointment extends StatefulWidget {
  const ViewUserAppointment({Key? key}) : super(key: key);

  @override
  State<ViewUserAppointment> createState() => _ViewUserAppointmentState();
}

class _ViewUserAppointmentState extends State<ViewUserAppointment> {
  final AppointmentProvider appointmentProvider =
      locator<AppointmentProvider>();
  final AuthProvider authProvider = locator<AuthProvider>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedTab = 'All';

  @override
  void initState() {
    super.initState();

    /// ✅ Safe user access
    final userId = authProvider.user?.id;
    if (userId != null) {
      appointmentProvider.getAppointmentByUsertableID(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(context, _scaffoldKey, "My Appointment"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabs(),
          const SizedBox(height: 20),
          _buildAppointmentList(),
        ],
      ),
    );
  }

  /// 🔹 Tabs
  Widget _buildTabs() {
    return SizedBox(
      height: 50,
      child: ListView(
        padding: const EdgeInsets.all(4),
        scrollDirection: Axis.horizontal,
        children: [
          _tabItem("All"),
          _tabItem("New Arrival"),
          _tabItem("In Progress"),
          _tabItem("Completed"),
          _tabItem("Cancelled"),
        ],
      ),
    );
  }

  Widget _tabItem(String title) {
    final bool isSelected = selectedTab == title;

    return InkWell(
      onTap: () {
        setState(() => selectedTab = title);
        appointmentProvider.filterListByUser(title);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : const Color(0xfff0f0f0),
            borderRadius: BorderRadius.circular(15),
            border: isSelected
                ? null
                : Border.all(color: const Color(0xffd1ccc4)),
          ),
          child: Text(
            title,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  /// 🔹 Appointment List
  Widget _buildAppointmentList() {
    return Expanded(
      child: Consumer<AppointmentProvider>(
        builder: (context, model, _) {
          final appointments = model.AppointmentByUserId;

          if (appointments.isEmpty) {
            return const Center(child: Text("No appointments found"));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final garage = appointment.garageServices?.garage;

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentDetails(appointment),
                      ),
                    );
                  },
                  leading: getImage(garage?.imageUrl ?? ''),
                  title: Text(garage?.name ?? "Garage"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${appointment.date ?? ''} at ${appointment.time ?? ''}",
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppointmentDetails(appointment),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.BUTTON_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          appointment.status ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "\$ ${appointment.garageServices?.cost ?? 0}",
                    style: const TextStyle(fontSize: 15, color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
