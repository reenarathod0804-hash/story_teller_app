import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';

class ExitApp extends StatelessWidget {
  const ExitApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 21, right: 16, left: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.grey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.height * 0.03),
            Text(
              "Exit App",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontFamily: 'Inter Bold'),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Want To Sure You Are Exit The App?",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton2(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    text: 'YES',
                    color: AppColors.mainBlue,
                    height: size.height * 0.07,
                    width: size.height * 0.17,
                    redius: BorderRadius.circular(15),
                  ),
                  ElevatedButton2(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: 'NO',
                    color: AppColors.exit,
                    height: size.height * 0.07,
                    width: size.height * 0.17,
                    redius: BorderRadius.circular(15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
