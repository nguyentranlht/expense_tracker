
import 'package:flutter/material.dart';

class AppDialog {
  static Future<T?> confirm<T>({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = 'Hủy',
    String confirmText = 'Xác nhận',
    Color? confirmColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                if (onCancel != null) onCancel();
                Navigator.of(context).pop();
              },

              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () {
                if (onConfirm != null) onConfirm();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: confirmColor ?? Colors.red),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}