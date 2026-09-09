import 'package:flutter/material.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/screens/user_screen/payment.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';
import 'package:story_teller/widget/story_image.dart';

class StoryPage extends StatefulWidget {
  final String? storyTitle;
  final String? storyDesc;
  final String? storyImage;

  const StoryPage(
      {super.key, this.storyTitle, this.storyDesc, this.storyImage});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 22, top: 22),
        child: SizedBox(
          height: size.height * 0.07,
          width: double.infinity,
          child: ElevatedButton2(
            onTap: () {
              showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return PaymentPage();
                  });
            },
            text: context.t('DOWNLOAD STORY'),
            color: AppColors.mainBlue,
            height: size.height * 0.065,
            width: size.width * 1,
            redius: BorderRadius.circular(15),
          ),
        ),
      ),
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          widget.storyTitle ?? "",
          style: TextStyle(fontFamily: 'Carlito bold', fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppStoryImage(
              imageUrl: widget.storyImage,
              height: size.height * 0.27,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(10),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 16, left: 16, top: 20, bottom: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Text(
                        widget.storyDesc ?? "",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
