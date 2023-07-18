import 'dart:ui';

import 'package:echo/constants/colors.dart';
import 'package:echo/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../widgets/custom_circular_button.dart';

class LandingScreen extends StatelessWidget {
  static String routeName = '/landing';
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 128.h,
          ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: SizedBox(
                  height: 230.h,
                  width: 225.w,
                  child: Image.asset(
                    'assets/images/main_logo.png',
                    fit: BoxFit.contain,
                    colorBlendMode: BlendMode.dstOut,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 75.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              "Your own",
              style: GoogleFonts.poppins(
                height: 0.9,
                fontSize: 32.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.whiteColor,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: GradientText(
              'AI assistant',
              style: GoogleFonts.poppins(
                fontSize: 34.sp,
                fontWeight: FontWeight.w500,
              ),
              colors: [
                Color(0xffE655EF),
                Color(0xffE1BAC3),
                Color(0xff6A49B7),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              'Intelligent. Inspired. Echo.',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 30.w, bottom: 30.h),
              child: CustomCircularButton(
                onTap: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                  HapticFeedback.mediumImpact();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
