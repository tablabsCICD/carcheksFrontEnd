import 'package:flutter/material.dart';

class SingleTextAlertDialog extends StatelessWidget {
  final String message;

  const SingleTextAlertDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(message ?? ' ', style: TextStyle()),
        ),
      ),
    );
  }
}
