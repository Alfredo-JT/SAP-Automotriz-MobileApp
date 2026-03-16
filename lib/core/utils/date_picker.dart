import 'package:flutter/material.dart';

Future<DateTime> datePicker(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    return picked;
  } else {
    return DateTime.now();
  }
}
