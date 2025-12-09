import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../util/style.dart';

getLoader(context, isloading){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

dismissLoader(context){
  Navigator.of(context).pop();
}


