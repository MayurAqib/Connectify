import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentsBox extends StatelessWidget {
  const CommentsBox(
      {super.key,
      required this.commentAuthor,
      required this.commentText,
      required this.commentTime});
  final String commentAuthor;
  final String commentText;
  final String commentTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                commentAuthor,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                commentTime,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              )
            ],
          ),
          Text(
            commentText,
            style: GoogleFonts.montserrat(color: Colors.black.withOpacity(0.8)),
          )
        ],
      ),
    );
  }
}
