// topbar, bottombar 구현, 넘기기 버튼 구현. body에 QuizView 넣어주기.
// 사용자가 입력한 정답 관리.
// 우선은 앱 레벨에서 채점하고, 나중에 서버에서 채점하도록 수정.
// 채점 후 점수를 가지고 결과 페이지로 이동.
// Solver가 받을 입력 : Quizlayout, int index -> 몇 번째 퀴즈를 화면에 나타낼지.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget1Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget2Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget3Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget4Viewer.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

import 'Class/quiz2.dart';

class QuizSolver extends StatefulWidget {
  final QuizLayout quizLayout;
  final int index;

  const QuizSolver({
    Key? key,
    required this.quizLayout,
    required this.index,
  }) : super(key: key);

  @override
  _QuizSolverState createState() => _QuizSolverState();
}

class _QuizSolverState extends State<QuizSolver> {
  //정답 관리할 변수 필요.
  //채점 함수는 Functions에 새로운 함수를 만들고 그걸 호출하여 사용할 예정.
  int curIndex = 0;
  double heightModifier = 1;

  @override
  void initState() {
    super.initState();
    curIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    // 여기에서 widget.quizLayout과 widget.index를 사용하여 UI를 구성합니다.
    heightModifier = (AppConfig.screenHeight -
            widget.quizLayout.getAppBarHeight() -
            widget.quizLayout.getBottomBarHeight()) /
        (AppConfig.screenHeight);
    print("heightModifier: $heightModifier");
    return Scaffold(
      appBar: widget.quizLayout.getIsTopBarVisible()
          ? PreferredSize(
              // 상단 바 추가
              preferredSize:
                  Size.fromHeight(widget.quizLayout.getAppBarHeight()),
              child: widget.quizLayout.getImage(1).isColor()
                  ? Container(
                      color: widget.quizLayout.getImage(1).getColor(),
                      height: widget.quizLayout.getAppBarHeight(),
                    )
                  : Container(
                      height: widget.quizLayout.getAppBarHeight(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.file(File(
                            widget.quizLayout.getImage(1).getImagePath(),
                          )).image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
            )
          : null,
      body: SafeArea(
        child: Container(
          decoration: backgroundDecoration(quizLayout: widget.quizLayout),
          child: Stack(
            children: [
              QuizView(
                quizLayout: widget.quizLayout,
                index: curIndex,
                screenHeightModifier: heightModifier,
                screenWidthModifier: 0.80,
              ),
              FilpStyle12(
                quizLayout: widget.quizLayout,
                onPressedBack: onPressedBack,
                onPressedForward: onPressedForward,
              ),
              Positioned(
                bottom: 10, // 하단에서의 거리
                right: 10, // 오른쪽에서의 거리
                child: Text(
                  "${curIndex + 1}/${widget.quizLayout.getQuizCount()}", // 예시로 '1/10'을 사용했습니다. 실제 인덱스/퀴즈 번호 변수로 대체해야 합니다.
                  style: TextStyle(
                    fontSize: AppConfig.fontSize * 0.7, // 텍스트 크기 조정
                    color: widget.quizLayout.getTextColor(), // 텍스트 색상
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.quizLayout.getIsBottomBarVisible()
          ? PreferredSize(
              // 하단 바 추가
              preferredSize:
                  Size.fromHeight(widget.quizLayout.getBottomBarHeight()),
              child: widget.quizLayout.getImage(2).isColor()
                  ? Container(
                      color: widget.quizLayout.getImage(2).getColor(),
                      height: widget.quizLayout.getBottomBarHeight(),
                      child: BottomBarStack(
                        quizLayout: widget.quizLayout,
                        onPressedBack: onPressedBack,
                        onPressedForward: onPressedForward,
                        showDragHandle: false,
                      ),
                    )
                  : Container(
                      height: widget.quizLayout.getBottomBarHeight(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.file(
                            File(widget.quizLayout.getImage(2).getImagePath()),
                          ).image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: BottomBarStack(
                        quizLayout: widget.quizLayout,
                        onPressedBack: onPressedBack,
                        onPressedForward: onPressedForward,
                        showDragHandle: false,
                      ),
                    ),
            )
          : null,
    );
  }

  void onPressedForward() {
    setState(() {
      if (curIndex < widget.quizLayout.getQuizCount() - 1) {
        curIndex++;
      }
    });
    if (curIndex == widget.quizLayout.getQuizCount() - 1) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SearchScreen()),
      // );
    }
  }

  void onPressedBack() {
    setState(() {
      if (curIndex > 0) {
        curIndex--;
      }
    });
  }
}

Widget QuizView(
    {required QuizLayout quizLayout,
    required int index,
    required double screenHeightModifier,
    required double screenWidthModifier}) {
  // 여기에서 quizLayout과 index를 사용하여 퀴즈 화면을 구성합니다.

  AbstractQuiz quiz = quizLayout.getQuiz(index);
  int layoutType = quiz.getLayoutType();
  switch (layoutType) {
    case 1:
      return QuizView1(
          quiz: quiz as Quiz1,
          screenWidthModifier: screenWidthModifier,
          screenHeightModifier: screenHeightModifier,
          quizLayout: quizLayout);
    case 2:
      return QuizView2(
          quiz: quiz as Quiz2,
          screenWidthModifier: screenWidthModifier,
          screenHeightModifier: screenHeightModifier,
          quizLayout: quizLayout);
    case 3:
      return QuizView3(
          quiz: quiz as Quiz3,
          screenWidthModifier: screenWidthModifier,
          screenHeightModifier: screenHeightModifier,
          quizLayout: quizLayout);
    case 4:
      return QuizView4(
          quiz: quiz as Quiz4,
          screenWidthModifier: screenWidthModifier,
          screenHeightModifier: screenHeightModifier,
          quizLayout: quizLayout);
    default:
      return Container();
  }
}
