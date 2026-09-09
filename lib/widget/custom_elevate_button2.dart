import 'package:flutter/material.dart';
import 'package:story_teller/configue/constant/colors.dart';

class ElevatedButton2 extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? redius;
  final String? text;
  final Color? color;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;


  const ElevatedButton2(
      {super.key,
      this.width,
      this.height,
      this.redius,
      this.text,
      this.color,
      required this.onTap,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: redius,
          color: color,
        ),child: Center(child: Text(text ?? '',style: TextStyle(color: AppColors.white,fontSize: 22,fontFamily: 'Carlito Bold'),)),
      ),
    );
  }
}
