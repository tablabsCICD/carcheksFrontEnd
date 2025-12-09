
import 'package:carcheks/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart'as badge;
import '../../locator.dart';
import '../../provider/cart_provider.dart';
import '../screens/customer/cart/my_cart.dart';

class GetCart extends StatefulWidget {
  int? userId;
  final cartProvider = locator<CartProvider>();

  GetCart({Key? key,this.userId}) : super(key: key){

  }

  @override
  State<GetCart> createState() => _GetCartState();
}

class _GetCartState extends State<GetCart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.cartProvider.getCartByUserId(widget.userId!);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, model, child) => badge.Badge(
        position: badge.BadgePosition.topEnd(top: 6, end: 6),
        badgeStyle: badge.BadgeStyle(
        badgeColor: Colors.red),
        badgeContent: Text(
          model.cartItemList.length.toString(),
          style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
        ),
        child: IconButton(icon: Icon(Icons.shopping_cart,size: 35,color: Colors.black,), onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyCart()),
          );
         // Navigator.pushNamed(context, AppRoutes.cart);
        }),
      ),





    );
  }
}
