import 'package:flutter/material.dart';
import 'package:space_x/src/core/resources/app_colors.dart';

sealed class AppTextStyles {
  static const String _familyInter = 'Inter';

  static const double _size16 = 16;
  static const double _size20 = 20;
  static const double _size24 = 24;

  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;

  static const TextStyle appBarTitleStyle = TextStyle(
    fontFamily: _familyInter,
    color: AppColors.white,
    fontSize: _size24,
    fontWeight: _medium,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    fontFamily: _familyInter,
    color: AppColors.white,
    fontSize: _size20,
    fontWeight: _medium,
  );

  static const TextStyle textMedium16 = TextStyle(
    fontFamily: _familyInter,
    color: AppColors.green,
    fontSize: _size16,
    fontWeight: _medium,
  );

  static const TextStyle textRegular16 = TextStyle(
    fontFamily: _familyInter,
    color: AppColors.lightGray,
    fontSize: _size16,
    fontWeight: _regular,
  );
}
