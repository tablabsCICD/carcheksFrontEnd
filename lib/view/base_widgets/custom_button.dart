import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/custom_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function onTap;
  final String? buttonText;
  CustomButton({required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
     // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: ElevatedButton(
        onPressed: (){
          onTap();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorResources.BUTTON_COLOR,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 10),
          child: Text(buttonText!,
              style: titilliumBold.copyWith(
                  fontSize: 16,
                  color: Colors.white
              )),
        ),
      ),
    );
  }
}

