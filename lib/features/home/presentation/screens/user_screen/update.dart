import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: size.height * 0.08,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          context.t('Update Profile'),
          style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 22),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: ((context, profileProvider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    context.t("Your Child's Name"),
                    style:
                        TextStyle(fontSize: 16, fontFamily: 'Carlito Regular'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.grey,
                    ),
                    child: TextField(
                      style: TextStyle(
                          fontSize: 18, fontFamily: 'Carlito Regular'),
                      controller: profileProvider.textEditingController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 22),
                  child: Text(
                    context.t('Select Profile Picture'),
                    style:
                        TextStyle(fontSize: 16, fontFamily: 'Carlito Regular'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: profileProvider.image.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          profileProvider
                              .changeImage(profileProvider.image[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Image.asset(
                            profileProvider.image[index],
                            width: size.width * 0.26,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 31),
                  child: ElevatedButton2(
                    onTap: () {
                      String name = profileProvider.textEditingController.text;

                      profileProvider.saveName(name);
                      Navigator.pop(context);
                    },
                    text: context.t('COMPLETE'),
                    color: AppColors.mainBlue,
                    height: size.height * 0.065,
                    width: size.width * 0.94,
                    redius: BorderRadius.circular(15),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
