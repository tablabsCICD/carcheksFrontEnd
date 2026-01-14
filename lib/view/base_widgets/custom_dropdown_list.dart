import 'package:carcheks/util/color-resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropdownList extends StatelessWidget {
  final String hintText;
  final String selectedType;
  final List<String> items;
  final Function(String) onChange;
  final Function? onTap;

  const CustomDropdownList({
    Key? key,
    required this.hintText,
    required this.selectedType,
    required this.items,
    required this.onChange,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 🔑 Add hint as first fake item
    final List<String> dropdownItems = [hintText, ...items];

    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: FormBuilderDropdown<String>(
          name: hintText,

          /// ✅ Initial value shows hint
          initialValue: selectedType.isNotEmpty ? selectedType : hintText,

          decoration: InputDecoration(
            filled: true,
            fillColor: ColorResources.TEXTFEILD_COLOR,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),

          /// ❌ Validation: hint is NOT valid
          validator: (value) {
            if (value == null || value == hintText) {
              return "Please select a valid option";
            }
            return null;
          },

          items: dropdownItems.map((value) {
            final bool isHint = value == hintText;

            return DropdownMenuItem<String>(
              value: value,
              enabled: !isHint, // ❌ hint not selectable
              child: Text(
                value,
                style: TextStyle(color: isHint ? Colors.grey : Colors.black),
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value != null && value != hintText) {
              onChange(value);
            }
          },
        ),
      ),
    );
  }
}
