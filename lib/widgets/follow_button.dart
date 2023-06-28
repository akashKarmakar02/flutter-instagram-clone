import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  const FollowButton({
    super.key,
    this.function,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          height: 32,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
