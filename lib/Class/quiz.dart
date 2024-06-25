import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

abstract class AbstractQuiz {
  int layoutType;
  List<String> answers;
  List<bool> ans;
  Image? image;
  String question;

  AbstractQuiz(
      {required this.layoutType,
      required this.answers,
      required this.ans,
      required this.question});

  void setLayoutType(int newLayoutType);
  int getLayoutType();
  void addAnswer(String newString);
  void removeAnswer(String stringToRemove);
  List<String> getAnswers();
  void addAns(int newAns);
  bool checkAns(String userAns);
  Image? getImage();
  void setImage(Image newImage);

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getlocalFile() async {
    final path = await getLocalPath();
    return File('$path/quiz.json');
  }

  void setQuestion(String newQuestion) {
    question = newQuestion;
  }

  String getQuestion() {
    return question;
  }

  Future<File> saveQuiz(int tag) async {
    final file = await getlocalFile();
    String contents = await file.readAsString();
    Map<String, dynamic> quizzes =
        contents.isNotEmpty ? json.decode(contents) : {};
    quizzes[tag.toString()] = {
      'layoutType': layoutType,
      'Quiz': toJson(),
    };
    return file.writeAsString(json.encode(quizzes));
  }

  Future<AbstractQuiz> loadQuiz(dynamic tag);

  Map<String, dynamic> toJson();
}
