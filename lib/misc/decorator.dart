import 'package:flutter/material.dart';

import 'colors.dart';

class Decorator {
  static const fieldDecorator = InputDecoration(
    // prefixIcon: Icon(Icons.email),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static final projectFieldDecorator = InputDecoration(
    hintText: 'Select Project',
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColor.mainColor, width: 1),
        borderRadius: BorderRadius.circular(8)),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.mainColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static const fieldDecoratorwithIcon = InputDecoration(
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static const fieldStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    height: 1,
  );

  static InputDecoration fieldDecorate(String hint) {
    return InputDecoration(
      hintText: hint,

      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
