import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final bool hasText;
  final String letter;
  final double imageRadius;
  final ImageProvider? imageProvider;
  const CircleImage({
    Key? key,
    this.imageProvider,
    this.imageRadius = 30,
    this.hasText = false,
    this.letter = 'a'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: imageRadius,
      child: Text(
        letter.substring(0, 1),
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 45,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }
}
