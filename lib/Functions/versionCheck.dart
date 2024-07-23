import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/keys.dart';

class VersionCheckService {
  // Replace with the URL of your version info API or static file
  final String versionInfoUrl = serverUrl + 'version/';

  Future<String> _fetchLatestVersion() async {
    try {
      final response = await http.get(Uri.parse(versionInfoUrl),
          headers: {'Authorization': serverAuth});
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['latestVersion']; // Ensure your JSON has this key
      } else {
        throw Exception('Failed to load version info');
      }
    } catch (e) {
      throw Exception('Failed to fetch latest version');
    }
  }

  Future<bool> checkForUpdate() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      final String latestVersion = await _fetchLatestVersion();

      if (currentVersion != latestVersion) {
        // Version mismatch, update available
        return true;
      }
      return false; // No update needed
    } catch (e) {
      print(e);
      return false; // Error occurred, handle accordingly
    }
  }
}