import 'dart:ui';

import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/cart_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/base_widgets/custom_button.dart';
import 'package:carcheks/view/base_widgets/loader.dart';
import 'package:carcheks/view/screens/customer/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import '../../../../provider/user_order_service_provider.dart';

class MyCart extends StatefulWidget {
  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final authProvider = locator<AuthProvider>();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final cartProvider = locator<CartProvider>();
  final userOrderServiceProvider = locator<UserOrderServicesProvider>();
  final vehicleProvider = locator<VehicleProvider>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartProvider.getCartByUserId(authProvider.user!.id);
  }

  double totalCount = 0.0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "My Cart"),
      body: Consumer<CartProvider>(
        builder: (context, model, child) => (model.cartItemList.isEmpty ||
                    model.cartItemList.length == 0) &&
                (model.isLoading == false)
            ? Container(
                //  height: MediaQuery.of(context).size.height - 200,
                child: Center(
                    child: Text(
                "Your cart is empty",
                style: Style.heading,
              )))
            : model.isLoading == true
                ? getLoader(context, model.isLoading)
                : Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height - 250,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(0),
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: model.cartItemList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            child: Image.network(
                                              model
                                                          .cartItemList[index]
                                                          .garageServicesdtls!
                                                          .photosUrl ==
                                                      ''
                                                  ? "https://media.gettyimages.com/id/900416228/photo/mechanic-works-on-car-in-his-home-garage.jpg?s=2048x2048&w=gi&k=20&c=AG4FxbEKVaivN3dAeYVq8Eklg6XPHPKhkk8nODaLpyQ="
                                                  : model
                                                      .cartItemList[index]
                                                      .garageServicesdtls!
                                                      .photosUrl,
                                              height: 100.0,
                                              width: 100,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  model
                                                      .cartItemList[index]
                                                      .garageServicesdtls!
                                                      .subService!
                                                      .name
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  height: 9,
                                                ),
                                                Text(
                                                  model
                                                      .cartItemList[index]
                                                      .garageServicesdtls!
                                                      .shortDiscribtion
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  model
                                                      .cartItemList[index]
                                                      .garageServicesdtls!
                                                      .shortDiscribtion
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 9,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      model
                                                          .cartItemList[index]
                                                          .garageServicesdtls!
                                                          .subService!
                                                          .costing
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          color: Colors.grey),
                                                    ),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(
                                                      model
                                                          .cartItemList[index]
                                                          .garageServicesdtls!
                                                          .cost
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      CupertinoAlertDialog(
                                                        title: const Text(
                                                          'Are you sure to remove this service from cart',
                                                          // style: Style.heading,
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text("Yes",
                                                                style: Style
                                                                    .okButton),
                                                            onPressed:
                                                                () async {
                                                              model
                                                                  .removeCartItem(
                                                                      model.cartItemList[
                                                                          index])
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            print(value),
                                                                            showAnimatedDialog(
                                                                                context,
                                                                                const MyDialog(
                                                                                  icon: Icons.check,
                                                                                  title: 'Item',
                                                                                  description: 'Successfully removed',
                                                                                  isFailed: false,
                                                                                ),
                                                                                dismissible: false,
                                                                                isFlip: false),
                                                                          });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text("No",
                                                                style: Style
                                                                    .cancelButton),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ));
                                            },
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                  size: 18,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              })),
                      Container(
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.grey,
                                offset: Offset(
                                  0.0,
                                  0.0,
                                ),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                              )
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Cart Value",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "\$ " + model.getTotalAmount().toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorResources.BUTTON_COLOR,
                                  foregroundColor: Colors.white,
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                child: const Text("Checkout"),
                                onPressed: () async {
                                  if (model.cartItemList.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Please select atleast one service'),
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    await model.getFinalCartList();
                                    await userOrderServiceProvider
                                        .saveUserOrderService(
                                            status: "Pending",
                                            invoiceNumber: "number",
                                            totalAmt: model.totalAmount.toInt(),
                                            vehicleId: vehicleProvider
                                                .selectedUserVehicle!.id);
                                    Navigator.pushReplacementNamed(
                                        context, AppRoutes.notes,
                                        arguments: cartProvider.cartItemList[0]
                                            .garageServicesdtls!.garage);
                                    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Notes(garage: cartProvider.cartItemList[0].garageServicesdtls!.garage,)));
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
