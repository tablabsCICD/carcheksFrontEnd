import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../base_widgets/box_button.dart';

class EditVehicleInfo extends StatefulWidget {
  final Vehicle vehicle;
  const EditVehicleInfo(this.vehicle, {Key? key}) : super(key: key);

  @override
  State<EditVehicleInfo> createState() => _EditVehicleInfoState();
}

class _EditVehicleInfoState extends State<EditVehicleInfo> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final vehicleProvider = locator<VehicleProvider>();
  final authProvider = locator<AuthProvider>();

  //late TextEditingController nameCtrl = TextEditingController();
  late TextEditingController modelCtrl = TextEditingController();
  late TextEditingController yearCtrl = TextEditingController();
  late TextEditingController regCtrl = TextEditingController();

  late String formatter;

  @override
  void initState() {
    super.initState();

    formatter = DateFormat('yMd').format(DateTime.now());

    // nameCtrl = TextEditingController(
    //   text: widget.vehicle.vehicleManufacturer!.name ?? '',
    // );
    modelCtrl = TextEditingController(text: widget.vehicle.vehicleModel ?? '');
    yearCtrl = TextEditingController(
      text: widget.vehicle.yearOfManufacturing ?? '',
    );
    regCtrl = TextEditingController(text: widget.vehicle.registrationNo ?? '');
  }

  @override
  void dispose() {
    //nameCtrl.dispose();
    modelCtrl.dispose();
    yearCtrl.dispose();
    regCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Edit Vehicle"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_field("Vehicle Name", nameCtrl),
                _field("Vehicle Model", modelCtrl),
                _field(
                  "Manufacturing Year",
                  yearCtrl,
                  keyboard: TextInputType.number,
                ),
                _field("Registration Number", regCtrl),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: BoxButton(buttonText: "Continue", onTap: _submit),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboard,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? "Required field" : null,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you want to edit vehicle details?"),
        actions: [
          TextButton(
            child: Text("No", style: Style.cancelButton),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Yes", style: Style.okButton),
            onPressed: () async {
              Navigator.pop(context);
              getLoader(context, true);

              await vehicleProvider.updateVehicle(
                vehicleId: widget.vehicle.id,
                userId: authProvider.user!.id,
                active: true,
                created: widget.vehicle.created,
                created_by: widget.vehicle.createdBy,
                //name: nameCtrl.text.trim(),
                vehicle_model: modelCtrl.text.trim(),
                year: yearCtrl.text.trim(),
                regNumber: regCtrl.text.trim(),
                image_url: widget.vehicle.photosUrl,
                last_servecing_date: widget.vehicle.lastServiceDate,
                vehicleType: widget.vehicle.vehicletype,
                vehicleManufacturer: widget.vehicle.vehicleManufacturer,
                updated: formatter,
                updated_by: authProvider.user!.firstName,
              );

              dismissLoader(context);

              showAnimatedDialog(
                context,
                MyDialog(
                  icon: Icons.check,
                  title: 'Vehicle',
                  description: 'Vehicle updated successfully',
                  isFailed: false,
                ),
                dismissible: false,
                isFlip: false,
              );

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.vehicle_details,
              );
            },
          ),
        ],
      ),
    );
  }
}
