import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/story_page.dart';

import 'package:story_teller/widget/story_image.dart';

class Loading extends StatefulWidget {
  final String? storyTitle;
  final String? categoryTitle;
  final String? storyDesc;
  final String? storyImage;

  const Loading(
      {super.key,
      this.storyTitle,
      this.categoryTitle,
      this.storyDesc,
      this.storyImage});

  @override
  State<Loading> createState() => LoadingState();
}

class LoadingState extends State<Loading> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StoryPage(
              storyTitle: widget.storyTitle,
              storyDesc: widget.storyDesc,
              storyImage: widget.storyImage,
            ),
          ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          widget.categoryTitle ?? '',
          style: const TextStyle(fontFamily: 'Carlito bold', fontSize: 22),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 98),
              child: AppStoryImage(
                imageUrl: widget.storyImage,
                height: size.height * 0.3,
                width: size.width * 0.45,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Lottie.asset('assets/animation/musicloader.json'),
            Text(
              context.t('Loading...'),
              style: TextStyle(fontSize: 25, fontFamily: 'Carlito Regular'),
            )
          ],
        ),
      ),
    );
  }
}
