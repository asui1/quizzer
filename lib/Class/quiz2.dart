import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:quizzer/Class/quiz.dart';

class Quiz2 extends AbstractQuiz {
  // Remove the duplicate declaration of maxAnswerSelection
  List<int> centerDate = [2024, 6, 22];
  int yearRange = 10;
  List<List<int>> answerDate = [];
  int maxAnswerSelection = 1;

  Quiz2({
    int layoutType = 2,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    required this.maxAnswerSelection,
    this.centerDate = const [2024, 6, 22],
    this.yearRange = 10,
    this.answerDate = const [],
  }) : super(
          layoutType: layoutType,
          answers: answers,
          ans: ans,
          question: question,
        );

  int getYearRange() {
    return yearRange;
  }

  List<List<int>> getAnswerDate() {
    return answerDate;
  }

  void updateAnswerDateAt(int index, List<int> newAnswerDate) {
    List<int> nextDay = newAnswerDate;
    while (answerDate.contains(nextDay)) {
      nextDay[2] += 1;
    }
    answerDate[index] = nextDay;
  }

  void updateAnserDate(List<int> originalDate, List<int> newDate) {
    int index = answerDate.indexOf(originalDate);
    List<int> nextDay = newDate;
    while (answerDate.contains(nextDay)) {
      nextDay[2] += 1;
    }
    answerDate[index] = nextDay;
  }

  void addAnswerDate(List<int> newAnswerDate) {
    answerDate = List<List<int>>.from(answerDate);
    answerDate.add(newAnswerDate);
    maxAnswerSelection = answerDate.length;
  }

  void setAnswerDate(List<List<int>> newAnswerDate) {
    answerDate = newAnswerDate;
    maxAnswerSelection = answerDate.length;
  }

  void removeAnswerDateAt(int index) {
    answerDate.removeAt(index);
  }

  void setYearRange(int newYearRange) {
    yearRange = newYearRange;
  }

  List<int> getAnswerDateAt(int index) {
    return answerDate[index];
  }

  List<int> getCenterDate() {
    return centerDate;
  }

  void setCenterDate(List<int> newCenterDate) {
    centerDate = newCenterDate;
  }

  void setCenterYear(int newYear) {
    centerDate[0] = newYear;
  }

  void setCenterMonth(int newMonth) {
    centerDate[1] = newMonth;
  }

  void setCenterDay(int newDay) {
    centerDate[2] = newDay;
  }

  void setMaxAnswerSelection(int newMaxAnswerSelection) {
    maxAnswerSelection = newMaxAnswerSelection;
  }

  int getMaxAnswerSelection() {
    return maxAnswerSelection;
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


  Quiz2 loadQuiz(dynamic json){
    Map<String, dynamic> jsonData = json as Map<String, dynamic>;
    return Quiz2(
        layoutType: 2,
        answers: jsonData['answers'],
        ans: jsonData['ans'],
        question: jsonData['question'],
        maxAnswerSelection: jsonData['maxAnswerSelection'],
        centerDate: jsonData['centerDate'],
        yearRange: jsonData['yearRange'],
        answerDate: jsonData['answerDate']);

  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "layoutType": layoutType,
      "body": {
        "centerDate": centerDate,
        "yearRange": yearRange,
        "answerDate": answerDate,
        "maxAnswerSelection": maxAnswerSelection,
        "answers": answers,
        "ans": ans,
        "question": question
      }
    };
  }
}
