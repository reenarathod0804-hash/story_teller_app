import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/homeProvider.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/exitApp.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/searchbar.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/story_profile.dart';
import 'package:story_teller/features/home/presentation/widget/category.dart';
import 'package:story_teller/features/home/presentation/screens/user_screen/profile.dart';
import 'package:story_teller/widget/story_image.dart';
import 'package:story_teller/widget/home_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final imageProvider = context.read<ProfileProvider>();
    imageProvider.nameBox = Hive.box('StoryBook');

    imageProvider
        .setImage(imageProvider.nameBox.get('images', defaultValue: null));

    final homeProviders = context.read<HomeProvider>();
    homeProviders.getCategoriesFromHive();
    homeProviders.getStoriesFromHive();
    homeProviders.fetchCategoriesAndStoreInHive(context);
    homeProviders.fetchStoriesAndStoreInHive(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        showModalBottomSheet<void>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return ExitApp();
            });
      },
      child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            centerTitle: true,
            surfaceTintColor: AppColors.white,
            backgroundColor: AppColors.white,
            toolbarHeight: size.height * 0.08,
            title: Text(
              context.t('Welcome To Story Tell'),
              style: TextStyle(fontFamily: 'Carlito bold', fontSize: 22),
            ),
            leading: SizedBox(),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: size.height * 0.1,
                    width: size.width * 0.1,
                    child: CircleAvatar(
                        backgroundColor: AppColors.icon,
                        foregroundColor: AppColors.white,
                        child: Provider.of<ProfileProvider>(context).imageURL !=
                                null
                            ? Image.asset(
                                Provider.of<ProfileProvider>(context)
                                    .imageURL
                                    .toString(),
                              )
                            : Icon(Icons.person)),
                  ),
                ),
              )
            ],
          ),
          body: Consumer<HomeProvider>(
            builder: ((context, homeProvider, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColors.grey,
                          ),
                          child: TextField(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Search(),
                                  ));
                            },
                            style: TextStyle(fontSize: 14),
                            focusNode: null,
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 2),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Search(),
                                            ));
                                      },
                                      icon: Icon(Icons.search))),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 17),
                              hintText: context
                                  .t('Search for your favourite stories...'),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.hintColor,
                                  fontFamily: 'Carlito Regular'),
                              border: InputBorder.none,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Expanded(
                      child: homeProvider.isLoading || homeProvider.categories.isEmpty
                          ? const HomeShimmer()
                          : ListView.builder(
                                  itemCount: homeProvider.categories.length,
                                  itemBuilder: (context, categoryIndex) {
                          var category = homeProvider.categories[categoryIndex];

                          var filteredStories = homeProvider.stories
                              .where((story) =>
                                  story['category_id'] == category['id'])
                              .toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  category['name'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Carlito Regular'),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    category['desc'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Carlito Regular'),
                                  )),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              SizedBox(
                                  height: size.height * 0.16,
                                  child: ListView.builder(
                                      itemCount: filteredStories.length > 4
                                          ? 4
                                          : filteredStories.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, storyIndex) {
                                        var story = filteredStories[storyIndex];

                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoryProfile(
                                                          storyCategoryId:
                                                              category['id'],
                                                          categoryTitle:
                                                              category['name'],
                                                          storyTitle: story[
                                                              'story_name'],
                                                          storyDesc: story[
                                                              'story_desc'],
                                                          categoryDesc:
                                                              category['desc'],
                                                          storyImage:
                                                              story['image'],
                                                        )));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            width: size.width * 0.25,
                                            height: size.height * 0.13,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: AppStoryImage(
                                              imageUrl: story['image'],
                                              seed: story['story_name'] ?? story['id'],
                                              width: size.width * 0.25,
                                              height: size.height * 0.13,
                                              fit: BoxFit.cover,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      })),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 115),
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
                                                storyCategoryId: category['id'],
                                                categoryName: category['name'],
                                              ),
                                            ));
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        side: BorderSide(
                                          color: AppColors.mainBlue,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            context.t('See More'),
                                            style: TextStyle(
                                                color: AppColors.mainBlue,
                                                fontFamily: ' Carlito Regular',
                                                fontSize: 14),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 7),
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
                          );
                        },
                      ),
                    ),
                  ],
                )),
          )),
    );
  }
}
