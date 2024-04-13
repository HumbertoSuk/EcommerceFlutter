import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: onPressed != null ? color : color?.withOpacity(0.5),
        ),
        child: Builder(
          builder: (BuildContext context) {
            if (icon != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(color: textColor),
                  ),
                ],
              );
            } else {
              return Text(
                text,
                style: TextStyle(color: textColor),
              );
            }
          },
        ),
      ),
    );
  }
}
