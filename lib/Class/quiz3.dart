import 'dart:ui';
import 'package:flutter/src/widgets/image.dart';
import 'package:quizzer/Class/quiz.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/Colors.dart';

//순서 정렬형. A,B,C,D 순서로 정렬되어야 함.
class Quiz3 extends AbstractQuiz {
  int maxAnswerSelection = 1;
  List<String> shuffledAnswers = [];

  Quiz3({
    int layoutType = 3,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    this.maxAnswerSelection = 1,
    this.shuffledAnswers = const [],
  }) : super(
            layoutType: layoutType,
            answers: answers,
            ans: ans,
            question: question);

  Quiz3.copy(Quiz3 original)
      : super(
          layoutType: original.layoutType,
          answers: List<String>.from(original.answers),
          ans: List<bool>.from(original.ans),
          question: original.question,
        ) {
    shuffledAnswers = List<String>.from(original.shuffledAnswers);
    maxAnswerSelection = original.maxAnswerSelection;
  }

  void setShuffledAnswers() {
    if (shuffledAnswers.isNotEmpty) return;
    List<String> tempShuffled = answers.sublist(1);
    tempShuffled.shuffle();
    shuffledAnswers = [...answers];

    shuffledAnswers.replaceRange(1, answers.length, tempShuffled);
    shuffledAnswers[0] = answers[0];
  }

  @override
  bool check() {
    for (int i = 0; i < answers.length; i++) {
      if (shuffledAnswers[i] != answers[i]) return false;
    }
    return true;
  }

  @override
  Color getState() {
    if (shuffledAnswers.isNotEmpty) return MyColors().green;
    return MyColors().red;
  }

  bool isShuffledAnswersEmpty() {
    return shuffledAnswers.isEmpty;
  }

  List<String> getShuffledAnswers() {
    return shuffledAnswers;
  }

  int getAnswersLength() {
    return answers.length;
  }

  String removeShuffledAnswerAt(int index) {
    return shuffledAnswers.removeAt(index);
  }

  void addShuffledAnswerAt(int index, String newString) {
    shuffledAnswers.insert(index, newString);
  }

  void setAnswerAt(int index, String newString) {
    answers[index] = newString;
    shuffledAnswers = [];
  }

  void removeAnswerAt(int index) {
    answers.removeAt(index);
    shuffledAnswers = [];
  }

  @override
  void addAns(int newAns) {
    // TODO: implement addAns
  }

  @override
  void addAnswer(String newString) {
    answers.add(newString);
    shuffledAnswers = [];
  }

  @override
  bool checkAns(String userAns) {
    return answers.contains(userAns);
  }

  @override
  List<String> getAnswers() {
    return answers;
  }

  @override
  Image? getImage() {
    // TODO: implement getImage
    throw UnimplementedError();
  }

  Quiz3 loadQuiz(dynamic json) {
    Map<String, dynamic> jsonData = json as Map<String, dynamic>;
    List<String> answersList = List<String>.from(
        jsonData['answers'].map((answer) => answer.toString()));
    List<bool> ansList =
        List<bool>.from(jsonData['ans'].map((ans) => ans as bool));
    return Quiz3(
        layoutType: 3,
        answers: answersList,
        ans: ansList,
        question: jsonData['question'],
        maxAnswerSelection: jsonData['maxAnswerSelection']);
  }

  @override
  void removeAnswer(String stringToRemove) {
    // TODO: implement removeAnswer
  }

  @override
  void setImage(Image newImage) {
    // TODO: implement setImage
  }

  @override
  void setLayoutType(int newLayoutType) {
    // TODO: implement setLayoutType
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "layoutType": layoutType,
      "body": {
        "layoutType": layoutType,
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
    if(answers.length < 3){
      return "답변을 3개 이상 입력해주세요.";
    }
    return "ok";
  }
}
