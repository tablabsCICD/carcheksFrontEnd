import 'dart:convert';

import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/cart_provider.dart';
import 'package:carcheks/provider/payment_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/app_constants.dart';
import 'package:carcheks/view/screens/customer/customer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PaypalServices extends StatefulWidget {
  PaypalServices({Key? key}) : super(key: key);

  @override
  State<PaypalServices> createState() => _PaypalServicesState();
}

class _PaypalServicesState extends State<PaypalServices> {
  CartProvider cartProvider = locator<CartProvider>();
  PaymentProvider paymentProvider = locator<PaymentProvider>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartProvider.getFinalCartList();
   // paymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    return UsePaypal(
        sandboxMode: true,
        clientId: AppConstants.payPal_ClientId,
        secretKey: AppConstants.PayPal_SecretKey,
        returnURL: "https://samplesite.com/return",
        cancelURL: "https://samplesite.com/cancel",
        transactions: [
          {
            "amount": {
              "total": '${cartProvider.totalAmount}',
              "currency": "USD",
              "details": {
                "subtotal": '${cartProvider.totalAmount}',
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "The payment transaction description.",
            "item_list": {
              "items": //cartProvider.itemList,
              [
                {
                  "name": "Apple",
                  "quantity": 1,
                  "price": '1',
                  "currency": "USD"
                },
              ],
              // shipping address is not required though
              "shipping_address": {
                "recipient_name": cartProvider
                    .cartItemList[0].garageServicesdtls!.garage!.name,
                "line1": cartProvider.cartItemList[0].garageServicesdtls!
                    .garage!.addressDtls!.houseName +
                    " " +
                    cartProvider.cartItemList[0].garageServicesdtls!.garage!
                        .addressDtls!.street,
                "line2": cartProvider.cartItemList[0].garageServicesdtls!
                    .garage!.addressDtls!.garrageAddress,
                "city": cartProvider.cartItemList[0].garageServicesdtls!.garage!
                    .addressDtls!.cityname,
                "country_code": "US",
                "postal_code": cartProvider.cartItemList[0].garageServicesdtls!
                    .garage!.addressDtls!.zipCode,
                "phone": cartProvider
                    .cartItemList[0].garageServicesdtls!.garage!.contactNumber,
                "state": cartProvider.cartItemList[0].garageServicesdtls!
                    .garage!.addressDtls!.state
              },
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          debugPrint("onSuccess: $params");
          paymentProvider.orderId = await paymentProvider.createOrder(totalAmt:cartProvider.totalAmount,garageId: cartProvider.cartItemList[0].garageServicesdtls!.garage!.id);
          paymentProvider.transactionId = params['paymentId'];
          debugPrint("Transaction Id: ${paymentProvider.transactionId}");
          var statusResponse = await paymentProvider.checkOrderStatus(orderId: paymentProvider.orderId);
          debugPrint("Payment Status Response:"+statusResponse);

            /*String jsonString = jsonEncode(params);
            var transactionResponse = await paymentProvider.updateTransaction(paymentProvider.transactionId!,jsonString);
            debugPrint("Transaction Response:"+transactionResponse.toString());*/
         // Navigator.pop(context,transactionId);
        },
        onError: (error) {
          debugPrint("onError: $error");
        },
        onCancel: (params) {
          debugPrint('cancelled: $params');
        });
  }





}
