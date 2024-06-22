import 'package:flutter/cupertino.dart';

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
}

