import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  final String text;
  final Color dividerColor;
  final double dividerThickness;
  final TextStyle textStyle;

  const DividerText({
    super.key,
    required this.text,
    this.dividerColor = Colors.black,
    this.dividerThickness = 1.0,
    this.textStyle = const TextStyle(fontSize: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: dividerThickness,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: dividerThickness,
          ),
        ),
      ],
    );
  }
}
