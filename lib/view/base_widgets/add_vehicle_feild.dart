import 'dart:ui';

import 'package:carcheks/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/services.dart';
import 'package:wc_form_validators/wc_form_validators.dart';


class AddVehicleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? lableText;
  final TextInputType textInputType;
  final int maxLine;
  final bool isPhoneNumber;
  final bool isValidator;
  final bool isName;
  final bool isEmail;
  final bool isPassword;
  final TextCapitalization capitalization;
  final IconData? iconData;
  final IconData? iconSuffix;
  final bool? obsecure;
  final bool? readOnly;
  final String? validatorMsg;
  final Function? onTap;

  AddVehicleTextField({
    required this.controller,
    required this.hintText,
    this.lableText,
    required this.textInputType,
    this.maxLine = 1,
    this.validatorMsg,
    this.isEmail = false,
    this.isName = false,
    this.isPhoneNumber = false,
    this.isValidator = false,
    this.isPassword = false,
    this.capitalization = TextCapitalization.none,
    this.iconData,
    this.obsecure,
    this.readOnly,
    this.iconSuffix,
    this.onTap
  });

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          controller: controller,
          onTap: () {
            onTap!();
          },
          keyboardType: textInputType,
          inputFormatters: [
            isPhoneNumber
                ? FilteringTextInputFormatter.digitsOnly
                : FilteringTextInputFormatter.singleLineFormatter
          ],
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
              : isValidator
              ? Validators.required('This field is required')
              : null,
          readOnly: readOnly == null ? false : true,
          obscureText: isPassword,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            labelText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(iconSuffix), onPressed: () {
            },
            ),
          ),
        )
    );
  }
}

