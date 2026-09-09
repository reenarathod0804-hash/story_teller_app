import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/story_profile.dart';
import 'package:story_teller/features/home/presentation/screens/user_screen/profile.dart';
import 'package:story_teller/widget/story_image.dart';

class Category extends StatelessWidget {
  final String? storyCategoryId;
  final String? categoryName;

  const Category({super.key, this.storyCategoryId, this.categoryName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        toolbarHeight: size.height * 0.08,
        title: Text(
          categoryName ?? "",
          style: const TextStyle(fontFamily: 'Carlito bold', fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.1,
                child: CircleAvatar(
                  backgroundColor: AppColors.icon,
                  foregroundColor: AppColors.white,
                  child: Provider.of<ProfileProvider>(context).imageURL != null
                      ? Image.asset(
                          Provider.of<ProfileProvider>(context)
                              .imageURL
                              .toString(),
                        )
                      : const Icon(Icons.person),
                ),
              ),
            ),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('storiesBox').listenable(),
        builder: (context, Box box, child) {
          var allStories = box.values.cast<Map<String, dynamic>>().toList();

          var filterStories = allStories
              .where((story) => story['category_id'] == storyCategoryId)
              .toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 15),
              itemCount: filterStories.length,
              itemBuilder: (context, index) {
                var story = filterStories[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryProfile(
                            storyCategoryId: storyCategoryId,
                            storyTitle: story['story_name'],
                            categoryTitle: categoryName,
                            storyDesc: story['story_desc'],
                            storyImage: story['image'],
                          ),
                        ),
                      );
                    },
                    child: AppStoryImage(
                      imageUrl: story['image'],
                      seed: story['id'] ?? story['story_name'],
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(10),
                    ));
              },
            ),
          );
        },
      ),
    );
  }
}
