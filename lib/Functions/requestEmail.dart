import 'dart:convert';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/keys.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:http/http.dart' as http;

Future<void> sendEmail(String subject, String body) async {
  String userEmail = await UserPreferences.getUserEmail() ?? 'No Email';
  if (body.length < 6) {
    return;
  }
  final url = serverUrl + 'UserRequest/';
  http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json', 'Authorization': serverAuth},
    body: jsonEncode({
      'email': userEmail,
      'subject': subject,
      'body': body,
    }),
  );
}
