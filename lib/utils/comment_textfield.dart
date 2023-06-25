import 'package:flutter/material.dart';

import '../services/colors.dart';

class CommentTextfield extends StatelessWidget {
  const CommentTextfield(
      {super.key,
      required this.controller,
      required this.onTap,
      required this.hintText});
  final TextEditingController controller;
  final void Function() onTap;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            cursorColor: backgroundColor,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: backgroundColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: backgroundColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.4))),
            child: Icon(
              Icons.send,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        )
      ],
    );
  }
}
