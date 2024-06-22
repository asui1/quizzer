import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

abstract class AbstractQuiz {
  int layoutType;
  List<String> answers;
  List<bool> ans;
  Image? image;
  String question;

  AbstractQuiz({required this.layoutType, required this.answers, required this.ans, required this.question});

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

Future<File> saveQuiz(int tag);

Future<AbstractQuiz> loadQuiz(int tag);

Map<String, dynamic> toJson();

}

