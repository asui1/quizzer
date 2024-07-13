import 'dart:convert';

import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyLoggedIn = 'loggedIn';
  static const _userImageName = 'userImageName';
  static const _userEmail = 'userEmail';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future setUserImageName(String userImageName) async =>
      await _preferences.setString(_userImageName, userImageName);

  static Future<String?> getUserImageName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userImageName');
  }


  static Future setLoggedIn(bool loggedIn) async =>
      await _preferences.setBool(_keyLoggedIn, loggedIn);

  static bool? getLoggedIn() => _preferences.getBool(_keyLoggedIn);

  static Future<void> clear() async => await _preferences.clear();
  static Future setUserEmail(String email) async => // 추가된 부분
      await _preferences.setString(_userEmail, email); // 추가된 부분

  static Future<String?> getUserEmail() async => // 수정된 부분
      _preferences.getString(_userEmail); // 수정된 부분
}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      Logger.log("SIGN IN COMPLETE : $account.email");
      if (account != null) {
        // Google 로그인 성공 후 SharedPreferences에 사용자 정보 저장

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', account.displayName ?? '');
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

  Future<void> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        final String? email = account.email;

        final response = await http.post(
          Uri.parse(loginUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'token': googleAuth.idToken,
          }),
        );

        if (response.statusCode == 200) {
          // 성공적으로 서버에 등록된 후 SharedPreferences에 사용자 정보 저장
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', account.displayName ?? '');
          await prefs.setString('userEmail', account.email);
          await prefs.setBool('isLoggedIn', true); // 로그인 상태 저장

          Logger.log("사용자 등록 성공: $email");
        } else {
          // 서버 응답 처리
          Logger.log("서버 등록 실패: ${response.body}");
        }

        // 백엔드 서버에 사용자 이메일을 전송하여 등록 처리
        // 예: await registerUserOnServer(email, googleAuth.idToken);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', account.displayName ?? '');
        await prefs.setString('userEmail', account.email);
        await prefs.setBool('isLoggedIn', true); // 로그인 상태 저장

        Logger.log("사용자 등록 성공: $email");
      }
    } catch (error) {
      Logger.log("Google 로그인 실패: $error");
    }
  }
}
