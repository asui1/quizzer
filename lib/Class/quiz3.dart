import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/image.dart';
import 'package:quizzer/Class/quiz.dart';

//순서 정렬형. A,B,C,D 순서로 정렬되어야 함.
class Quiz3 extends AbstractQuiz {
  int maxAnswerSelection = 1;
  List<String> ShuffledAnswers = [];

  Quiz3({
    int layoutType = 3,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    this.maxAnswerSelection = 1,
  }) : super(
            layoutType: layoutType,
            answers: answers,
            ans: ans,
            question: question);

  void setShuffledAnswers() {
    List<String> tempShuffled = answers.sublist(1);
    tempShuffled.shuffle();
    ShuffledAnswers = [...answers];

    ShuffledAnswers.replaceRange(0, answers.length - 1, tempShuffled);
    ShuffledAnswers[answers.length - 1] = answers[0];
  }

  bool isShuffledAnswersEmpty() {
    return ShuffledAnswers.isEmpty;
  }

  List<String> getShuffledAnswers() {
    return ShuffledAnswers;
  }

  int getAnswersLength() {
    return answers.length;
  }

  void setAnswerAt(int index, String newString) {
    answers[index] = newString;
  }

  void removeAnswerAt(int index) {
    answers.removeAt(index);
  }

  @override
  void addAns(int newAns) {
    // TODO: implement addAns
  }

  @override
  void addAnswer(String newString) {
    answers.add(newString);
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
}
