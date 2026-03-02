import 'package:flutter/material.dart';

class ScreenSize {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Size size(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

class Insets {
  static double get xs => 4;
  static double get sm => 8;
  static double get med => 12;
  static double get lg => 16;
  static double get xl => 24;
  static double get xxl => 32;
  static double get xxxl => 80;
}

abstract class AppInsets {
  double get fontSizeTitles;
  double get fontSizeHeadings;
  double get logoSize;
  double get horizontalPadding;
  double get verticalPadding;
  double get logoMargin;
}

class LargeInsets extends AppInsets {
  @override
  double get fontSizeHeadings => 60;

  @override
  double get fontSizeTitles => 20;

  @override
  double get logoSize => 60;

  @override
  double get horizontalPadding => 10;

  @override
  double get verticalPadding => 5;

  @override
  double get logoMargin => 20;
}

class SmallInsets extends AppInsets {
  @override
  double get fontSizeHeadings => 25;

  @override
  double get fontSizeTitles => 15;

  @override
  double get logoSize => 35;

  @override
  double get horizontalPadding => 10;

  @override
  double get verticalPadding => 5;

  @override
  double get logoMargin => 12;
}
