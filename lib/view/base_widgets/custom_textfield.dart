import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/services.dart';
import 'package:wc_form_validators/wc_form_validators.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? lableText;
  final TextInputType textInputType;
  final bool isPhoneNumber;
  final bool isValidator;
  final int maxLine;
  final bool isEmail;
  final bool isName;
  final bool isDigits;
  final TextCapitalization capitalization;
  final IconData? iconData;
  final bool? obsecure;
  final bool? readOnly;
  final String? validatorMsg;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.lableText,
    this.isName = false,
    this.isDigits = false,
    this.isEmail = false,
    required this.textInputType,
    this.maxLine = 1,
    this.validatorMsg,
    this.isPhoneNumber = false,
    this.isValidator = false,
    this.capitalization = TextCapitalization.none,
    this.iconData,
    this.obsecure,
    this.readOnly
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 15),
      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lableText==''?SizedBox.shrink():Text(lableText??'',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
          TextFormField(
            controller: controller,
            inputFormatters: [
              isPhoneNumber
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.singleLineFormatter
            ],
        //    style: Style.dropdownValue,
            validator: isPhoneNumber
                ? Validators.compose([
              Validators.required('Phone number is required'),
              Validators.minLength(
                  10, 'Mobile number cannot be less than 10 digit'),
              Validators.maxLength(
                  10, 'Mobile number cannot be greater than 10 digits'),
            ])
                : isEmail
                ? Validators.compose([
              Validators.required('Email is required'),
              Validators.email('Invalid email address'),
            ])
                : isName
                ? Validators.compose([
              Validators.patternString(
                  r"^[A-Za-z]+$", 'Only alphabets are allowed'),
              Validators.required('${hintText} is required'),
            ])
                : isDigits
                ? Validators.compose([
              Validators.patternRegExp(
                  RegExp(r"^[0-9]*$"), 'Only digits are allowed'),
              Validators.required('${hintText} is required'),
            ])
                : isValidator
                ? Validators.required('This field is required')
                : null,
            readOnly: readOnly == null ? false : true,
            decoration: InputDecoration(
               // prefixIcon: Icon(iconData),
                hintText: hintText,
            ),
            keyboardType: textInputType != null ? textInputType : TextInputType.text,
          ),
        ],
      ),
    );
  }
}

