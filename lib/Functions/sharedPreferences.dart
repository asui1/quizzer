import 'dart:convert';

import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _userImageName = 'userImageName';
  static const _userEmail = 'userEmail';
  static const _tagsJson = '';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future setUserImageName(String userImageName) async =>
      await _preferences.setString(_userImageName, userImageName);

  static Future<String?> getUserImageName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userImageName);
  }
  // Getter for _agreed
  static bool get loggedIn => _preferences.getBool('loggedIn') ?? false;

  // Setter for _agreed
  static set loggedIn(bool value) => _preferences.setBool('loggedIn', value);


  static Future<void> clear() async => await _preferences.clear();
  static Future setUserEmail(String email) async => // 추가된 부분
      await _preferences.setString(_userEmail, email); // 추가된 부분

  static Future<String?> getUserEmail() async => // 수정된 부분
      _preferences.getString(_userEmail); // 수정된 부분

  static Future setTagsJson(List<String> tags) async {
    // Convert List<String> to JSON String
    String tagsJson = jsonEncode(tags);
    // Save JSON String in SharedPreferences
    await _preferences.setString(_tagsJson, tagsJson);
  }

  // Getter for tagsJson
  static Future<List<String>?> getTagsJson() async {
    // Retrieve JSON String from SharedPreferences
    String? tagsJson = _preferences.getString(_tagsJson);
    // If exists, decode JSON String back to List<String>
    if (tagsJson != null) {
      List<dynamic> tagsList = jsonDecode(tagsJson);
      // Cast dynamic list to List<String> and return
      return tagsList.cast<String>();
    }
    // Return null if tagsJson does not exist
    return null;
  }

  // Getter for _agreed
  static bool get agreed => _preferences.getBool('agreed') ?? false;

  // Setter for _agreed
  static set agreed(bool value) => _preferences.setBool('agreed', value);
}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      Logger.log("SIGN IN COMPLETE : $account.email");
      if (account != null) {
        // Google 로그인 성공 후 SharedPreferences에 사용자 정보 저장
        final response = await http.get(
          Uri.parse(serverUrl + "email/${account.email}"),
          headers: {'Authorization': serverAuth},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final String? username = data['username'];
          final String? userImageName = data['userImageName'];
          UserPreferences.setUsername(username ?? '');
          UserPreferences.setUserImageName(userImageName ?? '');
        } else {
          Logger.log("Failed to get user info: ${response.body}");
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', account.email);
        // 필요한 경우 추가 정보 저장
        return true;
      }
      return false;
    } catch (error) {
      Logger.log("Google 로그인 실패: $error");
      return false;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 로그아웃 시 저장된 사용자 정보 삭제
  }
}
