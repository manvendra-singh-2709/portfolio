import 'package:flutter/material.dart';
import 'package:port/utils/constants.dart';
import 'package:port/utils/sizes.dart';
import 'package:port/utils/text_style.dart';

enum FormFactorType { mobile, desktop, tablet }

extension StyledContext on BuildContext {
  MediaQueryData get mqd => MediaQuery.of(this);

  double get width => mqd.size.width;
  double get height => mqd.size.height;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Texts get texts => Texts();

  FormFactorType get formFactor {
    if (width < 600) {
      return FormFactorType.mobile;
    } else if (width < 900) {
      return FormFactorType.tablet;
    } else {
      return FormFactorType.desktop;
    }
  }

  bool get isMobile => formFactor == FormFactorType.mobile;
  bool get isTablet => formFactor == FormFactorType.tablet;
  bool get isDesktop => formFactor == FormFactorType.desktop;

  AppInsets get insets {
    switch (formFactor) {
      case FormFactorType.mobile:
        return SmallInsets();
      case FormFactorType.tablet:
      case FormFactorType.desktop:
        return LargeInsets();
    }
  }

  AppTextStyles get textStyle {
    switch (formFactor) {
      case FormFactorType.mobile:
        return SmallTextStyles();
      case FormFactorType.tablet:
      case FormFactorType.desktop:
        return LargeTextStyles();
    }
  }

  TextStyle get titleLGbold => textStyle.titleLGbold();
  TextStyle get titleMDmedium => textStyle.titleMDmedium();
  TextStyle get titleSMbold => textStyle.titleSMbold();
  TextStyle get bodyLGbold => textStyle.bodyLGbold();
  TextStyle get bodyLGmedium => textStyle.bodyLGmedium();
  TextStyle get bodyMDmedium => textStyle.bodyMDmedium();
  TextStyle get textStyleHeadingBig => textStyle.textStyleHeadingBig(insets);
  TextStyle get textStyleHeadingSmall =>
      textStyle.textStyleHeadingSmall(insets);
}
