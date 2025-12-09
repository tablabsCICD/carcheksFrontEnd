import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropdownList extends StatelessWidget {
  //final String controller;
  final String hintText;
  String selectedType;
  List<String> items;
  final TextInputType? textInputType;
  final int maxLine;
  final bool isPhoneNumber;
  final bool isValidator;
  final TextCapitalization capitalization;
  final IconData? iconData;
  final bool? obsecure;
  final bool? readOnly;
  final String? validatorMsg;
  Function? onTap;
  Function onChange;

  CustomDropdownList(
      {
        required this.hintText,
        required this.selectedType,
        required this.items,
        this.textInputType,
        this.maxLine = 1,
        this.validatorMsg,
        this.isPhoneNumber = false,
        this.isValidator = false,
        this.capitalization = TextCapitalization.none,
        this.iconData,
        this.obsecure,
        this.readOnly,
        this.onTap,
        required this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          child: FormBuilderDropdown(
              name: hintText,
            //  allowClear: true,
              isDense: false ,
              decoration: InputDecoration.collapsed(
                hintText: '',
                filled: true,
                fillColor: ColorResources.TEXTFEILD_COLOR,
                border:OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: BorderSide.none
                ),
              ),
              disabledHint: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                child: Text(
                  hintText,
                 // style: Style.searchHint,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              items: items
                  .map((value) => DropdownMenuItem(
                value: value,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                  child: Text(
                    '$value',
                   // style: Style.dropdownValue,
                  ),
                ),
              )
              )
                  .toList(),
              onChanged: (String? value) {
                onChange(value);
              })),
    );
  }
}
