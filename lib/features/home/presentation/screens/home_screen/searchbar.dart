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

    // Rebuild whenever text changes so history/clear button react instantly
    searchProvider.searchController.addListener(() {
      if (mounted) setState(() {});
    });

    Future.microtask(() {
      if (!mounted) return;
      final query = searchProvider.searchController.text;
      if (query.isNotEmpty) {
        searchProvider.filterSearchResults(context, query);
      }
    });
  }

  void _onSearchSubmitted(SearchProvider searchProvider, String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      searchProvider.addToHistory(trimmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var langCode = Provider.of<ProfileProvider>(context, listen: false)
        .currentLocale
        .languageCode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) => Column(
          children: [
            // ── Search bar ──────────────────────────────────────
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
                    hintText:
                        context.t('Search for your favourite stories...'),
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.hintColor,
                        fontFamily: 'Carlito Regular'),
                    border: InputBorder.none,
                    suffixIcon:
                        searchProvider.searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.hintColor, size: 20),
                                onPressed: () {
                                  searchProvider.searchController.clear();
                                  searchProvider.filterSearchResults(
                                      context, '');
                                },
                              )
                            : null,
                  ),
                  onChanged: (query) {
                    searchProvider.filterSearchResults(context, query);
                  },
                  onSubmitted: (query) =>
                      _onSearchSubmitted(searchProvider, query),
                ),
              ),
            ),

            // ── Body ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search History (shown when field is empty) ──
                    if (searchProvider.searchController.text.isEmpty &&
                        searchProvider.searchHistory.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16, left: 18, right: 12, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                context.t('Recent Searches'),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Carlito Bold'),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  searchProvider.clearHistory(),
                              child: Text(
                                context.t('Clear all'),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mainBlue,
                                  fontFamily: 'Carlito Regular',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchProvider.searchHistory.length,
                        itemBuilder: (context, index) {
                          final item =
                              searchProvider.searchHistory[index];
                          return GestureDetector(
                            onTap: () {
                              searchProvider.searchController.text =
                                  item;
                              searchProvider.filterSearchResults(
                                  context, item);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 13),
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.history,
                                      size: 18,
                                      color: Colors.grey.shade500),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Carlito Regular'),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => searchProvider
                                        .removeFromHistory(item),
                                    child: Icon(Icons.close,
                                        size: 16,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    // ── Searched Categories ──────────────────────
                    if (searchProvider.searchController.text.isNotEmpty &&
                        searchProvider.filteredCategories.isNotEmpty) ...[
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
                        itemCount:
                            searchProvider.filteredCategories.length,
                        itemBuilder: (context, index) {
                          var data =
                              searchProvider.filteredCategories[index];
                          return GestureDetector(
                            onTap: () {
                              searchProvider
                                  .filterStoriesByCategory(data['id']);
                              final catName =
                                  Map<String, dynamic>.from(
                                              data['name'])[langCode] ??
                                          '';
                              searchProvider.searchController.text =
                                  catName;
                              _onSearchSubmitted(
                                  searchProvider, catName);
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
                                    Map<String, dynamic>.from(
                                                data['name'])[langCode] ??
                                            '',
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

                    // ── Stories by Category ──────────────────────
                    if (searchProvider.selectedCat != null &&
                        searchProvider.filteredStories.isNotEmpty) ...[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 18),
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
                        itemCount:
                            searchProvider.filteredStories.length,
                        itemBuilder: (context, index) {
                          var story =
                              searchProvider.filteredStories[index];
                          String title = story['story_name'] is Map
                              ? story['story_name'][langCode] ??
                                  story['story_name']['en'] ??
                                  ''
                              : story['story_name']?.toString() ?? '';
                          String desc = story['story_desc'] is Map
                              ? story['story_desc'][langCode] ??
                                  story['story_desc']['en'] ??
                                  ''
                              : story['story_desc']?.toString() ?? '';
                          String catName =
                              story['category_name'] is Map
                                  ? story['category_name'][langCode] ??
                                      story['category_name']['en'] ??
                                      ''
                                  : story['category_name']
                                          ?.toString() ??
                                      '';

                          return GestureDetector(
                            onTap: () {
                              _onSearchSubmitted(
                                  searchProvider,
                                  searchProvider
                                      .searchController.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryProfile(
                                    storyId: story['id'],
                                    storyCategoryId:
                                        story['category_id'],
                                    storyTitle: title,
                                    storyDesc: desc,
                                    storyImage: story['image'],
                                    categoryTitle: catName.isNotEmpty
                                        ? catName
                                        : context
                                            .t('Searched Stories'),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 12),
                                  child: Text(title),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    // ── Direct Story Search Results ──────────────
                    if (searchProvider.searchController.text.isNotEmpty &&
                        searchProvider.selectedCat == null &&
                        searchProvider.filteredStories.isNotEmpty) ...[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 18),
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
                        itemCount:
                            searchProvider.filteredStories.length,
                        itemBuilder: (context, index) {
                          var story =
                              searchProvider.filteredStories[index];
                          String title = story['story_name'] is Map
                              ? story['story_name'][langCode] ??
                                  story['story_name']['en'] ??
                                  ''
                              : story['story_name']?.toString() ?? '';
                          String desc = story['story_desc'] is Map
                              ? story['story_desc'][langCode] ??
                                  story['story_desc']['en'] ??
                                  ''
                              : story['story_desc']?.toString() ?? '';

                          return GestureDetector(
                            onTap: () {
                              _onSearchSubmitted(
                                  searchProvider,
                                  searchProvider
                                      .searchController.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryProfile(
                                    storyId: story['id'],
                                    storyCategoryId:
                                        story['category_id'],
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
                              padding:
                                  const EdgeInsets.only(bottom: 10),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius:
                                      BorderRadius.circular(30),
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
