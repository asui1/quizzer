import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'dart:convert';
import 'package:quizzer/Functions/keys.dart';
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
    String uuid, String jsonString) async {
  final body = json.encode({
    "id": uuid,
    "data": json.decode(jsonString) // jsonString이 이미 JSON 형식의 문자열이라고 가정
  });

  final response = await http.post(
    Uri.parse(serverUrl),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  return response;
}

void uploadJson(String uuid, String jsonString) async {
  final response = await postJsonToFileOnServer(uuid, jsonString);

  if (response.statusCode == 200 || response.statusCode == 201) {
    Logger.log("UPLOAD SUCCESS");
  } else {
    Logger.log('Failed to upload json. Status code: ${response.statusCode}');
  }
}

Future<void> uploadFile(String uuid) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$uuid.json';
  final file = File(filePath);

  if (await file.exists()) {
    final jsonString = await file.readAsString(encoding: utf8); // 인코딩을 utf8로 지정
    uploadJson(uuid, jsonString);
  } else {
    print("File does not exist");
  }
}
