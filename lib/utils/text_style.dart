import 'package:flutter/material.dart';
import 'package:port/utils/constants.dart';
import 'package:port/utils/sizes.dart';

abstract class AppTextStyles {
  TextStyle textStyleHeadingBig(AppInsets insets);
  TextStyle textStyleHeadingSmall(AppInsets insets);
  TextStyle titleLGbold();
  TextStyle titleMDmedium();
  TextStyle titleSMbold();
  TextStyle bodyLGbold();
  TextStyle bodyLGmedium();
  TextStyle bodyMDmedium();
}

class LargeTextStyles extends AppTextStyles {
  @override
  TextStyle textStyleHeadingBig(AppInsets insets) => TextStyle(
    fontSize: insets.fontSizeHeadings,
    fontWeight: FontWeight.bold,
    letterSpacing: Texts.letterSpacing,
    height: Texts.height,
  );

  @override
  TextStyle textStyleHeadingSmall(AppInsets insets) => TextStyle(
    fontSize: insets.fontSizeTitles,
    fontWeight: FontWeight.normal,
    letterSpacing: Texts.letterSpacing,
    height: Texts.height,
  );

  @override
  TextStyle titleLGbold() =>
      const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  @override
  TextStyle titleMDmedium() =>
      const TextStyle(fontSize: 32, fontWeight: FontWeight.w500);

  @override
  TextStyle titleSMbold() =>
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  @override
  TextStyle bodyLGbold() =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  TextStyle bodyLGmedium() =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  @override
  TextStyle bodyMDmedium() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
}

class SmallTextStyles extends AppTextStyles {
  @override
  TextStyle textStyleHeadingBig(AppInsets insets) => TextStyle(
    fontSize: insets.fontSizeHeadings,
    fontWeight: FontWeight.bold,
    letterSpacing: Texts.letterSpacing,
    height: Texts.height,
  );

  @override
  TextStyle textStyleHeadingSmall(AppInsets insets) => TextStyle(
    fontSize: insets.fontSizeTitles,
    fontWeight: FontWeight.normal,
    letterSpacing: Texts.letterSpacing,
    height: Texts.height,
  );

  @override
  TextStyle titleLGbold() =>
      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  @override
  TextStyle titleMDmedium() =>
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

  @override
  TextStyle titleSMbold() =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  TextStyle bodyLGbold() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  TextStyle bodyLGmedium() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  TextStyle bodyMDmedium() =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
}
