import 'package:flutter/material.dart';

class BoldFirstText extends StatelessWidget {
  final String label;
  final String text;

  const BoldFirstText({super.key, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.02,
            color: Colors.black,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.width * 0.02,
          ),
        ),
      ],
    );
  }
}
