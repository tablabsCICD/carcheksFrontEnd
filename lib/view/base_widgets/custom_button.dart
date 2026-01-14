import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/util/custom_text_style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? buttonText;
  final bool isEnable; // 🔹 FROM USER

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    required this.isEnable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ElevatedButton(
        // 🔹 ENABLE / DISABLE BASED ON isEnable
        onPressed: isEnable ? onTap : null,

        style: ElevatedButton.styleFrom(
          backgroundColor: isEnable
              ? ColorResources.BUTTON_COLOR
              : Colors.grey.shade400,
          foregroundColor: Colors.white,
          elevation: isEnable ? 3 : 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Text(
            buttonText ?? '',
            style: titilliumBold.copyWith(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
