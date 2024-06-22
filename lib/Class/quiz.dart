import 'package:flutter/cupertino.dart';

abstract class AbstractQuiz {
  int layoutType;
  List<String> answers;
  List<int> ans;
  Image? image;

  AbstractQuiz({required this.layoutType, required this.answers, required this.ans});

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

