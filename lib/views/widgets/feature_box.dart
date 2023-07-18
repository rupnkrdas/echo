import 'package:flutter/material.dart';

import 'package:echo/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String desctriptionText;
  const FeatureBox({
    Key? key,
    required this.color,
    required this.headerText,
    required this.desctriptionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100.h),
      child: GlassContainer.clearGlass(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        height: double.maxFinite,
        width: double.maxFinite,
        gradient: LinearGradient(
          colors: [Colors.purpleAccent.withOpacity(0.15), Colors.grey.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blur: 10,
        borderWidth: 0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  headerText,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.whiteColor,
                  ),
                ),
              ),
              Text(
                desctriptionText,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: Colors.grey[400],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
