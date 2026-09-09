import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/core/presentation/screen/select/screen2.dart';
import 'package:story_teller/features/home/presentation/data/model/selectScreenProvider.dart';
import 'package:story_teller/widget/custom_elevate_button2.dart';

class SelectScreen1 extends StatefulWidget {
  const SelectScreen1({super.key});

  @override
  State<SelectScreen1> createState() => SelectScreen1State();
}

class SelectScreen1State extends State<SelectScreen1> {


 @override
  void initState() {
   final selectProvider = context.read<SelectProvider>();
   selectProvider.settingBox=Hive.box('StoryBook');
   selectProvider.isSelect=selectProvider.settingBox.get('selectedAgeIndex',defaultValue: 0);
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
            'Select Your Age',
            style: TextStyle(fontSize: 25, fontFamily: 'Carlito Bold'),
          ),
        ),
        body: Consumer<SelectProvider>(
            builder: ((context, selectedProvider, child) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selectedProvider.age.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // selectedProvider.selectAge(index);
                              selectedProvider.selectedAge(index);
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: selectedProvider.isSelect== index
                                        ? AppColors.mainBlue
                                        : AppColors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      selectedProvider.age[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                          selectedProvider.isSelect== index
                                                  ? AppColors.white
                                                  : Colors.black,
                                          fontFamily: 'Carlito Regular'),
                                    ),
                                  ),
                                )),
                          );
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
                                  builder: (context) => SelectScreen2(),
                                ));
                          },
                          text: 'NEXT',
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
