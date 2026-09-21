import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:story_teller/appLocalization.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/core/presentation/screen/splash/splash_screen.dart';
import 'package:story_teller/core/service/notification_service.dart';
import 'package:story_teller/features/home/presentation/data/model/homeProvider.dart';
import 'package:story_teller/features/home/presentation/data/model/onBoardingProvider.dart';
import 'package:story_teller/features/home/presentation/data/model/profileProviderModel.dart';
import 'package:story_teller/features/home/presentation/data/model/authProvider.dart' as app_auth;
import 'package:story_teller/features/home/presentation/data/model/searchProvider.dart';
import 'package:story_teller/features/home/presentation/data/model/selectScreenProvider.dart';
import 'package:story_teller/features/home/presentation/data/model/storyProfileProvider.dart';
import 'package:story_teller/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  await Hive.initFlutter();
  await Hive.openBox('StoryBook');
  await Hive.openBox('categoriesBox');
  await Hive.openBox('storiesBox');
  await Hive.openBox('searchBox');

  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => app_auth.AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SelectProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => OnBoardingProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => StoryProfileProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => HomeProvider(),
      ),
    ],
    child: const MyApp(),
  );

  runApp(
    kDebugMode
        ? DevicePreview(
            enabled: false, // Set to true only when you want to preview devices
            builder: (context) => app,
          )
        : app,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<ProfileProvider>().currentLocale;

    return MaterialApp(
      locale: locale,
      supportedLocales: LocalizationService.supportedLocales,
      localizationsDelegates: LocalizationService.localizationsDelegates,
      localeResolutionCallback: LocalizationService.localeResolutionCallback,
      debugShowCheckedModeBanner: false,
      title: 'Story Teller',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
