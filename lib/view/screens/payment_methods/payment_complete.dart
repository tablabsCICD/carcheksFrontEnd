
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/screens/customer/customer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentStatus extends StatefulWidget {
  bool? isPaymentCompleted;
  String? title;
  PaymentStatus({super.key,this.isPaymentCompleted,this.title});

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    Color successColor = const Color(0xFF43D19E);
    Color errorColor = const Color(0xFFFD5A59);

    return Scaffold(
      key: _scaffoldKey,
     /* appBar: AppBar(
        leadingWidth: 35,
        backgroundColor: ColorResources.PRIMARY_COLOR,
        title: Text("",style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.bold),),
      ),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Lottie.asset(
                widget.isPaymentCompleted==true?'assets/animation/payment_success.json':'assets/animation/payment_fail.json',
            //  width: 300,
              height: 300,
              repeat: true,
              reverse: false,
              animate: true,
              fit:BoxFit.fill
            ),
          //  SizedBox(height: screenHeight * 0.1),
            Text(
              widget.isPaymentCompleted==true?"Thank You!":"Something went wrong!!!",
              style: TextStyle(
                color: widget.isPaymentCompleted==true?successColor:errorColor,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              widget.isPaymentCompleted==true?"Payment done Successfully":"Payment not completed..",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              widget.isPaymentCompleted==true?"Click here to return to home page":"Click here to go back and book your appointment",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child: GestureDetector(
                onTap: (){
                  widget.isPaymentCompleted==true
                      ?Navigator.pushNamedAndRemoveUntil(context, AppRoutes.customer_home, (route) => false)
                      :Navigator.of(context).pop(2);
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: widget.isPaymentCompleted==true?successColor:errorColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      widget.isPaymentCompleted==true?'Home': 'Go Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
