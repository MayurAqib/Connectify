import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails(
      {super.key,
      required this.section,
      required this.sectionText,
      this.icon,
      this.onpressed});
  final String section;
  final String sectionText;
  final void Function()? onpressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.grey,
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                sectionText,
                style: GoogleFonts.montserrat(color: Colors.grey.shade600),
              )
            ],
          ),
          IconButton(
            onPressed: onpressed,
            icon: Icon(
              icon,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
