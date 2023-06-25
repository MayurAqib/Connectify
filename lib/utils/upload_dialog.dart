import 'package:flutter/material.dart';

import '../services/colors.dart';

class UploadDialog extends StatelessWidget {
  const UploadDialog(
      {super.key,
      required this.camera,
      required this.gallery,
      required this.onCancel,
      required this.onSave});
  final void Function() gallery;
  final void Function() camera;
  final void Function() onSave;
  final void Function() onCancel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: gallery,
            child: const Text(
              'Gallery',
              style: TextStyle(color: textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: TextButton(
                onPressed: camera,
                child:
                    const Text('Camera', style: TextStyle(color: textColor))),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: onSave, child: const Text('Save')),
        TextButton(onPressed: onCancel, child: const Text('Cancel'))
      ],
    );
  }
}
