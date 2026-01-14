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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final cartProvider = locator<CartProvider>();
  final userOrderServiceProvider = locator<UserOrderServicesProvider>();
  final vehicleProvider = locator<VehicleProvider>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartProvider.getCartByUserId(authProvider.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "My Cart"),
      body: Consumer<CartProvider>(
        builder: (context, model, child) {
          /// ✅ 1. LOADER (simple & correct)
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ✅ 2. EMPTY CART
          if (model.cartItemList.isEmpty) {
            return Center(
              child: Text("Your cart is empty", style: Style.heading),
            );
          }

          /// ✅ 3. EXISTING UI (UNCHANGED)
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 250,
                margin: const EdgeInsets.all(10),
                color: Colors.white,
                child: ListView.builder(
                  itemCount: model.cartItemList.length,
                  itemBuilder: (context, index) {
                    final item = model.cartItemList[index];

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.garageServicesdtls!.photosUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item
                                          .garageServicesdtls!
                                          .subService!
                                          .name!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 9),
                                    Text(
                                      item
                                          .garageServicesdtls!
                                          .shortDiscribtion!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Text(
                                          "\$",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          item.garageServicesdtls!.cost
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                        'Are you sure to remove this service from cart',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await model.removeCartItem(item);
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
                                          child: Text(
                                            "Yes",
                                            style: Style.okButton,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            "No",
                                            style: Style.cancelButton,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// CHECKOUT BAR (UNCHANGED)
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Cart Value"),
                          Text(
                            "\$ ${model.getTotalAmount()}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.BUTTON_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await model.getFinalCartList();
                          await userOrderServiceProvider.saveUserOrderService(
                            status: "Pending",
                            invoiceNumber: "number",
                            totalAmt: model.totalAmount.toInt(),
                            vehicleId: vehicleProvider.selectedUserVehicle!.id,
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.notes,
                            arguments: model
                                .cartItemList
                                .first
                                .garageServicesdtls!
                                .garage,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
