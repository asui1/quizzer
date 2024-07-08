import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Setup/Colors.dart';

class Quiz1 extends AbstractQuiz {
  int bodyType = 0;
  XFile? imageFile;
  String bodyText = '';
  bool shuffleAnswers = false;
  int maxAnswerSelection = 1;

  ////////////// 뷰어용 변수들
  List<String> viewerAnswers = [];
  List<bool> viewerAns = [];

  Quiz1({
    int layoutType = 1,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    this.bodyType = 0,
    this.imageFile,
    this.bodyText = '',
    this.shuffleAnswers = false,
    this.maxAnswerSelection = 1,
  }) : super(
            layoutType: layoutType,
            answers: answers,
            ans: ans,
            question: question);

  void viewerInit() {
    if (viewerAnswers.length == 0) {
      viewerAnswers =
          List<String>.generate(answers.length, (index) => answers[index]);
      viewerAns = List<bool>.generate(answers.length, (index) => false);
      if (shuffleAnswers) {
        viewerAnswers.shuffle();
        shuffleAnswers = false;
      }
    }
  }

  @override
  bool check() {
    print(ans);
    print(viewerAns);
    for (int i = 0; i < answers.length; i++) {
      if (ans[i] != viewerAns[viewerAnswers.indexOf(answers[i])]) {
        return false;
      }
    }
    return true;
  }

  @override
  Color getState() {
    int trueCount = ans.where((element) => element == true).length;
    int userTrueCount = viewerAns.where((element) => element == true).length;
    if (trueCount == userTrueCount) {
      return MyColors().green;
    } else if (userTrueCount > 0) {
      return MyColors().orange;
    } else {
      return MyColors().red;
    }
  }

  String getViewerAnsAt(int index) {
    return viewerAnswers[index];
  }

  List<bool> getViewerAns() {
    return viewerAns;
  }

  List<String> getViewerAnswers() {
    return viewerAnswers;
  }

  int getViewAnsCount() {
    return viewerAns.where((element) => element == true).length;
  }

  void setAnswer(int index, String newAnswer) {
    if (index >= answers.length) {
      return;
    }
    answers[index] = newAnswer;
  }

  Quiz1 loadQuiz(dynamic json) {
    // JSON 데이터를 처리하는 로직을 구현합니다.
    // 예시에서는 json이 Map<String, dynamic> 타입이라고 가정합니다.
    // 실제로는 json 타입을 확인하고 적절히 변환하는 로직이 필요할 수 있습니다.
    Map<String, dynamic> jsonData = json as Map<String, dynamic>;
    print(jsonData);
    List<String> answersList = List<String>.from(
        jsonData['answers'].map((answer) => answer.toString()));
    List<bool> ansList =
        List<bool>.from(jsonData['ans'].map((ans) => ans as bool));
    return Quiz1(
      layoutType: 1,
      bodyType: jsonData['bodyType'],
      imageFile: jsonData['imageFile'],
      bodyText: jsonData['bodyText'],
      shuffleAnswers: jsonData['shuffleAnswers'],
      maxAnswerSelection: jsonData['maxAnswerSelection'],
      answers: answersList,
      ans: ansList,
      question: jsonData['question'],
    );
  }

  String getAnswerAt(int index) {
    if (index >= answers.length) {
      return '';
    }
    return answers[index];
  }

  void setMaxAnswerSelection(int newMaxAnswerSelection) {
    maxAnswerSelection = newMaxAnswerSelection;
  }

  int getMaxAnswerSelection() {
    return maxAnswerSelection;
  }

  void changeCorrectAns(int index, bool value) {
    ans[index] = value;
  }

  void setShuffleAnswers(bool newShuffleAnswers) {
    shuffleAnswers = newShuffleAnswers;
  }

  bool getShuffleAnswers() {
    return shuffleAnswers;
  }

  int getAnsLength() {
    int trueCount = ans.where((element) => element == true).length;
    return trueCount;
  }

  bool isCorrectAns(int newAns) {
    return ans[newAns];
  }

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
    ans.removeAt(index);
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
    ans.add(false);
  }

  @override
  void removeAnswer(String stringToRemove) {
    answers.remove(stringToRemove);
  }

  @override
  List<String> getAnswers() {
    print("getAnswers: $answers");
    return answers;
  }

  @override
  void addAns(int newAns) {
    ans[newAns] = true;
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

  @override
  Map<String, dynamic> toJson() {
    return {
      "layoutType": layoutType,
      "body": {
        "bodyType": bodyType,
        "imageFile": imageFile?.path,
        "bodyText": bodyText,
        "shuffleAnswers": shuffleAnswers,
        "maxAnswerSelection": maxAnswerSelection,
        "answers": answers,
        "ans": ans,
        "question": question
      }
    };
  }
}
