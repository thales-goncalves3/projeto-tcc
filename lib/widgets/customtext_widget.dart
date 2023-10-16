import 'package:flutter/material.dart';

class BoldFirstText extends StatelessWidget {
  final String label;
  final String text;

  const BoldFirstText({super.key, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.02,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: MediaQuery.of(context).size.width * 0.02,
            ),
          ),
        ],
      ),
    );
  }
}
