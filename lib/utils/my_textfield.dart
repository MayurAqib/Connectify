import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.keyboard,
      this.icon});
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconButton? icon;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: keyboard,
        cursorColor: Colors.black,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            suffixIcon: icon,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8))),
      ),
    );
  }
}
