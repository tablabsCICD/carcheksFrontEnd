import 'dart:convert';

import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/model/garage_model.dart';
import 'package:carcheks/model/paypal_request.dart';
import 'package:carcheks/provider/appointment_provider.dart';
import 'package:carcheks/provider/cart_provider.dart';
import 'package:carcheks/provider/payment_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/custom_textfield.dart';
import 'package:carcheks/view/screens/customer/customer_dashboard.dart';
import 'package:carcheks/view/screens/customer/wheels_tyres_1.dart';
import 'package:carcheks/view/screens/payment_methods/PaypalServices.dart';
import 'package:carcheks/view/screens/payment_methods/payment_complete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:provider/provider.dart';
import '../../../locator.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/user_order_service_provider.dart';
import 'notes.dart';
import 'package:flutter/material.dart';

class EstimateDetails extends StatefulWidget {
  Garage? garage;
  String? date, time, notes;

  // EstimateDetails({this.garage,this.date,this.time,this.notes});

  final orderProvider = locator<UserOrderServicesProvider>();
  final authProvider = locator<AuthProvider>();

  EstimateDetails({Key? key, this.garage, this.date, this.time, this.notes})
    : super(key: key) {
    // orderProvider.getUserOrderServicesByUserId(authProvider.user!.id);
    // orderProvider.getUserOrderServicesByOrderId(orderProvider.userOrderServicesList[0].userOrderId!.id!);
  }

  @override
  _EstimateDetailsState createState() => _EstimateDetailsState();
}

class _EstimateDetailsState extends State<EstimateDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController noteController = TextEditingController();
  PaymentProvider paymentProvider = locator<PaymentProvider>();
  AppointmentProvider appointmentProvider = locator<AppointmentProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteController.text = widget.notes.toString();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Estimate Details"),
      body: Stack(
        children: [
          Consumer<UserOrderServicesProvider>(
            builder: (context, model, child) => Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.garage == null
                          ? " "
                          : widget.garage!.name.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorResources.BUTTON_COLOR,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/location.svg"),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.garage == null
                                ? " "
                                : "${widget.garage!.addressDtls!.houseName},${widget.garage!.addressDtls!.street},"
                                      "${widget.garage!.addressDtls!.landmark},${widget.garage!.addressDtls!.cityname},"
                                      "${widget.garage!.addressDtls!.state},${widget.garage!.addressDtls!.country}",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Date: ",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.date == null
                                  ? "Please Select date"
                                  : widget.date.toString(),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Time: ",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              //"01:30 PM",
                              widget.time == null
                                  ? "02:00 PM"
                                  : widget.time.toString(),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 2),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Services Requested",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        /*     Icon(
                          Icons.edit,
                          color: ColorResources.PRIMARY_COLOR,
                        ),
                   */
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      model
                          .servicesListByOrderId[0]
                          .garageServices!
                          .mainService!
                          .name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: ColorResources.TEXTFEILD_COLOR,
                      ),
                      child: TextFormField(
                        controller: noteController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add Note",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    //   SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Services',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        /*  Text('----------',
                            style: TextStyle(fontSize: 15, color: Colors.black)),*/
                        Text(
                          'Price',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                        Text('----------',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                        Text('1',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                        Text('----------',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                        Text('\$${model.servicesListByOrderId[0].garageServices!.cost}',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Extended',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                        Text('----------',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                        Text('\$${model.servicesListByOrderId[0].garageServices!.cost}',
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                      ],
                    ),*/
                    getGarageServices(),
                    SizedBox(height: 10),
                    Divider(thickness: 1),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SubTotal :',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${model.totalAmount}',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Taxes :',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        /*Text('\$${model.totalAmount*0.29}'*/
                        Text(
                          '\$ 0',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price :',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //Text('\$${model.totalAmount+(model.totalAmount*0.29)}',
                        Text(
                          '\$${model.totalAmount + 0}',
                          style: TextStyle(fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.view_column_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text('------1234',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.black)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Edit",
                          ),
                        )
                      ],
                    )*/
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: ProsteBezierCurve(
                position: ClipPosition.top,
                list: [
                  BezierCurveSection(
                    start: Offset(screenWidth, 30),
                    top: Offset(screenWidth / 2, 0),
                    end: Offset(0, 30),
                  ),
                ],
              ),
              child: Container(color: ColorResources.PRIMARY_COLOR, height: 80),
            ),
          ),
          Positioned(
            bottom: 45,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Consumer<AppointmentProvider>(
                builder: (context, model, child) => CustomButton(
                  buttonText: "Pay & Book Appointment",
                  isEnable: true,
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: Text(
                          'Are you sure want to book your appointment?',
                          style: Style.heading,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes', style: Style.okButton),
                            onPressed: () async {
                              makePayment();

                              //  testingPayment();
                            },
                          ),
                          TextButton(
                            child: Text('no', style: Style.cancelButton),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getGarageServices() {
    return Consumer<UserOrderServicesProvider>(
      builder: (context, model, child) => Container(
        height: 100,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: model.servicesListByOrderId.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model
                        .servicesListByOrderId[index]
                        .garageServices!
                        .subService!
                        .name,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Text(
                    '\$${model.servicesListByOrderId[index].garageServices!.cost}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  CartProvider cartProvider = locator<CartProvider>();

  void makePayment() {
    PaypalRequest paypalRequest = PaypalRequest();
    ItemList itemList = ItemList();
    itemList.shippingAddress = ShippingAddress(
      recipientName:
          cartProvider.cartItemList[0].garageServicesdtls!.garage!.name,
      line1:
          "${cartProvider.cartItemList[0].garageServicesdtls!.garage!.addressDtls!.houseName} ${cartProvider.cartItemList[0].garageServicesdtls!.garage!.addressDtls!.street}",
      line2: cartProvider
          .cartItemList[0]
          .garageServicesdtls!
          .garage!
          .addressDtls!
          .landmark,
      city: cartProvider
          .cartItemList[0]
          .garageServicesdtls!
          .garage!
          .addressDtls!
          .cityname,
      countryCode: "US",
      postalCode: cartProvider
          .cartItemList[0]
          .garageServicesdtls!
          .garage!
          .addressDtls!
          .zipCode,
      phone: cartProvider
          .cartItemList[0]
          .garageServicesdtls!
          .garage!
          .contactNumber,
      state: cartProvider
          .cartItemList[0]
          .garageServicesdtls!
          .garage!
          .addressDtls!
          .state,
    );
    itemList.items = cartProvider.itemList;
    Amount amount = Amount();
    amount.currency = "USD";
    amount.total = cartProvider.totalAmount.toString();
    amount.details = Details(
      subtotal: cartProvider.totalAmount.toString(),
      shipping: "0",
      shippingDiscount: 0,
    );
    paypalRequest.itemList = itemList;
    paypalRequest.description = "The payment transaction description.";
    paypalRequest.amount = amount;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: false,
          clientId: AppConstants.payPal_ClientId,
          secretKey: AppConstants.PayPal_SecretKey,
          returnURL: "carchek://paypal/success",
          cancelURL: "carchek://paypal/cancel",
          transactions: [paypalRequest.toJson()],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            try {
              debugPrint("onSuccess: $params");
              paymentProvider.orderId = await paymentProvider.createOrder(
                totalAmt: cartProvider.totalAmount,
                garageId:
                    cartProvider.cartItemList[0].garageServicesdtls!.garage!.id,
                invoiceNumber: params['token'],
              );
              paymentProvider.transactionId = params['paymentId'];
              debugPrint("Transaction Id: ${paymentProvider.transactionId}");

              String jsonString = jsonEncode(params);
              var transactionResponse = await paymentProvider.updateTransaction(
                paymentProvider.transactionId!,
                jsonString,
              );
              debugPrint("Transaction Response: $transactionResponse");

              if (paymentProvider.orderId != null) {
                await appointmentProvider.SaveAppointment(
                  accept: true,
                  active: true,
                  availableTime: "${widget.time}",
                  date: "${widget.date}",
                  orderId: widget
                      .orderProvider
                      .servicesListByOrderId[0]
                      .userOrderId!
                      .id,
                  status: 'New Arrival',
                  time: "${widget.time}",
                  paypalId: paymentProvider.id.toString(),
                );
              }
              checkNext(true, jsonString);
            } catch (e) {
              debugPrint("Error processing success: $e");
            }
          },
          onError: (error) {
            debugPrint("onError: $error");
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Payment Error"),
                content: Text("Something went wrong. Please try again."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
            checkNext(false, 'NA');
          },
          onCancel: (params) {
            debugPrint('cancelled: $params');
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Payment Cancelled"),
                content: Text("You have cancelled the payment."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> checkNext(bool? isSuccess, String jsonString) async {
    /*var statusResponse = await paymentProvider.checkOrderStatus(orderId: paymentProvider.orderId);
    debugPrint("Payment Status Response:"+statusResponse);*/

    Future.delayed(Duration(seconds: 1), () {
      isSuccess == true
          ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    PaymentStatus(isPaymentCompleted: true, title: "Success"),
              ),
              (Route<dynamic> route) => false,
            )
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    PaymentStatus(isPaymentCompleted: false, title: "Error"),
              ),
            );
    });
  }

  Map<String, dynamic> dummyPaypalSuccessParams = {
    "paymentId": "PAYID-MOCK123456789",
    "payerID": "PAYERMOCK987654",
    "token": "EC-MOCKTOKEN123456",
    "status": "success",
    "intent": "sale",
    "state": "approved",
    "create_time": DateTime.now().toIso8601String(),
    "update_time": DateTime.now().toIso8601String(),
    "amount": {"total": "500.00", "currency": "INR"},
    "payer": {
      "email": "testuser@paypal.com",
      "first_name": "Test",
      "last_name": "User",
      "payer_id": "PAYERMOCK987654",
    },
    "transactions": [
      {
        "invoice_number": "INV-${DateTime.now().millisecondsSinceEpoch}",
        "description": "Garage service payment (dummy)",
      },
    ],
  };

  Future<void> testingPayment() async {
    try {
      // 🔹 Dummy PayPal success response
      final params = dummyPaypalSuccessParams;

      debugPrint("onSuccess: $params");

      paymentProvider.orderId = await paymentProvider.createOrder(
        totalAmt: cartProvider.totalAmount,
        garageId: cartProvider.cartItemList[0].garageServicesdtls!.garage!.id,
        invoiceNumber: params['token'], // dummy token
      );

      paymentProvider.transactionId = params['paymentId']; // dummy paymentId
      debugPrint("Transaction Id: ${paymentProvider.transactionId}");

      String jsonString = jsonEncode(params);

      var transactionResponse = await paymentProvider.updateTransaction(
        paymentProvider.transactionId!,
        jsonString,
      );

      debugPrint("Transaction Response: $transactionResponse");

      if (paymentProvider.orderId != null) {
        await appointmentProvider.SaveAppointment(
          accept: true,
          active: true,
          availableTime: "${widget.time}",
          date: "${widget.date}",
          orderId:
              widget.orderProvider.servicesListByOrderId[0].userOrderId!.id,
          status: 'New Arrival',
          time: "${widget.time}",
          paypalId: paymentProvider.transactionId, // dummy PayPal ID
        );
      }

      checkNext(true, jsonString);
    } catch (e) {
      debugPrint("Error processing success: $e");
    }
  }
}
