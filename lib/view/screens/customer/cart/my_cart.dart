import 'dart:ui';

import 'package:carcheks/dialog/animated_custom_dialog.dart';
import 'package:carcheks/dialog/my_dialog.dart';
import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/cart_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/user_order_service_provider.dart';

class MyCart extends StatefulWidget {
  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final authProvider = locator<AuthProvider>();
  final cartProvider = locator<CartProvider>();
  final userOrderServiceProvider = locator<UserOrderServicesProvider>();
  final vehicleProvider = locator<VehicleProvider>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    cartProvider.getCartByUserId(authProvider.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "My Cart"),
      body: Stack(
        children: [
          /// ================= MAIN CONTENT =================
          Consumer<CartProvider>(
            builder: (context, model, child) {
              if (model.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (model.cartItemList.isEmpty) {
                return Center(
                  child: Text(
                    "Your cart is empty",
                    style: Style.heading,
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: model.cartItemList.length,
                      itemBuilder: (context, index) {
                        final item = model.cartItemList[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.garageServicesdtls!.photosUrl == ''
                                        ? "https://media.gettyimages.com/id/900416228/photo/mechanic-works-on-car-in-his-home-garage.jpg"
                                        : item.garageServicesdtls!.photosUrl,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.garageServicesdtls!.subService!.name!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.garageServicesdtls!
                                            .shortDiscribtion!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            '\$',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const SizedBox(width: 1),
                                          Text(
                                            item.garageServicesdtls!.cost
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                        title: const Text(
                                            'Remove this service from cart?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              await model.removeCartItem(item);
                                              Navigator.pop(context);
                                              showAnimatedDialog(
                                                context,
                                                const MyDialog(
                                                  icon: Icons.check,
                                                  title: 'Item',
                                                  description:
                                                  'Successfully removed',
                                                  isFailed: false,
                                                ),
                                                dismissible: false,
                                                isFlip: false,
                                              );
                                            },
                                            child: Text("Yes",
                                                style: Style.okButton),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("No",
                                                style: Style.cancelButton),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.delete,
                                      color: Colors.red),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// ================= CHECKOUT BAR =================
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Cart Value"),
                            Text(
                              "\$ ${model.getTotalAmount()}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              ColorResources.BUTTON_COLOR,
                            ),
                            onPressed: model.isCheckoutLoading
                                ? null
                                : () async {
                              try {
                                model.setCheckoutLoading(true);

                                await model.getFinalCartList();

                                await userOrderServiceProvider
                                    .saveUserOrderService(
                                  status: "Pending",
                                  invoiceNumber: "number",
                                  totalAmt:
                                  model.totalAmount.toInt(),
                                  vehicleId: vehicleProvider
                                      .selectedUserVehicle!.id,
                                );

                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.notes,
                                  arguments: model.cartItemList[0]
                                      .garageServicesdtls!
                                      .garage,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Something went wrong")),
                                );
                              } finally {
                                model.setCheckoutLoading(false);
                              }
                            },
                            child: model.isCheckoutLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text("Checkout"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          /// ================= FULL SCREEN LOADER =================
          Consumer<CartProvider>(
            builder: (context, model, _) {
              if (!model.isCheckoutLoading) return const SizedBox();
              return Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
