import 'package:flutter/material.dart';

SnackBar customSnackBar(String message) {
  return SnackBar(
    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
    margin: const EdgeInsetsDirectional.all(16),
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check,
            color: Colors.green,
          ),
          Text(
            message,
            style: const TextStyle(color: Colors.green),
          ),
        ],
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    elevation: 4.0,
    backgroundColor: Colors.white,
    closeIconColor: Colors.green,
    clipBehavior: Clip.hardEdge,
    dismissDirection: DismissDirection.horizontal,
  );
}
