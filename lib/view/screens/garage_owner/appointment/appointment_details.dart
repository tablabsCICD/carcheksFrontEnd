import 'package:carcheks/model/appointment_model.dart';
import 'package:carcheks/provider/appointment_provider.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/getImage.dart';
import 'package:carcheks/view/base_widgets/star_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:carcheks/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetails extends StatefulWidget {
  final AppointmentData appointmentData;

  const AppointmentDetails(this.appointmentData, {Key? key}) : super(key: key);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppointmentProvider appointmentProvider =
      locator<AppointmentProvider>();

  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteController.text = widget.appointmentData.paypalOrderId?.status ?? '';
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.appointmentData.userOrder?.userTable;
    final payment = widget.appointmentData.paypalOrderId;
    final service = widget.appointmentData.garageServices?.subService?.name;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Appointment Details"),
      body: Consumer<AppointmentProvider>(
        builder: (context, model, child) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- PROFILE IMAGE ----------
                Center(
                  child: user?.imageUrl == null || user!.imageUrl!.isEmpty
                      ? const Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.grey,
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.imageUrl!),
                        ),
                ),

                const SizedBox(height: 10),

                /// ---------- NAME ----------
                Center(
                  child: Text(
                    "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.BUTTON_COLOR,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// ---------- CALL ----------
                if (user?.mobilenumber != null &&
                    user!.mobilenumber!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call, color: Colors.green),
                        onPressed: () {
                          launchUrl(Uri.parse("tel:${user.mobilenumber}"));
                        },
                      ),
                      Text(
                        user.mobilenumber!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.BUTTON_COLOR,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 15),

                /// ---------- ADDRESS ----------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/svg/location.svg", width: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.appointmentData.userAddress ??
                            "Address not available",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// ---------- DATE & TIME ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoRow("Date", widget.appointmentData.date),
                    _infoRow("Time", widget.appointmentData.time),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(thickness: 2),
                const SizedBox(height: 12),

                /// ---------- PAYMENT ----------
                const Text(
                  "Payment Details",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  payment?.orderId ?? "N/A",
                  style: const TextStyle(fontSize: 15, color: Colors.green),
                ),
                const SizedBox(height: 6),
                Text(
                  "Transaction ID:",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  payment?.transactionId ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 12),

                /// ---------- SERVICES ----------
                const Text(
                  "Services Requested",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  service ?? "Service not available",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 12),

                /// ---------- NOTE ----------
                const Text(
                  "Note",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Add note",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- REUSABLE INFO ROW ----------
  Widget _infoRow(String label, String? value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(value ?? "--", style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  /// ---------- EXISTING CHAT LIST (SAFE) ----------
  Widget getChatList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getImage(''),
                  const SizedBox(width: 15),
                  const Text(
                    "Gaurav",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Row(
                children: const [
                  StarDisplay(value: 4),
                  SizedBox(width: 10),
                  Text("2 days ago", style: TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Lorem Ipsum is simply dummy text of the printing industry.",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
