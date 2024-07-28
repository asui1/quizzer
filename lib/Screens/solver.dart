// topbar, bottombar 구현, 넘기기 버튼 구현. body에 QuizView 넣어주기.
// 사용자가 입력한 정답 관리.
// 우선은 앱 레벨에서 채점하고, 나중에 서버에서 채점하도록 수정.
// 채점 후 점수를 가지고 결과 페이지로 이동.
// Solver가 받을 입력 : Quizlayout, int index -> 몇 번째 퀴즈를 화면에 나타낼지.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/ImageColor.dart';
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
import 'package:quizzer/Screens/answerCheckScreen.dart';

import '../Class/quiz2.dart';

class QuizSolver extends StatefulWidget {
  final String? uuid;
  final int index;
  final bool isPreview;

  const QuizSolver({
    Key? key,
    required this.uuid,
    required this.index,
    this.isPreview = false,
  }) : super(key: key);

  @override
  _QuizSolverState createState() => _QuizSolverState();
}

class _QuizSolverState extends State<QuizSolver> {
  //정답 관리할 변수 필요.
  //채점 함수는 Functions에 새로운 함수를 만들고 그걸 호출하여 사용할 예정.
  int curIndex = 0;
  double heightModifier = 1;
  late PageController _pageController;
  List<int> pageHistory = [];
  bool _pageScrollEnabled = true;
  late ImageColor? bottomBarImage;

  @override
  void initState() {
    super.initState();
    curIndex = widget.index;
    pageHistory.add(widget.index);
    _pageController = PageController(initialPage: widget.index);
    if (widget.uuid == null) {
      bottomBarImage =
          Provider.of<QuizLayout>(context, listen: false).getImage(2);
    }
    else{
      
    }
  }

  @override
  Widget build(BuildContext context) {
    // 여기에서 widget.quizLayout과 widget.index를 사용하여 UI를 구성합니다.
    heightModifier = (AppConfig.screenHeight -
            widget.quizLayout.getAppBarHeight() -
            widget.quizLayout.getBottomBarHeight()) /
        (AppConfig.screenHeight);
    return PopScope(
      canPop: pageHistory.length <= 1,
      onPopInvoked: (didPop) {
        if (!didPop) {
          onBackButtonPressed(context);
        }
      },
      child: Scaffold(
        appBar:
            viewerAppBar(quizLayout: widget.quizLayout, showDragHandle: false),
        body: SafeArea(
          child: Container(
            decoration: backgroundDecoration(quizLayout: widget.quizLayout),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  physics: _pageScrollEnabled
                      ? PageScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  onPageChanged: (int index) {
                    setState(() {
                      curIndex = index;
                      pageHistory.add(index);
                    });
                  },
                  itemCount: widget.isPreview
                      ? widget.quizLayout.getQuizCount()
                      : widget.quizLayout.getQuizCount() + 1, // 퀴즈의 총 개수
                  itemBuilder: (context, index) {
                    return QuizView(
                      quizLayout: widget.quizLayout,
                      index: index, // 현재 페이지 인덱스를 QuizView에 전달
                      screenHeightModifier: heightModifier,
                      screenWidthModifier: 0.90,
                      moveToQuiz: (int newIndex) {
                        setState(() {
                          if (_pageController.hasClients &&
                              _pageController.page! <
                                  widget.quizLayout.getQuizCount() + 1) {
                            _pageController.jumpToPage(newIndex);
                          }
                        });
                      },
                      changePageViewState: (bool enabled) {
                        setState(() {
                          _pageScrollEnabled = enabled;
                        });
                      },
                    );
                  },
                ),
                FilpStyle12(
                  quizLayout: widget.quizLayout,
                  onPressedBack: onPressedBack,
                  onPressedForward: onPressedForward,
                ),
                curIndex == widget.quizLayout.getQuizCount()
                    ? Container()
                    : Positioned(
                        bottom: widget.quizLayout.getSelectedLayout() == 2
                            ? 50
                            : 10, // 하단에서의 거리
                        right: 10, // 오른쪽에서의 거리
                        child: Text(
                          "${curIndex + 1}/${widget.quizLayout.getQuizCount()}", // 예시로 '1/10'을 사용했습니다. 실제 인덱스/퀴즈 번호 변수로 대체해야 합니다.
                          style: TextStyle(
                            fontSize: AppConfig.fontSize * 0.7, // 텍스트 크기 조정
                            color: widget.quizLayout.getColorScheme().primary,
                          ),
                        ),
                      ),
                curIndex == widget.quizLayout.getQuizCount()
                    ? Container()
                    : Positioned(
                        key: const ValueKey('solverBackbutton'),
                        bottom: widget.quizLayout.getSelectedLayout() == 2
                            ? 50
                            : 10, // 하단에서의 거리
                        left: 10, // 오른쪽에서의 거리
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: widget.quizLayout.getColorScheme().primary,
                          ),
                          onPressed: () {
                            Navigator.pop(context, curIndex);
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: viewerBottomBar(
          quizLayout: widget.quizLayout,
          onPressedForward: onPressedForward,
          onPressedBack: onPressedBack,
          showSwitchButton: true,
          showDragHandle: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onBackButtonPressed(BuildContext context) {
    if (pageHistory.length > 1) {
      // 이전 페이지로 돌아가기
      int lastPageIndex = pageHistory.removeLast();
      lastPageIndex = pageHistory.removeLast();
      _pageController.jumpToPage(lastPageIndex);

      // 필요한 경우 상태 업데이트
      setState(() {});
    }
  }

  void onPressedForward() {
    setState(() {
      if (_pageController.hasClients &&
          _pageController.page! < widget.quizLayout.getQuizCount() + 1) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }

  void onPressedBack() {
    setState(() {
      if (_pageController.hasClients && _pageController.page! > 0) {
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }
}

Widget QuizView({
  required QuizLayout quizLayout,
  required int index,
  required double screenHeightModifier,
  required double screenWidthModifier,
  required Function(int) moveToQuiz,
  required Function(bool) changePageViewState,
}) {
  // 여기에서 quizLayout과 index를 사용하여 퀴즈 화면을 구성합니다.
  if (index >= quizLayout.getQuizCount()) {
    return AnswerCheckScreen(
      quizLayout: quizLayout,
      screenWidthModifier: screenWidthModifier,
      screenHeightModifier: screenHeightModifier,
      moveToQuiz: moveToQuiz,
      heightModifier: screenHeightModifier,
    );
  }

  AbstractQuiz quiz = quizLayout.getQuiz(index);
  int layoutType = quiz.getLayoutType();
  switch (layoutType) {
    case 1:
      return QuizView1(
        quiz: quiz as Quiz1,
        screenWidthModifier: screenWidthModifier,
        screenHeightModifier: screenHeightModifier,
      );
    case 2:
      return QuizView2(
        quiz: quiz as Quiz2,
        screenWidthModifier: screenWidthModifier,
        screenHeightModifier: screenHeightModifier,
      );
    case 3:
      return QuizView3(
        quiz: quiz as Quiz3,
        screenWidthModifier: screenWidthModifier,
        screenHeightModifier: screenHeightModifier,
      );
    case 4:
      return QuizView4(
        quiz: quiz as Quiz4,
        screenWidthModifier: screenWidthModifier,
        screenHeightModifier: screenHeightModifier,
        changePageViewState: changePageViewState,
      );
    default:
      return Container();
  }
}
