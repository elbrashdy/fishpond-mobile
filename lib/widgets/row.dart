import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final List<Widget> widgetList;
  const RowWidget({
    Key? key,
    required this.widgetList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgetList,
    );
  }
}
