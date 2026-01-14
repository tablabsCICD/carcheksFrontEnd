import 'package:carcheks/locator.dart';
import 'package:carcheks/model/garage_services_model.dart';
import 'package:carcheks/util/style.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GarageServiceCard extends StatefulWidget {
  GarageService service;
  bool? cost;

  GarageServiceCard(this.service, {Key? key, this.cost}) : super(key: key);

  @override
  State<GarageServiceCard> createState() => _GarageServiceCardState();
}

class _GarageServiceCardState extends State<GarageServiceCard> {
  final cartProvider = locator<CartProvider>();
  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // cartProvider.getCartByUserId(authProvider.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    print('the link is ${widget.service.photosUrl}');
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            //await cartProvider.getCartByUserId(authProvider.user!.id);
            showDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                title: const Text(
                  'Add to cart',
                  // style: Style.heading,
                ),
                actions: <Widget>[
                  Consumer<CartProvider>(
                    builder: (context, model, child) => TextButton(
                      child: Text("Yes", style: Style.okButton),
                      onPressed: () async {
                        await cartProvider.getCartByUserId(
                          authProvider.user!.id,
                        );
                        if (cartProvider.cartItemList.isNotEmpty) {
                          if (cartProvider
                                  .cartItemList[0]
                                  .garageServicesdtls!
                                  .garage!
                                  .id
                                  .toString() ==
                              widget.service.garage!.id.toString()) {
                            var result = await cartProvider.addToCart(
                              garageService: widget.service,
                              usertableId: authProvider.user!.id,
                              currentOrderId: 0,
                              totalAmt: widget.service.cost,
                            );
                            if (result['data'] != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Service added successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Something went wrong,service not added in cart',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please add services of one garage at a time',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        } else {
                          var result = await cartProvider.addToCart(
                            garageService: widget.service,
                            usertableId: authProvider.user!.id,
                            currentOrderId: 0,
                            totalAmt: 0,
                          );
                          if (result['data'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Service added successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Something went wrong,service not added in cart',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ),
                  TextButton(
                    child: Text("No", style: Style.cancelButton),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: Stack(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: widget.service.isServiceSelected == true
                        ? Colors.white
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      widget.service.isServiceSelected == true
                          ? const BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 5,
                              color: Colors.grey,
                            )
                          : const BoxShadow(),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                        child: Image.network(
                          widget.service.photosUrl == ''
                              ? "https://media.gettyimages.com/id/900416228/photo/mechanic-works-on-car-in-his-home-garage.jpg?s=2048x2048&w=gi&k=20&c=AG4FxbEKVaivN3dAeYVq8Eklg6XPHPKhkk8nODaLpyQ="
                              : widget.service.photosUrl,
                          height: 70.0,
                          width: 140,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(widget.service.subService!.name.toUpperCase()),
                    ],
                  ),
                ),
              ),
              widget.service.isServiceSelected == true
                  ? const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                          size: 20,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
