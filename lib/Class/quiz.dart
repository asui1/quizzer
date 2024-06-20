import 'package:flutter/cupertino.dart';

class Quiz {
  int layoutType;
  List<String> answers;
  String ans;
  Image? image;

  Quiz({required this.layoutType, required this.answers, required this.ans});

  void setLayoutType(int newLayoutType) {
    layoutType = newLayoutType;
  }

  int getLayoutType() {
    return layoutType;
  }

  void addAnswer(String newString) {
    answers.add(newString);
  }

  void removeAnswer(String stringToRemove) {
    answers.remove(stringToRemove);
  }

  List<String> getAnswers() {
    return answers;
  }

  void setAns(String newAns) {
    ans = newAns;
  }

  bool checkAns(String userAns) {
    return ans == userAns;
  }

  Image? getImage() {
    return image;
  }

  void setImage(Image newImage) {
    image = newImage;
  }



}
