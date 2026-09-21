import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => LanguageState();
}

class LanguageState extends State<Language> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.tempSelectedIndex = provider.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.08,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            'Language',
            style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 22),
          ),
        ),
        body: Consumer<ProfileProvider>(
            builder: ((context, languageProvider, child) => Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: languageProvider.names.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                  onTap: () {
                                    languageProvider.savedLang(index);
                                  },
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: CircleAvatar(
                                        backgroundColor: AppColors.mainBlue,
                                        child: Icon(
                                          Icons.language,
                                          color: AppColors.white,
                                        )),
                                  ),
                                  title: Text(
                                    languageProvider.names[index],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Carlito Bold'),
                                  ),
                                  trailing:
                                      languageProvider.tempSelectedIndex ==
                                              index
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                  'assets/images/png/check.png'),
                                            )
                                          : SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                  'assets/images/png/unselect.png'),
                                            )),
                            ),
                          );
                        }),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    ElevatedButton2(
                      onTap: () {
                        if (languageProvider.tempSelectedIndex != null) {
                          languageProvider.saveLang(
                            languageProvider
                                .names[languageProvider.tempSelectedIndex!],
                            languageProvider.tempSelectedIndex!,
                            context,
                          );
                        }
                        Navigator.pop(context);
                      },
                      text: 'COMPLETE',
                      color: AppColors.mainBlue,
                      height: size.height * 0.065,
                      width: size.width * 0.94,
                      redius: BorderRadius.circular(15),
                    ),
                  ],
                ))));
  }
}
