import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/search_widget.dart';
import 'package:carcheks/view/screens/customer/vehicle/add_vehicle_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZipCode extends StatefulWidget {
  @override
  _ZipCodeState createState() => _ZipCodeState();
}

class _ZipCodeState extends State<ZipCode> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Zip Code"),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please provide a Zip Code or address, So we can get you estimates from shops near by.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 20),
            SearchWidget(
              controller: zipCodeController,
              hintText: "Search Services,Store",
              onClearPressed: () {},
              onSubmit: () {},
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: CustomButton(
                buttonText: 'Continue',
                isEnable: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => AddVehicleInfo(isdashboard: false),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
