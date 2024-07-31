import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Setup/Colors.dart';

class Quiz1 extends AbstractQuiz {
  int bodyType = 0;
  String bodyText = '';
  bool shuffleAnswers = false;
  int maxAnswerSelection = 1;
  Uint8List? titleImageBytes = Uint8List(0);
  bool isTitleImageSet = false;
  ////////////// 뷰어용 변수들
  List<String> viewerAnswers = [];
  List<bool> viewerAns = [];
  String? youtubeId = null;
  int? youtubeStartTime = null;

  Quiz1({
    int layoutType = 1,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    this.bodyType = 0,
    this.bodyText = '',
    this.shuffleAnswers = false,
    this.maxAnswerSelection = 1,
    Uint8List? titleImageBytes,
    this.isTitleImageSet = false,
    this.youtubeId = null,
    this.youtubeStartTime = null,
  })  : titleImageBytes = titleImageBytes ?? Uint8List(0),
        super(
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
    bodyText = original.bodyText;
    shuffleAnswers = original.shuffleAnswers;
    maxAnswerSelection = original.maxAnswerSelection;
    titleImageBytes = original.titleImageBytes;
    isTitleImageSet = original.isTitleImageSet;
    youtubeId = original.youtubeId;
    youtubeStartTime = original.youtubeStartTime;
  }

  void printQuiz1() {
    print('Layout Type: $layoutType');
    print('Body Type: $bodyType');
    print('Body Text: $bodyText');
    print('Shuffle Answers: $shuffleAnswers');
    print('Max Answer Selection: $maxAnswerSelection');
    print('Answers: $answers');
    print('Correct Answers: $ans');
    print('Question: $question');
    print('Viewer Answers: $viewerAnswers');
    print('Viewer Correct Answers: $viewerAns');
  }

  void validateBody() {
    if (bodyType == 2 && titleImageBytes != null) {
      if (titleImageBytes!.length < 39) {
        bodyType = 0;
      }
    }
    if (bodyType == 3 && youtubeId == null) {
      bodyType = 0;
    }
  }

  void setYoutubeStartTime(int newStartTime) {
    youtubeStartTime = newStartTime;
  }

  int getYoutubeStartTime() {
    if (youtubeStartTime == null) {
      return 0;
    } else {
      return youtubeStartTime!;
    }
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

  void setYoutubeId(String url) {
    youtubeId = url;
  }

  String getYoutubeId() {
    if (youtubeId == null) {
      return '';
    } else {
      return youtubeId!;
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
    int userTrueCount = viewerAns.where((element) => element == true).length;
    if (userTrueCount > 0) {
      return MyColors().green;
    } else {
      return MyColors().red;
    }
  }

  String getViewerAnswerAt(int index) {
    return viewerAnswers[index];
  }

  List<bool> getViewerAns() {
    if (viewerAns.length == 0) viewerInit();
    return viewerAns;
  }

  List<String> getViewerAnswers() {
    return viewerAnswers;
  }

  int getViewAnsTrueCount() {
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
    String base64Image = jsonData['image'] as String? ?? '';
    Uint8List titleImageBytes =
        base64Image.isNotEmpty ? base64.decode(base64Image) : Uint8List(0);
    bool isTitleImageSet = titleImageBytes.isNotEmpty;

    return Quiz1(
      layoutType: 1,
      bodyType: jsonData['bodyType'],
      bodyText: jsonData['bodyText'],
      shuffleAnswers: jsonData['shuffleAnswers'],
      maxAnswerSelection: jsonData['maxAnswerSelection'],
      answers: answersList,
      ans: ansList,
      question: jsonData['question'],
      titleImageBytes: titleImageBytes,
      isTitleImageSet: isTitleImageSet,
      youtubeId: jsonData['youtubeId'],
      youtubeStartTime: jsonData['youtubeStartTime'],
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

  void setAnsAt(int index, bool value) {
    ans[index] = value;
  }

  void setShuffleAnswers(bool newShuffleAnswers) {
    shuffleAnswers = newShuffleAnswers;
  }

  bool getShuffleAnswers() {
    return shuffleAnswers;
  }

  int getAnsTrueLength() {
    int trueCount = ans.where((element) => element == true).length;
    return trueCount;
  }

  bool isCorrectAns(int newAns) {
    return ans[newAns];
  }

  bool isImageSet() {
    return isTitleImageSet;
  }

  bool isYoutubeSet() {
    return youtubeId != null;
  }

  String getBodyText() {
    return bodyText;
  }

  void setBodyText(String newBodyText) {
    bodyText = newBodyText;
  }

  void removeImageFile() {
    titleImageBytes = Uint8List(0);
    isTitleImageSet = false;
  }

  void removeYoutube() {
    youtubeId = null;
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

  void setImageByte(Uint8List newImageBytes) {
    titleImageBytes = newImageBytes;
    isTitleImageSet = true;
  }

  Uint8List getImageByte() {
    if (titleImageBytes == null) {
      return Uint8List(0);
    } else {
      return titleImageBytes!;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "layoutType": layoutType,
      "body": {
        "bodyType": bodyType,
        "image": base64Encode(getImageByte()),
        "bodyText": bodyText,
        "shuffleAnswers": shuffleAnswers,
        "maxAnswerSelection": maxAnswerSelection,
        "answers": answers,
        "ans": ans,
        "question": question,
        "youtubeId": youtubeId,
        "youtubeStartTime": youtubeStartTime,
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
    if (bodyType == 2 &&
        (titleImageBytes == null || titleImageBytes!.length < 39)) {
      setBodyType(0);
      titleImageBytes = Uint8List(0);
    }

    return "ok";
  }
}
