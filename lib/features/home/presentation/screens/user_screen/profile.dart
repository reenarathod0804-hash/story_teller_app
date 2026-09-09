import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/features/home/presentation/screens/user_screen/language.dart';
import 'package:story_teller/features/home/presentation/screens/user_screen/privacy.dart';
import 'package:story_teller/features/home/presentation/screens/user_screen/update.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  void initState() {
    final profileProvider = context.read<ProfileProvider>();
    profileProvider.nameBox = Hive.box('StoryBook');
    profileProvider.isChecked =
        profileProvider.nameBox.get('selectedLanguage', defaultValue: 0);
    profileProvider.isNotification =
        profileProvider.nameBox.get('notification', defaultValue: true);
    profileProvider.check =
        profileProvider.nameBox.get('language', defaultValue: 'English');
    profileProvider.textEditingController.text =
        profileProvider.nameBox.get('username', defaultValue: '');

    profileProvider
        .setImage(profileProvider.nameBox.get('images', defaultValue: null));
    super.initState();
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
            context.t('Profile'),
            style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 22),
          ),
        ),
        body: Consumer<ProfileProvider>(
            builder: ((context, profileProvider, child) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 21, vertical: 31),
                          child: Column(
                            children: [
                              Container(
                                height: size.height * 0.093,
                                decoration: BoxDecoration(
                                    color: AppColors.mainBlue,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: SizedBox(
                                          height: size.height * 0.13,
                                          width: size.width * 0.13,
                                          child: CircleAvatar(
                                              backgroundColor: AppColors.grey,
                                              foregroundColor:
                                                  AppColors.mainBlue,
                                              child: profileProvider.imageURL !=
                                                      null
                                                  ? Image.asset(
                                                      profileProvider.imageURL
                                                          .toString(),
                                                    )
                                                  : Icon(
                                                      Icons.person,
                                                      size: 30,
                                                    )),
                                        ),
                                      ),
                                      Text(
                                        profileProvider.textEditingController
                                                .text.isEmpty
                                            ? context.t('Username')
                                            : profileProvider
                                                .textEditingController.text,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.white,
                                            fontFamily: 'Carlito Bold'),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Update(),
                                                ));
                                          },
                                          child: Text(
                                            context.t('Edit'),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.white),
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 24),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Update(),
                                                  ));
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: AppColors.white,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              onTap: () {
                                profileProvider.isNotification;
                              },
                              leading: CircleAvatar(
                                  backgroundColor: AppColors.mainBlue,
                                  child: Icon(
                                    Icons.notifications,
                                    color: AppColors.white,
                                  )),
                              title: Text(
                                context.t('Notification'),
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Carlito Bold'),
                              ),
                              trailing: SizedBox(
                                width: size.width * 0.12,
                                height: size.height * 0.04,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Switch(
                                    activeTrackColor: AppColors.mainBlue,
                                    activeThumbColor: AppColors.white,
                                    value: profileProvider.isNotification,
                                    onChanged: (value) {
                                      profileProvider.changeNot(value);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Language()));
                              },
                              leading: CircleAvatar(
                                  backgroundColor: AppColors.mainBlue,
                                  child: Icon(
                                    Icons.language,
                                    color: AppColors.white,
                                  )),
                              title: Text(
                                context.t('Language'),
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Carlito Bold'),
                              ),
                              trailing: Text(
                                profileProvider.check,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Carlito Regular'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrivacyScreen(),
                                    ));
                              },
                              leading: CircleAvatar(
                                  backgroundColor: AppColors.mainBlue,
                                  child: Icon(
                                    Icons.privacy_tip,
                                    color: AppColors.white,
                                  )),
                              title: Text(
                                context.t('Privacy Policy'),
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Carlito Bold'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 22),
                            child: ElevatedButton2(
                              onTap: () {
                                
                              },
                              text: context.t('LOGOUT'),
                              color: AppColors.mainBlue,
                              height: size.height * 0.07,
                              redius: BorderRadius.circular(15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}
