import 'package:connectify/pages/chat_rooms.dart';
import 'package:connectify/pages/profile_page.dart';
import 'package:connectify/pages/home.dart';
import 'package:flutter/material.dart';

import '../utils/google_navbar.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int selectedIndex = 0;

  void selectIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Color? appbarColor;
  // Color changeAppbarColor() {
  //   if (selectedIndex == 2) {
  //     appbarColor = backgroundColor;
  //   } else {
  //     appbarColor = backgroundColor;
  //   }
  //   return appbarColor!;
  // }

  final List pages = [const Home(), const ChatRoom(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: pages[selectedIndex],
      bottomNavigationBar: GoogleNavbar(
        onTabChange: (index) => selectIndex(index),
      ),
    );
  }
}
