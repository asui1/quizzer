
import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/image.dart';
import 'package:quizzer/Class/quiz.dart';

//순서 정렬형. A,B,C,D 순서로 정렬되어야 함.
class Quiz4 extends AbstractQuiz {
  int maxAnswerSelection = 1;
  List<String> connectionAnswers = [];

  Quiz4({
    int layoutType = 3,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    this.maxAnswerSelection = 1,
    this.connectionAnswers = const [],
  }) : super(
            layoutType: layoutType,
            answers: answers,
            ans: ans,
            question: question);

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
  }

  @override
  void addAns(int newAns) {
    // TODO: implement addAns
  }

  @override
  void addAnswer(String newString) {
    answers.add(newString);
  }

  void addAnswerPair(){
    answers.add('');
    connectionAnswers.add(''); 
  }

  @override
  bool checkAns(String userAns) {
    return answers.contains(userAns);
  }

  void removeAnswerPairAt(int index){
    answers.removeAt(index);
    connectionAnswers.removeAt(index);
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

  @override
  int getLayoutType() {
    // TODO: implement getLayoutType
    throw UnimplementedError();
  }

  @override
  Future<Quiz4> loadQuiz(dynamic jsonData) {
      return Future.value(Quiz4(
          layoutType: jsonData['layoutType'],
          answers: jsonData['answers'],
          ans: jsonData['ans'],
          question: jsonData['question'],
          maxAnswerSelection: jsonData['maxAnswerSelection']
      ));
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
      "maxAnswerSelection": maxAnswerSelection,
      "answers": answers,
      "ans": ans,
      "question": question
    };
  }
}
