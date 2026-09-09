import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/features/home/presentation/data/model/storyProfileProvider.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/loading.dart';
import 'package:story_teller/features/home/presentation/widget/category.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';
import 'package:story_teller/widget/story_image.dart';

class StoryProfile extends StatefulWidget {
  final String? storyId;
  final String? storyCategoryId;
  final String? storyTitle;
  final String? categoryTitle;
  final String? categoryDesc;
  final String? image;
  final String? storyDesc;
  final String? storyImage;

  const StoryProfile({
    super.key,
    this.storyId,
    this.storyCategoryId,
    this.storyTitle,
    this.categoryDesc,
    this.categoryTitle,
    this.image,
    this.storyDesc,
    this.storyImage,
  });

  @override
  State<StoryProfile> createState() => StoryProfileState();
}

class StoryProfileState extends State<StoryProfile> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    flutterTts = FlutterTts();
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        title: Text(
          widget.storyTitle?.isNotEmpty == true
              ? widget.storyTitle!
              : (widget.categoryTitle ?? ""),
          style: const TextStyle(fontFamily: 'Carlito bold', fontSize: 22),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Consumer<StoryProfileProvider>(
        builder: ((context, searchProvider, child) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  expandedHeight: size.height * 0.48,
                  flexibleSpace: FlexibleSpaceBar(
                    background: AppStoryImage(
                      imageUrl: widget.storyImage,
                      seed: widget.storyTitle,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('5 Minutes'),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Carlito Regular'),
                              ),
                              Text(
                                context.t('4+ Age'),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Carlito Regular'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.storyTitle ?? '',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Carlito bold',
                                ),
                              ),
                              if (widget.categoryTitle != null &&
                                  widget.categoryTitle!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.categoryTitle!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.mainBlue,
                                    fontFamily: 'Carlito Regular',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            context.t('See More'),
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Carlito Bold',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: size.height * 0.16,
                          child: ValueListenableBuilder(
                            valueListenable: Hive.box('storiesBox').listenable(),
                            builder: (context, Box box, child) {
                              var allStories = box.values
                                  .cast<Map<String, dynamic>>()
                                  .toList();

                              var relatedStories = allStories
                                  .where((s) =>
                                      (widget.storyCategoryId == null ||
                                          s['category_id'] ==
                                              widget.storyCategoryId) &&
                                      s['story_name'] != widget.storyTitle)
                                  .toList();

                              if (relatedStories.isEmpty) {
                                relatedStories = allStories
                                    .where((s) =>
                                        s['story_name'] != widget.storyTitle)
                                    .toList();
                              }

                              return ListView.builder(
                                  itemCount: relatedStories.length > 4
                                      ? 4
                                      : relatedStories.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, indexStory) {
                                    var story = relatedStories[indexStory];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StoryProfile(
                                              storyId: story['id'],
                                              storyCategoryId:
                                                  story['category_id'],
                                              categoryTitle:
                                                  widget.categoryTitle,
                                              categoryDesc:
                                                  widget.categoryDesc,
                                              storyTitle: story['story_name'],
                                              storyImage: story['image'],
                                              storyDesc: story['story_desc'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        width: size.width * 0.25,
                                        height: size.height * 0.13,
                                        child: AppStoryImage(
                                          imageUrl: story['image'],
                                          seed: story['id'] ?? story['story_name'],
                                          fit: BoxFit.cover,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                        if (widget.storyCategoryId != null &&
                            widget.storyCategoryId!.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 115),
                            child: Center(
                              child: SizedBox(
                                width: size.width * 0.31,
                                height: size.height * 0.045,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Category(
                                            storyCategoryId:
                                                widget.storyCategoryId,
                                            categoryName: widget.categoryTitle,
                                          ),
                                        ));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    side: const BorderSide(
                                      color: AppColors.mainBlue,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        context.t('See More'),
                                        style: const TextStyle(
                                            color: AppColors.mainBlue,
                                            fontFamily: ' Carlito Regular',
                                            fontSize: 14),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 7),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: AppColors.mainBlue,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton2(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Loading(
                                            categoryTitle: widget.categoryTitle,
                                            storyTitle: widget.storyTitle,
                                            storyDesc: widget.storyDesc,
                                            storyImage: widget.storyImage,
                                          )));
                            },
                            text: context.t('START STORY'),
                            color: AppColors.mainBlue,
                            height: size.height * 0.065,
                            width: size.width * 1,
                            redius: BorderRadius.circular(15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Container(
                              width: size.width * 0.39,
                              height: size.height * 0.077,
                              decoration: BoxDecoration(
                                  color: AppColors.mainBlue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Image.asset(
                                          'assets/images/png/audiomini.png',
                                          height: size.height * 0.035,
                                          width: size.width * 0.25,
                                        ),
                                      ),
                                      Text(
                                        context.t('Voiceover'),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.white,
                                            fontFamily: 'Carlito Regular'),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.width * 0.11,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Switch(
                                        activeTrackColor: AppColors.grey,
                                        activeThumbColor: AppColors.mainBlue,
                                        value: searchProvider.isNotification,
                                        onChanged: (value) async {
                                          searchProvider
                                              .changeNotification(value);

                                          var langCode = Provider.of<
                                                      ProfileProvider>(context,
                                                  listen: false)
                                              .currentLocale
                                              .languageCode;

                                          if (value) {
                                            if (langCode == 'hi') {
                                              await flutterTts
                                                  .setLanguage('hi-IN');
                                            } else if (langCode == 'es') {
                                              await flutterTts
                                                  .setLanguage('es-ES');
                                            } else if (langCode == 'en') {
                                              await flutterTts
                                                  .setLanguage('en-US');
                                            }

                                            await flutterTts
                                                .setSpeechRate(0.45);
                                            await flutterTts.setPitch(1.0);

                                            await flutterTts.speak(
                                                widget.storyDesc ?? '');
                                          } else {
                                            await flutterTts.stop();
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, bottom: 84),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.grey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                widget.storyDesc ?? "",
                                style: const TextStyle(
                                    fontSize: 16, height: 1.5),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

