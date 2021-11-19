import 'package:flutter/material.dart';

textFormFieldDecoration(String label, BuildContext context) {
  return InputDecoration(
    fillColor: Colors.grey.shade300,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 0),
    ),
    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    labelText: label,
  );
}
