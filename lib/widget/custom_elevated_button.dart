import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback onTap;
  final Color? color;
  final String? buttonText;
  final EdgeInsetsGeometry? padding;

  const CustomElevatedButton(
      {super.key,
      this.width,
      this.height,
      this.borderRadius,
      required this.onTap,
      this.color,
      this.buttonText,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
              borderRadius: borderRadius

        ),
        child: Center(child: Text(buttonText ?? "",style: TextStyle(fontSize: 14,fontFamily: 'Carlito bold'),)),
      ),
    );
  }
}
