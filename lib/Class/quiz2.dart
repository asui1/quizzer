import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Setup/Colors.dart';

class Quiz2 extends AbstractQuiz {
  // Remove the duplicate declaration of maxAnswerSelection
  List<int> centerDate = [2024, 6, 22];
  int yearRange = 20;
  List<List<int>> answerDate = [];
  int maxAnswerSelection = 1;

  ////////////// 뷰어용 변수들
  List<DateTime> viewerAnswers = [];
  DateTime? curFocus = null;

  Quiz2({
    int layoutType = 2,
    required List<String> answers,
    required List<bool> ans,
    required String question,
    required this.maxAnswerSelection,
    this.centerDate = const [2024, 6, 22],
    this.yearRange = 20,
    this.answerDate = const [],
  }) : super(
          layoutType: layoutType,
          answers: answers,
          ans: ans,
          question: question,
        );

  Quiz2.copy(Quiz2 original)
      : this(
          layoutType: original.layoutType,
          answers: List<String>.from(original.answers),
          ans: List<bool>.from(original.ans),
          question: original.question,
          maxAnswerSelection: original.maxAnswerSelection,
          centerDate: List<int>.from(original.centerDate),
          yearRange: original.yearRange,
          answerDate: List<List<int>>.from(
              original.answerDate.map((date) => List<int>.from(date))),
        );

  void setCurFocus(DateTime newCurFocus) {
    curFocus = newCurFocus;
  }

  @override
  bool check() {
    if (answerDate.length != viewerAnswers.length) {
      return false;
    }
    for (int i = 0; i < answerDate.length; i++) {
      List<int> answer = [
        viewerAnswers[i].year,
        viewerAnswers[i].month,
        viewerAnswers[i].day
      ];
      bool containsAnswer = answerDate.any((list) =>
          list.length == answer.length &&
          list
              .asMap()
              .entries
              .every((entry) => entry.value == answer[entry.key]));
      if (!containsAnswer) {
        return false;
      }
    }
    return true;
  }

  @override
  Color getState() {
    if (viewerAnswers.length == 0) {
      return MyColors().red;
    } else {
      return MyColors().green;
    }
  }

  List<DateTime> getViewerAnswers() {
    return viewerAnswers;
  }

  void addViewerAnswer(DateTime newViewerAnswer) {
    viewerAnswers.add(newViewerAnswer);
  }

  void removeViewerAnswerAt(int index) {
    viewerAnswers.removeAt(index);
  }

  DateTime getCurFocus() {
    curFocus ??= DateTime(centerDate[0], centerDate[1], centerDate[2]);
    return curFocus!;
  }

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

  Quiz2 loadQuiz(dynamic json) {
    Map<String, dynamic> jsonData = json as Map<String, dynamic>;
    List<String> answersList = List<String>.from(
        jsonData['answers'].map((answer) => answer.toString()));
    List<bool> ansList =
        List<bool>.from(jsonData['ans'].map((ans) => ans as bool));
    List<int> centerDate =
        List<int>.from(jsonData['centerDate'].map((date) => date as int));
    List<List<int>> answerDate = List<List<int>>.from(jsonData['answerDate']
        .map((date) => List<int>.from(date.map((d) => d as int))));

    return Quiz2(
        layoutType: 2,
        answers: answersList,
        ans: ansList,
        question: jsonData['question'],
        maxAnswerSelection: jsonData['maxAnswerSelection'],
        centerDate: centerDate,
        yearRange: jsonData['yearRange'],
        answerDate: answerDate);
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

  @override
  String isSavable() {
    if (question == "") {
      return "질문을 입력해주세요.";
    }
    if (answerDate.length == 0) {
      return "답변을 입력해주세요.";
    }

    answerDate = answerDate.toSet().toList();
    DateTime centerDateTime =
        DateTime(centerDate[0], centerDate[1], centerDate[2]);
    // 유효한 날짜 범위를 계산합니다.
    DateTime startDate =
        centerDateTime.subtract(Duration(days: 365 * yearRange));
    DateTime endDate = centerDateTime.add(Duration(days: 365 * yearRange));

    // 각 answerDate가 유효 범위 내에 있는지 확인합니다.
    for (List<int> date in answerDate) {
      DateTime answerDateTime = DateTime(date[0], date[1], date[2]);
      if (answerDateTime.isBefore(startDate) ||
          answerDateTime.isAfter(endDate)) {
        return "답변 날짜가 유효 범위를 벗어났습니다.";
      }
    }

    return 'ok';
  }
}
