import 'dart:ui';

import 'package:carcheks/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/services.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class RegistrationTextFeild extends StatefulWidget {
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
  final bool? readOnly;
  final String? validatorMsg;
  final Function? onTap;

  const RegistrationTextFeild({
    Key? key,

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
    this.readOnly,

    this.onTap,

    required,
  }) : super(key: key);

  @override
  _RegistrationTextFeildState createState() => _RegistrationTextFeildState();
}

class _RegistrationTextFeildState extends State<RegistrationTextFeild> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: widget.controller,
        onTap: () {
          if (widget.onTap != null) widget.onTap!();
        },
        keyboardType: widget.textInputType,
        maxLines: widget.maxLine,
        textCapitalization: widget.capitalization,
        inputFormatters: [
          widget.isPhoneNumber
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.singleLineFormatter,
        ],
        validator: widget.isPhoneNumber
            ? Validators.compose([
                Validators.required('Phone number is required'),
                Validators.minLength(
                  10,
                  'Mobile number cannot be less than 10 digits',
                ),
                Validators.maxLength(
                  10,
                  'Mobile number cannot be greater than 10 digits',
                ),
              ])
            : widget.isEmail
            ? Validators.compose([
                Validators.required('Email is required'),
                Validators.email('Invalid email address'),
              ])
            : widget.isName
            ? Validators.compose([
                Validators.patternString(
                  r"^[A-Za-z]+$",
                  'Only alphabets are allowed',
                ),
                Validators.required('${widget.hintText} is required'),
              ])
            : widget.isPassword
            ? Validators.compose([
                Validators.required('Password is required'),
                Validators.minLength(
                  6,
                  'Password must be at least 6 characters',
                ),
                Validators.patternString(
                  r'^(?=.*[0-9])',
                  'Password must contain at least 1 number',
                ),
              ])
            : widget.isValidator
            ? Validators.required('This field is required')
            : null,
        readOnly: widget.readOnly ?? false,
        obscureText: widget.isPassword ? _isObscure : false,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          labelText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: const OutlineInputBorder(),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
