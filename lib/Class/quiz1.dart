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

  Quiz1.copy(Quiz1 original)
      : super(
            layoutType: original.layoutType,
            answers: List<String>.from(original.answers),
            ans: List<bool>.from(original.ans),
            question: original.question) {
    bodyType = original.bodyType;
    imageFile = original.imageFile;
    bodyText = original.bodyText;
    shuffleAnswers = original.shuffleAnswers;
    maxAnswerSelection = original.maxAnswerSelection;
  }

  void printQuiz1() {
    print('Layout Type: $layoutType');
    print('Body Type: $bodyType');
    print('Image File: ${imageFile?.path}');
    print('Body Text: $bodyText');
    print('Shuffle Answers: $shuffleAnswers');
    print('Max Answer Selection: $maxAnswerSelection');
    print('Answers: $answers');
    print('Correct Answers: $ans');
    print('Question: $question');
    print('Viewer Answers: $viewerAnswers');
    print('Viewer Correct Answers: $viewerAns');
  }

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
    if (userTrueCount > 0) {
      return MyColors().green;
    } else {
      return MyColors().red;
    }
  }

  String getViewerAnsAt(int index) {
    return viewerAnswers[index];
  }

  List<bool> getViewerAns() {
    if (viewerAns.length == 0) viewerInit();
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

  void removeImageFile(){
    imageFile = null;  }

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

  @override
  String isSavable() {
    if (question == "") {
      return "질문을 입력해주세요.";
    }
    for (String i in answers) {
      if (i == "") {
        return "답변을 모두 입력해주세요.";
      }
    }
    if (!ans.contains(true)) {
      return "정답을 선택해주세요.";
    }
    int trueCount = ans.where((element) => element == true).length;

    if (maxAnswerSelection < trueCount) {
      maxAnswerSelection = trueCount;
    }
    if(bodyType == 2 && imageFile == null){
      setBodyType(0);
    }

    return "ok";
  }
}
