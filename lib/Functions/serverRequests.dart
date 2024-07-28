import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Class/scoreCard.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/fileSaveLoad.dart';
import 'dart:convert';
import 'package:quizzer/Functions/keys.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Widgets/QuizCardVertical.dart';
import 'package:quizzer/Widgets/quizCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> loadFileContent(String uuid) async {
  final url = serverUrl + 'getQuizData/?uuid=$uuid';
  final response =
      await http.get(Uri.parse(url), headers: {'Authorization': serverAuth});

  if (response.statusCode == 200) {
    // 응답으로 받은 데이터를 파일에 저장
    String decodedString = utf8.decode(response.bodyBytes);
    Logger.log("JSON 파일 다운로드 성공");
    return decodedString;
  } else {
    Logger.log("JSON 파일 다운로드 실패");
    return "";
  }
}

Future<http.Response> postJsonToFileOnServer(
    String uuid, String jsonString, QuizLayout quizlayout) async {
  String imageBase64 = base64Encode(quizlayout.getTitleImageByte());
  final body = json.encode({
    "id": uuid,
    'title': quizlayout.getTitle(),
    'tags': quizlayout.getTags(),
    'image': imageBase64,
    'creator': quizlayout.getCreator(),
    "data": jsonString,
    "scoreCard": makeScoreCardJson(quizlayout),
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

  if (response.statusCode == 200 || response.statusCode == 201) {
    Logger.log("UPLOAD SUCCESS");
  } else {
    Logger.log('Failed to upload json. Status code: ${response.statusCode}');
    Logger.log(response.body);
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
  var response =
      await http.get(Uri.parse(url), headers: {'Authorization': serverAuth});
  List<QuizCard> _searchResults = [];

  // Process the response
  if (response.statusCode == 200 || response.statusCode == 201) {
    // Parse the response body
    String decodedString = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = jsonDecode(decodedString);
    for (var item in jsonList) {
      Map<String, dynamic> jsonItem = item;

      // Initialize filePath as null
      Uint8List imageBytes = Uint8List(0);

      // Check if 'image' is not null
      if (jsonItem['Image'] != null && jsonItem['Image'] != '') {
        // Decode the base64 image
        imageBytes = base64.decode(jsonItem['Image']);
      }
      String tags = jsonItem['Tags'];
      if (tags.startsWith('[') && tags.endsWith(']')) {
        tags = tags.substring(1, tags.length - 1);
      }
      tags = tags.replaceAll('"', '');
      List<String> tagsList;
      if (tags.isEmpty) {
        tagsList = [];
      } else {
        tagsList = tags.split(',').map((e) => e.trim()).toList();
      }
      int counts = jsonItem['Count'];
      _searchResults.add(QuizCard(
        title: jsonItem['Title'],
        tags: tagsList,
        creator: jsonItem['Creator'],
        uuid: jsonItem['ID'],
        titleImageByte: imageBytes,
        counts: counts,
      ));
    }
    Logger.log("SEARCH SUCCESS");
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
  if (response.statusCode == 200) {
    // 응답 본문을 `,`로 분리하여 배열로 변환
    String decodedString = utf8.decode(response.bodyBytes);
    var responseBody = jsonDecode(decodedString);

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

Future<String> sendResultToServer(int score, QuizLayout quizLayout) async {
  final url = serverUrl + "submitQuiz/";
  String email = await UserPreferences.getUserEmail() ?? "GUEST";
  String uuid = quizLayout.getUuid();
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json', 'Authorization': serverAuth},
    body: jsonEncode({
      'email': email,
      'uuid': uuid,
      'score': score,
    }),
  );

  if (response.statusCode == 201) {
    Logger.log("SEND RESULT SUCCESS");
    return "";
  } else {
    Logger.log("SEND RESULT FAILED");
    return "fail";
  }
}

Map<String, dynamic> offsetToJson(Offset offset) {
  return {
    'dx': offset.dx,
    'dy': offset.dy,
  };
}

Future<List<List<QuizCardVertical>>> getRecommendations(String lang) async {
  final url = serverUrl + 'GetRecommendations/?language=$lang';
  var response =
      await http.get(Uri.parse(url), headers: {'Authorization': serverAuth});
  Logger.log("GetRecommendations");
  List<QuizCardVertical> mostView = [];
  List<QuizCardVertical> recommended = [];
  List<QuizCardVertical> mostRecent = [];

  // Process the response
  if (response.statusCode == 200 || response.statusCode == 201) {
    // Parse the response body
    String decodedString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> jsonList = jsonDecode(decodedString);
    List<String> filter = ["most_viewed", "similar_items", "most_recent_items"];
    for (int i = 0; i < 3; i += 1) {
      if (jsonList[filter[i]] == null) {
        Logger.log("No data for ${filter[i]}");
        continue;
      }
      List<dynamic> newJsonList = jsonList[filter[i]];
      for (var item in newJsonList) {
        Map<String, dynamic> jsonItem = item;

        // Initialize filePath as null
        Uint8List imageBytes = Uint8List(0);

        // Check if 'image' is not null
        if (jsonItem['Image'] != null && jsonItem['Image'] != '') {
          // Decode the base64 image
          imageBytes = base64.decode(jsonItem['Image']);
        }
        String tags = jsonItem['Tags'];
        if (tags.startsWith('[') && tags.endsWith(']')) {
          tags = tags.substring(1, tags.length - 1);
        }
        tags = tags.replaceAll('"', '');
        List<String> tagsList;
        if (tags.isEmpty) {
          tagsList = [];
        } else {
          tagsList = tags.split(',').map((e) => e.trim()).toList();
        }
        int counts = jsonItem['Count'];
        if (i == 0) {
          mostRecent.add(QuizCardVertical(
            title: jsonItem['Title'],
            tags: tagsList,
            creator: jsonItem['Creator'],
            uuid: jsonItem['ID'],
            titleImageByte: imageBytes,
            counts: counts,
          ));
        } else if (i == 1) {
          recommended.add(QuizCardVertical(
            title: jsonItem['Title'],
            tags: tagsList,
            creator: jsonItem['Creator'],
            uuid: jsonItem['ID'],
            titleImageByte: imageBytes,
            counts: counts,
          ));
        } else {
          mostView.add(QuizCardVertical(
            title: jsonItem['Title'],
            tags: tagsList,
            creator: jsonItem['Creator'],
            uuid: jsonItem['ID'],
            titleImageByte: imageBytes,
            counts: counts,
          ));
        }
      }
    }
    return [mostRecent, recommended, mostView];
  } else {
    // Handle error
    Logger.log('Request failed with status: ${response.statusCode}');
  }
  return [];
}

//GET result by [String title, String Creator, int score, ScoreCard scoreCard, String Nickname, colorScheme]
Future<List<dynamic>> loadResult(String resultId) {
  final url = serverUrl + 'GetResult/?resultId=$resultId';
  return http.get(Uri.parse(url), headers: {'Authorization': serverAuth}).then(
      (response) {
    if (response.statusCode == 200) {
      // 응답으로 받은 데이터를 파일에 저장
      String decodedString = utf8.decode(response.bodyBytes);
      Logger.log("JSON 파일 다운로드 성공");
      Map<String, dynamic> jsonMap = jsonDecode(decodedString);
      ScoreCard _scoreCard = makeScoreCardFromJson(jsonMap['ScoreCard']);
      ColorScheme colorScheme = jsonToColorScheme(jsonMap['colorScheme']);

      return [
        jsonMap['Title'],
        jsonMap['Creator'],
        jsonMap['Score'],
        _scoreCard,
        jsonMap['Nickname'],
        colorScheme,
      ];
    } else {
      Logger.log("JSON 파일 다운로드 실패");
      return [];
    }
  });
}
