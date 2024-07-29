import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:url_launcher/url_launcher.dart';

void shareToTwitter(BuildContext context, String title, String resultUrl) async {
  Logger.log(title);
  Logger.log(resultUrl);
  final Uri twitterUrl = Uri.parse(
    'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(resultUrl)}',
  );

  if (await canLaunchUrl(twitterUrl)) {
    await launchUrl(twitterUrl);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not launch twitter.'),
      ),
    );
  }
}

void shareToFacebook(BuildContext context, String title, String resultUrl) async {
  final Uri facebookUrl = Uri.parse(
    'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(resultUrl)}&quote=${Uri.encodeComponent(title)}',
  );

  if (await canLaunchUrl(facebookUrl)) {
    await launchUrl(facebookUrl);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not launch Facebook.'),
      ),
    );
  }
}

void copyToClipboard(BuildContext context, String resultUrl) {
  Clipboard.setData(ClipboardData(text: resultUrl));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('URL copied to clipboard.'),
    ),
  );
}