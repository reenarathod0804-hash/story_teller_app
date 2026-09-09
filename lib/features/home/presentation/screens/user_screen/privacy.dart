import 'package:flutter/material.dart';
import 'package:story_teller/appExtension.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          context.t('Privacy Policy'),
          style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 22),
        ),
      ),
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.t('policyDesk'),textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text(context.t('1. Information We Collect'),style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 18),
              ),
              Text(context.t('We may collect the following information:')),
              Text(context.t('Language preference:'),style: TextStyle(fontFamily: 'Carlito Bold')),
              Text(context.t('To provide stories in your chosen language.')),
              Text(context.t('Profile picture (optional):'),style: TextStyle(fontFamily: 'Carlito Bold')),
              Text(context.t('Only if you choose to upload it in your profile settings.')),
              Text(context.t('Search activity:'),style: TextStyle(fontFamily: 'Carlito Bold')),
              Text(context.t('To improve story recommendations (not stored permanently).')),
              Text(context.t('Device info:'),style: TextStyle(fontFamily: 'Carlito Bold')),
              Text(context.t('Such as Android/iOS version, only for analytics and crash tracking.')),
              SizedBox(height: 10,),
              Text(context.t('2. How We Use Your Information'),style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 18),
              ),
              Text(context.t('We use the collected information to:')),
              Text(context.t('● Show stories in your preferred language.')),
              Text(context.t('● Personalize your app experience.')),
              Text(context.t('● Improve the performance and quality of the app.')),
              Text(context.t('● Fix bugs and crashes using anonymous crash reports.')),
              SizedBox(height: 10,),
              Text(context.t('3. Data Storage'),style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 18),
              ),
              Text(context.t('● Data is stored securely using Firebase and Hive (local storage).')),
              Text(context.t('● We do not share your data with third parties.')),
              Text(context.t('● You can delete the app at any time to remove local data.')),
              SizedBox(height: 10,),
              Text(context.t('4. Children’s Privacy'),style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 18),
              ),
              Text(context.t('4rth desc')),
              SizedBox(height: 10,),
              Text(context.t('5. Your Choices'),style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 18),
              ),
              Text(context.t('You can:')),
              Text(context.t('● Change language settings anytime.')),
              Text(context.t('● Remove your profile photo from the app.')),
              Text(context.t('● Clear your local data by uninstalling the app.')),
              SizedBox(height: 10,),
              Text(context.t('6. Changes to This Policy'),style: TextStyle(fontFamily: 'Carlito Bold', fontSize: 18),
              ),
              Text(context.t('6th desc')),
              SizedBox(height: 50,),
            ],
          ),
        ),
      )
      ,
    );
  }
}
