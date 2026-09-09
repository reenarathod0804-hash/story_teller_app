import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/features/home/presentation/data/model/selectScreenProvider.dart';
import 'package:story_teller/features/home/presentation/screens/home_screen/homeScreen.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';

class SelectScreen2 extends StatefulWidget {
  const SelectScreen2({super.key});

  @override
  State<SelectScreen2> createState() => SelectScreen2State();
}

class SelectScreen2State extends State<SelectScreen2> {
  @override
  void initState() {
    final selectProvider = context.read<SelectProvider>();
    selectProvider.settingBox = Hive.box('StoryBook');
    selectProvider.isSelectFavourite =
        selectProvider.settingBox.get('selectedFavIndex', defaultValue: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.09,
          leading: SizedBox(),
          centerTitle: true,
          title: Text(
            'Select Your Favourite',
            style: TextStyle(fontSize: 22, fontFamily: 'Carlito Bold'),
          ),
        ),
        body: Consumer<SelectProvider>(
            builder: ((context, selectFavourites, child) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selectFavourites.favourite.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                selectFavourites.selectedFav(index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 11),
                                decoration: BoxDecoration(
                                    color: selectFavourites.isSelectFavourite ==
                                            index
                                        ? AppColors.mainBlue
                                        : AppColors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  title: Text(
                                    selectFavourites.favourite[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Carlito Regular',
                                        color: selectFavourites
                                                    .isSelectFavourite ==
                                                index
                                            ? AppColors.white
                                            : Colors.black),
                                  ),
                                ),
                              ));
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 34),
                        child: ElevatedButton2(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                          text: "LET'S START",
                          color: AppColors.mainBlue,
                          height: size.height * 0.065,
                          width: size.width * 1,
                          redius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
