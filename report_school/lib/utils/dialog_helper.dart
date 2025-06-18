import 'package:flutter/material.dart';
import '../component/window/dialog_window.dart';

class DialogHelper {
  static void showErrorDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onClose,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: SystemMessageCardOke(message: message),
      ),
    ).then((_) => onClose());
  }
}
// TODO Implement this library.