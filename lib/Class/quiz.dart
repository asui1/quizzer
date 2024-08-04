import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:uuid/uuid.dart';

abstract class AbstractQuiz {
  int layoutType;
  List<String> answers;
  List<bool> ans;
  Image? image;
  String question;
  Color state = MyColors().red;
  String id = '';

  AbstractQuiz(
      {required this.layoutType,
      required this.answers,
      required this.ans,
      required this.question}): id = Uuid().v4();

  Color getState();

  bool check();

  void addAnswer(String newString){
    answers.add(newString);
  }
  void removeAnswer(String stringToRemove){
    answers.remove(stringToRemove);
  }
  void setAnswerAt(int index, String newString){
    answers[index] = newString;
  }
  void removeAnswerAt(int index){
    answers.removeAt(index);
  }

  List<String> getAnswers(){
    return answers;
  }
  void addAns(int newAns);
  bool checkAns(String userAns);
  Image? getImage();
  void setImage(Image newImage);
  String isSavable();

  int getLayoutType() {
    return layoutType;
  }

  void setLayoutType(int newLayoutType) {
    layoutType = newLayoutType;
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void setQuestion(String newQuestion) {
    question = newQuestion;
  }

  String getQuestion() {
    return question;
  }


  Map<String, dynamic> toJson();
  
}
