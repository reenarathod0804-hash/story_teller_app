import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/features/home/presentation/data/model/searchProvider.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/story_profile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();

    final searchProvider = context.read<SearchProvider>();
    searchProvider.fetchCategories();
    searchProvider.fetchStories();

    Future.microtask(() {
      final query = searchProvider.searchController.text;
      if (query.isNotEmpty) {
        searchProvider.filterSearchResults(context, query);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var langCode = Provider.of<ProfileProvider>(context, listen: false).currentLocale.languageCode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 60, bottom: 10, right: 16),
              child: Container(
                width: size.width * 0.92,
                height: size.height * 0.064,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.grey,
                ),
                child: TextField(
                  controller: searchProvider.searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    hintText: context.t('Search for your favourite stories...'),
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.hintColor,
                        fontFamily: 'Carlito Regular'),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    searchProvider.filterSearchResults(context, query);
                  },
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (searchProvider.searchController.text.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 18),
                        child: Text(
                          context.t('Searched Categories'),
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Carlito Bold'),
                        ),
                      ),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9 / 0.3,
                          crossAxisSpacing: 11,
                          mainAxisSpacing: 11,
                        ),
                        shrinkWrap: true,
                        itemCount: searchProvider.filteredCategories.length,
                        itemBuilder: (context, index) {
                          var data = searchProvider.filteredCategories[index];
                          return GestureDetector(
                            onTap: () {
                              searchProvider
                                  .filterStoriesByCategory(data['id']);
                              searchProvider.searchController.text =
                                  Map<String, dynamic>.from(data['name'])[langCode] ?? '';
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    Map<String, dynamic>.from(data['name'])[langCode] ?? '',
                                    style: const TextStyle(
                                        fontFamily: 'Carlito Regular',
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    if (searchProvider.selectedCat != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 18),
                        child: Text(
                          context.t('Stories of categories'),
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Carlito Bold'),
                        ),
                      ),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchProvider.filteredStories.length,
                          itemBuilder: (context, index) {
                            var story = searchProvider.filteredStories[index];
                            String title = '';
                            if (story['story_name'] is Map) {
                              title = story['story_name'][langCode] ??
                                  story['story_name']['en'] ??
                                  '';
                            } else {
                              title = story['story_name']?.toString() ?? '';
                            }

                            String desc = '';
                            if (story['story_desc'] is Map) {
                              desc = story['story_desc'][langCode] ??
                                  story['story_desc']['en'] ??
                                  '';
                            } else {
                              desc = story['story_desc']?.toString() ?? '';
                            }

                            String catName = '';
                            if (story['category_name'] is Map) {
                              catName = story['category_name'][langCode] ??
                                  story['category_name']['en'] ??
                                  '';
                            } else {
                              catName = story['category_name']?.toString() ?? '';
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryProfile(
                                      storyId: story['id'],
                                      storyCategoryId: story['category_id'],
                                      storyTitle: title,
                                      storyDesc: desc,
                                      storyImage: story['image'],
                                      categoryTitle: catName.isNotEmpty
                                          ? catName
                                          : context.t('Searched Stories'),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 12),
                                    child: Text(title),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      if (searchProvider.searchController.text.isNotEmpty &&
                          searchProvider.selectedCat == null) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 18),
                          child: Text(
                            context.t('Searched Stories'),
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'Carlito Bold'),
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchProvider.filteredStories.length,
                          itemBuilder: (context, index) {
                            var story = searchProvider.filteredStories[index];
                            String title = '';
                            if (story['story_name'] is Map) {
                              title = story['story_name'][langCode] ??
                                  story['story_name']['en'] ??
                                  '';
                            } else {
                              title = story['story_name']?.toString() ?? '';
                            }

                            String desc = '';
                            if (story['story_desc'] is Map) {
                              desc = story['story_desc'][langCode] ??
                                  story['story_desc']['en'] ??
                                  '';
                            } else {
                              desc = story['story_desc']?.toString() ?? '';
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryProfile(
                                      storyId: story['id'],
                                      storyCategoryId: story['category_id'],
                                      storyTitle: title,
                                      storyDesc: desc,
                                      storyImage: story['image'],
                                      categoryTitle:
                                          context.t('Searched Stories'),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: Text(title),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
