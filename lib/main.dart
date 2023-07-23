import 'package:echo/views/screens/home_screen.dart';
import 'package:echo/views/screens/landing_screen.dart';
import 'package:echo/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:echo/constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(320, 700),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Echo',
          theme: ThemeData.dark(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: AppTheme.backgroundColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppTheme.backgroundColor,
              elevation: 0,
            ),
          ),
          initialRoute: SplashScreen.routeName,
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            SplashScreen.routeName: (context) => const SplashScreen(),
            LandingScreen.routeName: (context) => const LandingScreen(),
          },
        );
      },
    );
  }
}
