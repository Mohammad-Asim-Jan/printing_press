import 'package:flutter/material.dart';

import '../colors/color_palette.dart';
import '../text_styles/custom_text_styles.dart';

class DeleteAlertDialogue {
  static void confirmDelete(BuildContext context, VoidCallback? onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: kTitleText("Confirm Delete", null, kNew8),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: kTitleText("No", 12),
            ),
            TextButton(
              onPressed: onTap,
              child: kTitleText("Yes", null, kNew8),
            ),
          ],
        );
      },
    );
  }
}
