import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/image.dart';
import 'package:quizzer/Class/quiz.dart';

//순서 정렬형. A,B,C,D 순서로 정렬되어야 함.
class Quiz4 extends AbstractQuiz {
  int maxAnswerSelection = 1;
  List<String> connectionAnswers = [];
  List<int?> connectionAnswerIndex = [];

  Quiz4({
    int layoutType = 4,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    this.maxAnswerSelection = 1,
    this.connectionAnswers = const [],
    this.connectionAnswerIndex = const [],
  }) : super(
            layoutType: layoutType,
            answers: answers,
            ans: ans,
            question: question);

  void addConnectionAnswerIndex(int newInt) {
    connectionAnswerIndex.add(newInt);
  }

  void setConnectionAnswerIndexAt(int index, int newInt) {
    connectionAnswerIndex[index] = newInt;
  }

  String getConnectionAnswerAt(int index) {
    return connectionAnswers[index];
  }

  List<String> getConnectionAnswers() {
    return connectionAnswers;
  }

  void addConnectionAnswer(String newString) {
    connectionAnswers.add(newString);
  }

  void setConnectionAnswerAt(int index, String newString) {
    connectionAnswers[index] = newString;
  }

  int getAnswersLength() {
    return answers.length;
  }

  void setAnswerAt(int index, String newString) {
    answers[index] = newString;
  }

  void removeAnswerAt(int index) {
    answers.removeAt(index);
    connectionAnswers.removeAt(index);
    connectionAnswerIndex.removeAt(index);
  }

  @override
  void addAns(int newAns) {
    // TODO: implement addAns
  }

  @override
  void addAnswer(String newString) {
    answers.add(newString);
  }

  void addAnswerPair() {
    answers.add('');
    connectionAnswers.add('');
    connectionAnswerIndex.add(null);
  }

  @override
  bool checkAns(String userAns) {
    return answers.contains(userAns);
  }

  List<int?> getConnectionAnswerIndex() {
    return connectionAnswerIndex;
  }

  int getConnectionAnswerIndexAt(int index) {
    return connectionAnswerIndex[index]!;
  }

  void removeAnswerPairAt(int index) {
    for (int i = 0; i < answers.length; i++) {
      if (connectionAnswerIndex[i] == null) {
        continue;
      }
      if (connectionAnswerIndex[i]! == index) {
        connectionAnswerIndex[i] = null;
      } else if (connectionAnswerIndex[i]! > index) {
        connectionAnswerIndex[i] = connectionAnswerIndex[i]! - 1;
      }
    }
    answers.removeAt(index);
    connectionAnswers.removeAt(index);
    connectionAnswerIndex.removeAt(index);
  }

  @override
  List<String> getAnswers() {
    return answers;
  }

  String getAnswerAt(int index) {
    return answers[index];
  }

  @override
  Image? getImage() {
    // TODO: implement getImage
    throw UnimplementedError();
  }

  Quiz4 loadQuiz(dynamic json) {
    Map<String, dynamic> jsonData = json as Map<String, dynamic>;
    List<String> answersList = List<String>.from(
        jsonData['answers'].map((answer) => answer.toString()));
    List<bool> ansList =
        List<bool>.from(jsonData['ans'].map((ans) => ans as bool));
        List<String> connectionAnswers = List<String>.from(jsonData['connectionAnswers'].map((answer) => answer.toString()));
        List<int> connectionAnswerIndex = List<int>.from(jsonData['connectionAnswerIndex'].map((index) => index as int));
    return Quiz4(
        layoutType: 4,
        connectionAnswers: connectionAnswers,
        connectionAnswerIndex: connectionAnswerIndex,
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
        "connectionAnswers": connectionAnswers,
        "connectionAnswerIndex": connectionAnswerIndex,
        "layoutType": layoutType,
        "maxAnswerSelection": maxAnswerSelection,
        "answers": answers,
        "ans": ans,
        "question": question
      }
    };
  }
}
