import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class CustomCircularButton extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomCircularButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Color(0xff6A49B7),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onTap: onTap,
      child: Ink(
        height: 55.h,
        width: 55.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffE655EF),
            Color(0xffE1BAC3),
            Color(0xffE1BAC3),
            Color(0xff6A49B7),
            Color(0xffE655EF),
          ]),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.arrow_forward_outlined,
              size: 22.h,
            ),
          ),
        ),
      ),
    );
  }
}
