import 'package:connectify/services/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GoogleNavbar extends StatelessWidget {
  const GoogleNavbar({super.key, required this.onTabChange});
  final void Function(int)? onTabChange;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: textColor.withOpacity(0.2))),
      ),
      child: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        onTabChange: (value) => onTabChange!(value),
        padding: const EdgeInsets.all(15),
        tabs: [
          GButton(
            icon: Icons.home,
            iconColor: Colors.black,
            iconActiveColor: darkDesign,
          ),
          GButton(
            icon: Icons.message,
            iconColor: Colors.black,
            iconActiveColor: darkDesign,
          ),
          GButton(
            icon: Icons.person,
            iconColor: Colors.black,
            iconActiveColor: darkDesign,
          )
        ],
      ),
    );
  }
}
