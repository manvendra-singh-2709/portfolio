import 'package:flutter/material.dart';

enum BodyColor {
  red,
  blue,
  green,
  yellow,
  orange,
  purple,
  pink,
  brown,
  white,
  grey,
  cyan,
  teal,
  lime,
  indigo,
  amber;

  Color get value => switch (this) {
    BodyColor.red => Colors.red,
    BodyColor.blue => Colors.blue,
    BodyColor.green => Colors.green,
    BodyColor.yellow => Colors.yellow,
    BodyColor.orange => Colors.orange,
    BodyColor.purple => Colors.purple,
    BodyColor.pink => Colors.pink,
    BodyColor.brown => Colors.brown,
    BodyColor.white => Colors.white,
    BodyColor.grey => Colors.grey,
    BodyColor.cyan => Colors.cyan,
    BodyColor.teal => Colors.teal,
    BodyColor.lime => Colors.lime,
    BodyColor.indigo => Colors.indigo,
    BodyColor.amber => Colors.amber,
  };
}

class ColorParser {
  static Color fromString(String value, {Color fallback = Colors.red}) {
    final String input = value.trim().toLowerCase();

    for (final BodyColor bodyColor in BodyColor.values) {
      if (bodyColor.name == input) {
        return bodyColor.value;
      }
    }

    String hex = input.replaceAll('#', '').replaceFirst('0x', '');

    if (hex.length == 6) {
      hex = 'ff$hex';
    }

    if (hex.length == 8) {
      final int? value = int.tryParse(hex, radix: 16);
      if (value != null) {
        return Color(value);
      }
    }

    return fallback;
  }
}
