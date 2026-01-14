import 'dart:convert';
import 'dart:developer';
import 'package:carcheks/locator.dart';
import 'package:carcheks/model/address_model.dart';
import 'package:carcheks/provider/address_provider.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEditAddressPage extends StatefulWidget {
  final AddressClass? address;

  const AddEditAddressPage({Key? key, this.address}) : super(key: key);

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final houseCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final zipCtrl = TextEditingController();

  double? lat;
  double? lng;

  final addressProvider = locator<AddressProvider>();
  final authProvider = locator<AuthProvider>();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.address != null) {
      final a = widget.address!;
      houseCtrl.text = a.houseName;
      streetCtrl.text = a.street;
      landmarkCtrl.text = a.landmark;
      cityCtrl.text = a.cityname;
      stateCtrl.text = a.state;
      countryCtrl.text = a.country;
      zipCtrl.text = a.zipCode;
      lat = a.lat.isEmpty ? null : double.tryParse(a.lat);
      lng = a.long.isEmpty ? null : double.tryParse(a.long);
    }
  }

  @override
  void dispose() {
    houseCtrl.dispose();
    streetCtrl.dispose();
    landmarkCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    zipCtrl.dispose();
    super.dispose();
  }

  /// ---------------- USE CURRENT LOCATION ----------------
  void _useCurrentLocation() {
    if (addressProvider.currentLat == null ||
        addressProvider.currentLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Current location not available")),
      );
      return;
    }

    setState(() {
      lat = addressProvider.currentLat;
      lng = addressProvider.currentLng;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Current location applied")));
  }

  /// ---------------- GEOCODING ----------------
  Future<void> _resolveLatLngIfNeeded() async {
    if (lat != null && lng != null) return;

    final address =
        "${houseCtrl.text}, ${streetCtrl.text}, ${cityCtrl.text}, "
        "${stateCtrl.text}, ${countryCtrl.text}, ${zipCtrl.text}";

    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json"
      "?address=${Uri.encodeComponent(address)}"
      "&key=YOUR_GOOGLE_API_KEY",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data['status'] == 'OK') {
        final loc = data['results'][0]['geometry']['location'];
        lat = loc['lat'];
        lng = loc['lng'];
        AppConstants.CurrentLatitude = lat!;
        AppConstants.CurrentLongtitude = lng!;
        // log(
        //   '===========latlong================----------------> ${AppConstants.CurrentLatitude}',
        // );
      }
    }
  }

  /// ---------------- SUBMIT ----------------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    /// 1️⃣ Ensure lat/lng exists
    await _resolveLatLngIfNeeded();

    if (lat == null || lng == null) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to detect location")),
      );
      return;
    }

    final now = "1/1/2026";
    final user = authProvider.user!;

    if (widget.address == null) {
      /// ---------------- ADD ----------------
      await addressProvider.addAddress(
        AddressClass(
          id: 0,
          created: now,
          createdBy: user.firstName,
          updated: now,
          updatedBy: user.firstName,
          active: true,
          houseName: houseCtrl.text,
          street: streetCtrl.text,
          landmark: landmarkCtrl.text,
          cityname: cityCtrl.text,
          state: stateCtrl.text,
          country: countryCtrl.text,
          zipCode: zipCtrl.text,
          userId: user.id,
          lat: lat.toString(),
          long: lng.toString(),
          garrageAddress: false,
        ),
      );
    } else {
      /// ---------------- UPDATE ----------------
      await addressProvider.updateAddress(
        id: widget.address!.id,
        active: true,
        houseName: houseCtrl.text,
        street: streetCtrl.text,
        landmark: landmarkCtrl.text,
        cityname: cityCtrl.text,
        state: stateCtrl.text,
        country: countryCtrl.text,
        zipCode: zipCtrl.text,
        latitude: lat.toString(),
        longitude: lng.toString(),
        updated: now,
        updated_by: user.firstName,
        userId: user.id,
        garrageAddress: widget.address!.garrageAddress,
      );
    }

    setState(() => isSaving = false);
    Navigator.pop(context);
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Address" : "Add Address")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("House / Flat", houseCtrl),
              _field("Street", streetCtrl),
              _field("Landmark", landmarkCtrl),
              _field("City", cityCtrl),
              _field("State", stateCtrl),
              _field("Country", countryCtrl),
              _field("Pincode", zipCtrl, keyboard: TextInputType.number),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _useCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text("Use current location"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isSaving ? null : _submit,
                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? "Update Address" : "Save Address"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
