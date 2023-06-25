import 'package:connectify/services/colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key, required this.buttonText, required this.onTap, this.width});
  final String buttonText;
  final void Function() onTap;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 63,
        decoration: BoxDecoration(
            color: darkDesign, borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: Text(
          buttonText,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
    );
  }
}
