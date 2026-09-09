import 'package:flutter/material.dart';
import 'package:story_teller/appExtension.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/widget/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatelessWidget {
  final String stripeLink = 'https://buy.stripe.com/test_eVa7vp3Ksg0CeIw28a';
  final String stripeLinkMonth =
      'https://buy.stripe.com/test_9AQ4jd80I8ya2ZOdQT';
  final String stripeLinkHalf =
      'https://buy.stripe.com/test_aEUbLF80I7u6cAobIM';

  const PaymentPage({super.key});

  static Future<void> _launchURL(String url) async {
    final Uri? uri = Uri.tryParse(url);

    if (uri != null) {
      try {
        if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
          debugPrint("Cannot launch URL");
        }
      } catch (e) {
        debugPrint('Error: ${e.toString()}');
      }
    } else {
      debugPrint('Invalid URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 58, left: 58, top: 24),
            child: Text(
              context.t('DownloadTitle'),
              style: TextStyle(fontSize: 30, fontFamily: 'Carlito Regular'),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.mainBlue,
                        borderRadius: BorderRadius.circular(17)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(
                          context.t('Monthly Plan'),
                          style: TextStyle(
                              fontSize: 19,
                              color: AppColors.white,
                              fontFamily: 'Carlito Bold'),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          context.t('₹1,499/Month'),
                          style: TextStyle(
                              fontSize: 19,
                              color: AppColors.white,
                              fontFamily: 'Carlito Bold'),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        CustomElevatedButton(
                          height: size.height * 0.045,
                          width: size.width * 0.35,
                          borderRadius: BorderRadius.circular(17),
                          buttonText: context.t('MONTHLY PLAN'),
                          color: AppColors.grey,
                          onTap: () {
                            _launchURL(stripeLinkHalf);
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.mainBlue,
                        borderRadius: BorderRadius.circular(17)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(
                          context.t('6-Monthly Plan'),
                          style: TextStyle(
                              fontSize: 19,
                              color: AppColors.white,
                              fontFamily: 'Carlito Bold'),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          context.t('₹7,499'),
                          style: TextStyle(
                              fontSize: 19,
                              color: AppColors.white,
                              fontFamily: 'Carlito Bold'),
                        ),
                        Text(
                          context.t('₹1,249/Month'),
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                              fontFamily: 'Carlito Bold'),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        CustomElevatedButton(
                          height: size.height * 0.045,
                          width: size.width * 0.35,
                          borderRadius: BorderRadius.circular(17),
                          buttonText: context.t('6-MONTHLY PLAN'),
                          color: AppColors.grey,
                          onTap: () {
                            _launchURL(stripeLinkMonth);
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.mainBlue,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('Annual Plan'),
                            style: TextStyle(
                                fontSize: 22,
                                color: AppColors.white,
                                fontFamily: 'Carlito Bold'),
                          ),
                          Text(
                            context.t('₹12,999'),
                            style: TextStyle(
                                fontSize: 22,
                                color: AppColors.white,
                                fontFamily: 'Carlito Bold'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        children: [
                          Text(
                            context.t('₹1,083/Month'),
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.white,
                                fontFamily: 'Carlito Bold'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomElevatedButton(
                            height: size.height * 0.037,
                            width: size.width * 0.3,
                            borderRadius: BorderRadius.circular(17),
                            buttonText: context.t('ANNUAL PLAN'),
                            color: AppColors.grey,
                            onTap: () {
                              _launchURL(stripeLink);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}
