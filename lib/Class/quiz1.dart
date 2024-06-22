import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzer/Class/quiz.dart';


class Quiz1 extends AbstractQuiz {
  int bodyType = 0;
  XFile? imageFile;
  String bodyText = '';

  Quiz1({int layoutType = 1, List<String> answers = const ['', '', ''], List<int> ans = const []})
      : super(layoutType: layoutType, answers: answers, ans: ans);

  bool isImageSet() {
    return imageFile != null;
  }

  XFile getImageFile() {
    return imageFile!;
  }

  String getBodyText() {
    return bodyText;
  }

  void setBodyText(String newBodyText) {
    bodyText = newBodyText;
  }

  void setImageFile(XFile newImageFile) {
    imageFile = newImageFile;
  }

  void setBodyType(int newBodyType) {
    bodyType = newBodyType;
  }
  int getBodyType() {
    return bodyType;
  }

  void removeAnswerAt(int index) {
    answers.removeAt(index);
  }

  String getAnswerAt(int index) {
    return answers[index];
  }

  @override
  void setLayoutType(int newLayoutType) {
    layoutType = newLayoutType;
  }

  @override
  int getLayoutType() {
    return layoutType;
  }

  @override
  void addAnswer(String newString) {
    answers.add(newString);
  }


  @override
  void removeAnswer(String stringToRemove) {
    answers.remove(stringToRemove);
  }

  @override
  List<String> getAnswers() {
    return answers;
  }

  @override
  void addAns(int newAns) {
    ans.add(newAns);
  }

  @override
  bool checkAns(String userAns) {
    return ans == userAns;
  }

  @override
  Image? getImage() {
    return image;
  }

  @override
  void setImage(Image newImage) {
    image = newImage;
  }
}