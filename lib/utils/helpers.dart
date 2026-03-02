import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String urlString) async {
    final bool isEmail =
        urlString.contains('@') && !urlString.startsWith('http');

    final Uri url = Uri.parse(isEmail ? 'mailto:$urlString' : urlString);

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching $url: $e');
    }
  }