import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'dart:convert';
import 'package:quizzer/Functions/keys.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Widgets/quizCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> downloadJson(Directory directory, String uuid) async {
  final url = serverUrl + uuid;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // 응답으로 받은 데이터를 파일에 저장
    print(response.body);
    final file = File('${directory.path}/$uuid.json');
    await file.writeAsString(response.body, encoding: utf8); // 인코딩을 utf8로 지정
    Logger.log("JSON 파일 다운로드 성공");
  } else {
    Logger.log("JSON 파일 다운로드 실패");
  }
}

Future<String> loadFileContent(Directory directory, String uuid) async {
  try {
    final file = File('${directory.path}/$uuid.json');
    if (await file.exists()) {
      String contents = await file.readAsString(encoding: utf8);
      print(contents);
      return contents;
    } else {
      return 'File does not exist';
    }
  } catch (e) {
    return 'Error loading file: $e';
  }
}

Future<http.Response> postJsonToFileOnServer(
    String uuid, String jsonString, QuizLayout quizlayout) async {
  final body = json.encode({
    "id": uuid,
    'title': quizlayout.getTitle(),
    'tags': '',
    'images': quizlayout.getTitleImageNow(),
    'creator': quizlayout.getCreator(),
    "data": json.decode(jsonString),
  });

  final response = await http.post(
    Uri.parse(serverUrl),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  return response;
}

void uploadJson(String uuid, String jsonString, QuizLayout quizLayout) async {
  final response = await postJsonToFileOnServer(uuid, jsonString, quizLayout);

  if (response.statusCode == 200 || response.statusCode == 201) {
    Logger.log("UPLOAD SUCCESS");
  } else {
    Logger.log('Failed to upload json. Status code: ${response.statusCode}');
  }
}

Future<void> uploadFile(String uuid, QuizLayout quizLayout) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$uuid.json';
  final file = File(filePath);

  if (await file.exists()) {
    final jsonString = await file.readAsString(encoding: utf8); // 인코딩을 utf8로 지정
    uploadJson(uuid, jsonString, quizLayout);
  } else {
    Logger.log("File does not exist");
  }
}

Future<List<QuizCard>> searchRequest(String searchText) async {
  // Send GET request to server with query parameter
  final url = serverUrl + '?search=$searchText';
  var response = await http.get(Uri.parse(url));
  List<QuizCard> _searchResults = [];

  // Process the response
  if (response.statusCode == 200 || response.statusCode == 201) {
    // Parse the response body
    Logger.log("DOWNLOAD RESULT");
    var responseBody = response.body;
    List<dynamic> jsonList = json.decode(responseBody);
    for (var jsonItem in jsonList) {
      // Process each JSON item
      // Decode the base64 image
      List<int> imageBytes = base64.decode(jsonItem['image']);

      // Get the application documents directory
      Directory directory = await getApplicationDocumentsDirectory();

      // Create the file path
      String filePath = '${directory.path}/${jsonItem['id']}-titleImage}';

      // Write the image file
      await File(filePath).writeAsBytes(imageBytes);

      // Add the QuizCard to the search results
      _searchResults.add(QuizCard(
        title: jsonItem['title'],
        tags: jsonItem['tags'],
        additionalData: jsonItem['creator'],
        uuid: jsonItem['id'],
        titleImagePath: filePath,
      ));
    }
    return _searchResults;
  } else {
    // Handle error
    Logger.log('Request failed with status: ${response.statusCode}');
  }
  return [];
}

Future<void> checkDuplicate(
    String nickname, StreamController<bool> _streamController) async {
  final url = loginUrl + '?nickname=$nickname';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Logger.log("DUPLICATE CHECK SUCCESS");
    _streamController.add(true);
  } else {
    Logger.log("DUPLICATE CHECK FAILED");
    _streamController.add(false);
  }
}

Future<bool> registerUser(String nickname, String email, String image) async {
  final url = loginUrl;
  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'nickname': nickname,
      'email': email,
      'idIcon': null,
    }),
  );

  if (response.statusCode == 201) {
    Logger.log("REGISTER SUCCESS");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', nickname);
    await prefs.setString('userEmail', email);
    await prefs.setString('userImage', image);
    await prefs.setBool('isLoggedIn', true);

    return true;
  } else {
    Logger.log("REGISTER FAILED");
    return false;
  }
}

Future<void> signOut() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<int> loginCheck(String email, String image) async {
  final url = loginUrl + '?email=$email';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Logger.log("LOGIN SUCCESS");
    print(response.body);

    // 응답 본문을 `,`로 분리하여 배열로 변환
    var parts = response.body.split(', ');
    // 각 부분에서 정보 추출
    String nickname = parts
        .firstWhere((part) => part.startsWith('Nickname: '))
        .substring('Nickname: '.length);

    UserPreferences.setUsername(nickname);
    UserPreferences.setUserImageName(image);
    UserPreferences.setUserEmail(email);
    UserPreferences.setLoggedIn(true);
    return 200;
  } else if (response.statusCode == 400) {
    Logger.log("User Not Registered");
    return 400;
  } else {
    Logger.log("LOGIN FAILED");
    return 404;
  }
}

Future<void> sendResultToServer(int score, QuizLayout quizLayout) async {
  final url = activityUrl;
  String email = await UserPreferences.getUserEmail() ?? "GUEST";
  String uuid = quizLayout.getUuid();
  print(uuid);
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'type': 1,
      'item_uuid': uuid,
      'score': score,
    }),
  );
  

  if (response.statusCode == 200) {
    Logger.log("SEND RESULT SUCCESS");
  } else {
    Logger.log("SEND RESULT FAILED");
  }
}
