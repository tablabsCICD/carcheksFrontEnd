import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/util/DateTimePickerDialog.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:provider/provider.dart';

class GarageReport extends StatefulWidget {
  const GarageReport({super.key});

  @override
  State<GarageReport> createState() => _GarageReportState();
}

class _GarageReportState extends State<GarageReport> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "My Earning"),
      body: Consumer<GarageProvider>(
        builder: (context, model, child) => Container(
          color: ColorResources.PRIMARY_COLOR,
          child: Stack(
            children: [
            SizedBox(
              height: 500,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 7,
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16,),
                            Center(
                              child: Text(
                                "Earning From ${model.selectedFromDate} To ${model.selectedToDate}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 16,),
                            Center(
                              child: Text(
                                "\$ "+"${model.TotalAmt}",
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 16,),
                            Divider(),
                            SizedBox(height: 0,),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "(${model.paypalOrderListByGarage.length}) Orders",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "\$ "+"${model.TotalAmt}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: ProsteBezierCurve(
                    position: ClipPosition.top,
                    list: [
                      BezierCurveSection(
                        start: Offset(screenWidth, 0),
                        top: Offset(screenWidth / 2, 30),
                        end: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Container(
                    color: Colors.white,
                    height: screenHeight-300,
                    child: Column(
                      children: [
                        SizedBox(height: 40,),
                        Container(
                          width: 350,
                          height: 350,
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 200,
                                child: _buildText(context, model.selectedFromDate, "Select From Date",
                                        () async {
                                      model.selectedFromDate =
                                      await DateTimePickerDialog().pickBeforeDateDialog(context);
                                      if (model.selectedFromDate == null) {
                                        model.selectedFromDate = "Select From Date";
                                      }
                                      setState(() {

                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child:
                                _buildText(context, model.selectedToDate, "Select To Date", () async {
                                  model.selectedToDate =
                                  await DateTimePickerDialog().pickDateDialog(context);
                                  if (model.selectedToDate == null) {
                                    model.selectedToDate = "Select To Date";
                                  }
                                  setState(() {

                                  });
                                }),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  onPressed: () {
                                    model.getGarageReport(model.ownGarageList[0].id,model.selectedFromDate,model.selectedToDate);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(
                                      "Search",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildText(
      BuildContext context, String label, String label1, Function onClick) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              label1,
              style: TextStyle(
                color: Color(0xff1B1B1B),
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                      color: Color(0xff1B1B1B),
                      fontSize: 15,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
