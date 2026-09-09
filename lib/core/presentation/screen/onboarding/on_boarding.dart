import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/core/constant/app_constant.dart';
import 'package:story_teller/core/presentation/screen/select/screen1.dart';
import 'package:story_teller/features/home/presentation/data/model/onBoardingProvider.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Consumer<OnBoardingProvider>(
          builder: ((context, pageProvider, child) => Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: pageProvider.pageController,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 22,
                                      left: 22,
                                    ),
                                    child: Center(
                                        child: SizedBox(
                                      height: size.height * 0.34,
                                      child: Image.asset(
                                        onBoard[index].image,
                                        fit: BoxFit.fill,
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: size.height * 0.04),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 21),
                                    child: SizedBox(
                                      height: size.height * 0.12,
                                      child: Text(
                                        onBoard[index].title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Carlito Bold',
                                            fontSize: 30),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 21),
                                    child: Text(
                                      onBoard[index].description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Carlito Regular',
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.025),
                          ],
                        );
                      },
                      onPageChanged: (index) {
                        pageProvider.changePage(index);
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onBoard.length,
                          (index) => Container(
                            margin: EdgeInsets.all(1),
                            height: size.height * 0.003,
                            width: size.width * 0.18,
                            //coloring
                            color: pageProvider.currentIndex == index
                                ? AppColors.mainBlue
                                : AppColors.indicator,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      if (pageProvider.currentIndex >= 3) ...{
                        ElevatedButton2(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectScreen1(),
                                ));
                          },
                          text: 'NEXT',
                          color: AppColors.mainBlue,
                          height: size.height * 0.065,
                          width: size.width * 0.9,
                          redius: BorderRadius.circular(15),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                      } else ...{
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: size.height * 0.04,
                                width: size.width * 0.20,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelectScreen1(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.mainBlue,
                                        foregroundColor: AppColors.white),
                                    child: Text(
                                      'SKIP',
                                      style: TextStyle(
                                          fontFamily: 'Carlito Regular',
                                          fontSize: 12),
                                    )),
                              ),
                              CircleAvatar(
                                backgroundColor: AppColors.mainBlue,
                                foregroundColor: AppColors.white,
                                child: IconButton(
                                    onPressed: () {
                                      pageProvider.pageController.nextPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.fastOutSlowIn);
                                    },
                                    icon: Icon(Icons.arrow_forward)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                      }
                    ],
                  )
                ],
              )),
        ));
  }
}
