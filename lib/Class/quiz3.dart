import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/src/widgets/image.dart';
import 'package:quizzer/Class/quiz.dart';
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
  }) : super(
            layoutType: layoutType,
            answers: answers,
            ans: ans,
            question: question);

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
    for(int i = 0; i < answers.length; i++) {
      if(shuffledAnswers[i] != answers[i]) return false;
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
