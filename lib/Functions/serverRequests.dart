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
  final url = serverUrl + '' + uuid;
  final response =
      await http.get(Uri.parse(url), headers: {'Authorization': serverAuth});

  if (response.statusCode == 200) {
    // 응답으로 받은 데이터를 파일에 저장
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
  Logger.log(uuid);
  Logger.log(quizlayout.getTitle());
  Logger.log(quizlayout.getTags());
  Logger.log(quizlayout.getTitleImageNow());
  Logger.log(quizlayout.getCreator());

  final body = json.encode({
    "id": uuid,
    'title': quizlayout.getTitle(),
    'tags': quizlayout.getTags(),
    'image': quizlayout.getTitleImageNow(),
    'creator': quizlayout.getCreator(),
    "data": jsonString,
  });

  Logger.log(body);

  final response = await http.post(
    Uri.parse(serverUrl + 'addQuiz/'),
    headers: {"Content-Type": "application/json", 'Authorization': serverAuth},
    body: body,
  );

  return response;
}

void uploadJson(String uuid, String jsonString, QuizLayout quizLayout) async {
  final response = await postJsonToFileOnServer(uuid, jsonString, quizLayout);
  Logger.log(response.body);

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
  final url = serverUrl + 'searchQuiz/?search=$searchText';
  Logger.log(url);
  var response =
      await http.get(Uri.parse(url), headers: {'Authorization': serverAuth});
  List<QuizCard> _searchResults = [];

  // Process the response
  if (response.statusCode == 200 || response.statusCode == 201) {
    // Parse the response body
    String decodedString = utf8.decode(response.bodyBytes);
    Logger.log(decodedString);
    List<dynamic> jsonList = jsonDecode(decodedString);
    Logger.log(jsonList);
    for (var item in jsonList) {
      Logger.log("????");
      Logger.log(item);
      Map<String, dynamic> jsonItem = item;
      Logger.log("JSONITEM : $jsonItem");
      Logger.log("????");

      // Initialize filePath as null
      String? filePath;

      // Check if 'image' is not null
      if (jsonItem['Image'] != null && jsonItem['Image'] != '') {
        // Decode the base64 image
        List<int> imageBytes = base64.decode(jsonItem['Image']);

        // Get the application documents directory
        Directory directory = await getApplicationDocumentsDirectory();

        // Create the file path
        filePath = '${directory.path}/${jsonItem['ID']}-titleImage';

        // Write the image file
        await File(filePath).writeAsBytes(imageBytes);
      }

      // Add the QuizCard to the search results
      _searchResults.add(QuizCard(
        title: jsonItem['Title'],
        tags: jsonItem['Tags'],
        additionalData: jsonItem['Creator'],
        uuid: jsonItem['ID'],
        titleImagePath: filePath,
      ));
    }
    Logger.log("search result len: ${_searchResults.length}");
    return _searchResults;
  } else {
    // Handle error
    Logger.log('Request failed with status: ${response.statusCode}');
  }
  return [];
}

Future<void> checkDuplicate(
    String nickname, StreamController<bool> _streamController) async {
  final url = serverUrl + 'CheckDuplicateNickname/' + '?nickname=$nickname';
  var response =
      await http.get(Uri.parse(url), headers: {'Authorization': serverAuth});
  if (response.statusCode == 200) {
    Logger.log("DUPLICATE CHECK SUCCESS");
    _streamController.add(true);
  } else {
    Logger.log("DUPLICATE CHECK FAILED");
    _streamController.add(false);
  }
}

Future<bool> registerUser(
    String nickname, String email, String image, BuildContext context) async {
  final url = serverUrl + 'createUser/';
  var response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json', 'Authorization': serverAuth},
    body: jsonEncode({
      'nickname': nickname,
      'email': email,
      'idIcon': image,
    }),
  );

  if (response.statusCode == 201) {
    Logger.log("REGISTER SUCCESS");
    await UserPreferences.setUsername(nickname);
    await UserPreferences.setUserImageName(image);
    await UserPreferences.setUserEmail(email);
    await UserPreferences.setTagsJson([]);
    UserPreferences.loggedIn = true;
    UserPreferences.agreed = false;

    return true;
  } else {
    if (response.body.contains("User with this email")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미 등록된 이메일입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (response.body.contains("User with this nickname")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미 등록된 닉네임입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('가입에 실패했습니다.\n잠시 후 다시 시도해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    Logger.log("REGISTER FAILED");
    return false;
  }
}

Future<void> signOut() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<void> updateUserAgreed() async {
  if (UserPreferences.loggedIn == false) {
    return;
  }
  String email = await UserPreferences.getUserEmail() ?? "GUEST";
  final url = serverUrl + 'UpdateUserAgreed/' + '?email=${email}';
  Logger.log(url);
  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': serverAuth,
      'Content-Type':
          'application/json', // Add this if your server expects JSON body
    },
    // Uncomment and modify the body if you need to send data in the body
    // body: jsonEncode({
    //   'email': email,
    // }),
  );
  Logger.log(response.statusCode);
  Logger.log(response.body);
  if (response.statusCode == 200) {
    Logger.log("UPDATE AGREED SUCCESS");
    UserPreferences.agreed = true;
  } else {
    Logger.log("UPDATE AGREED FAILED");
  }
}

Future<int> loginCheck(String email, String image) async {
  final url = serverUrl + 'login/' + '?email=$email';
  var response =
      await http.get(Uri.parse(url), headers: {'Authorization': serverAuth});
  Logger.log(response.statusCode);
  Logger.log(response.body);
  if (response.statusCode == 200) {
    Logger.log("LOGIN SUCCESS");

    // 응답 본문을 `,`로 분리하여 배열로 변환
    String decodedString = utf8.decode(response.bodyBytes);
    var responseBody = jsonDecode(decodedString);
    Logger.log(responseBody);
    // JSON 객체에서 필요한 정보 추출
    String idIcon = responseBody['IDIcon'];
    String nickname = responseBody['Nickname'];
    List<String> tagsList;
    if (responseBody['Tags'] is String && responseBody['Tags'].isEmpty) {
      tagsList = [];
    } else {
      tagsList = List<String>.from(responseBody['Tags'] ?? []);
    }
    bool agreed = responseBody['Agreed'];

    Logger.log(nickname);

    UserPreferences.setUserImageName(idIcon); // IDIcon을 이미지 이름으로 가정
    UserPreferences.setUsername(nickname);
    UserPreferences.setTagsJson(tagsList); // Tags를 JSON 문자열로 가정
    UserPreferences.agreed = agreed;
    UserPreferences.setUserEmail(email);
    UserPreferences.loggedIn = true;
    return 200;
  } else if (response.statusCode == 400) {
    if (response.body.contains("Not registered")) {
      Logger.log("User Not Registered");
      return 400;
    }
  }
  Logger.log("SERVER COMMUNICATION FAILED");
  return 401;
}

Future<void> sendResultToServer(int score, QuizLayout quizLayout) async {
  final url = serverUrl;
  String email = await UserPreferences.getUserEmail() ?? "GUEST";
  String uuid = quizLayout.getUuid();
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json', 'Authorization': serverAuth},
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

Map<String, dynamic> offsetToJson(Offset offset) {
  return {
    'dx': offset.dx,
    'dy': offset.dy,
  };
}
