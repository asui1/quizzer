import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Setup/Strings.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';
import 'package:quizzer/Widgets/Generator/quizWidget1Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget2Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget4Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget1Viewer.dart';
import 'package:quizzer/Widgets/Generator/quizWidget3Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget2Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget3Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget4Viewer.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/solver.dart';
import 'package:uuid/uuid.dart';

import 'Class/quizLayout.dart';

class MakingQuiz extends StatefulWidget {
  final QuizLayout quizLayout;

  MakingQuiz({required this.quizLayout});

  @override
  _MakingQuizState createState() => _MakingQuizState();
}

class _MakingQuizState extends State<MakingQuiz> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int curQuizIndex = 0;
  int maxQuizIndex = 0;

  @override
  void initState() {
    super.initState();
    curQuizIndex = widget.quizLayout.getCurQuizIndex();
    maxQuizIndex = widget.quizLayout.getQuizCount();
  }

  @override
  Widget build(BuildContext context) {
    maxQuizIndex = widget.quizLayout.getQuizCount();

    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: backgroundDecoration(quizLayout: widget.quizLayout),
            child: Stack(
              children: [
                FilpStyle12(
                  quizLayout: widget.quizLayout,
                  onPressedBack: onPressedBack,
                  onPressedForward: onPressedForward,
                ),
                Center(
                    child: Column(
                  children: [
                    Spacer(flex: 1),
                    Text(
                      widget.quizLayout.getTitle(),
                      style: TextStyle(
                        fontSize: AppConfig.fontSize * 2, // Adjust as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Container(
                      height: AppConfig.screenHeight /
                          2, // AppConfig.ScreenHeight의 1/2 크기로 설정
                      width: AppConfig.screenWidth *
                          0.65, // AppConfig.ScreenWidth의 1/2 크기로 설정

                      child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              curQuizIndex = index;
                            });
                          },
                          itemCount: widget.quizLayout.getQuizCount() + 1,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: index < widget.quizLayout.getQuizCount()
                                  ? GestureDetector(
                                      onDoubleTap: () {
                                        navigateToQuizWidgetGenerator(
                                            widget.quizLayout.getQuiz(index));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: getQuizView(
                                              widget.quizLayout
                                                  .getQuiz(index)
                                                  .getLayoutType(),
                                              widget.quizLayout.getQuiz(index)),
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          20), // 모서리 둥글기 정도 조절
                                      child: Material(
                                        child: InkWell(
                                          onTap: () async {
                                            showQuizSelectionDialog(
                                                context, curQuizIndex);
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 100, // 너비 설정
                                            height: 100, // 높이 설정
                                            decoration: BoxDecoration(),
                                            child: Center(
                                              child: Icon(
                                                Icons.add, // 추가 아이콘
                                                size: 50, // 아이콘 크기
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: AppConfig.largePadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                      children: <Widget>[
                        Text(
                          '${min(curQuizIndex + 1, widget.quizLayout.getQuizCount())} / ${widget.quizLayout.getQuizCount()}',
                          style: TextStyle(
                            fontSize:
                                AppConfig.fontSize * 1.5, // Adjust as needed
                          ),
                        ),
                        SizedBox(
                          width: AppConfig.padding,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: AppConfig.fontSize * 1.5,
                          ), // "+" 아이콘과 크기 설정
                          onPressed: () {
                            showQuizSelectionDialog(context, curQuizIndex);
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          width: AppConfig.padding,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (widget.quizLayout.getQuizCount() >
                                  curQuizIndex) {
                                widget.quizLayout.removeQuiz(curQuizIndex);
                              }
                            });
                            // Delete current quiz logic here
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                    Spacer(flex: 3),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly, // 버튼들 사이에 균등한 공간 배분
                      children: <Widget>[
                        // 첫 번째 버튼: 체크박스와 텍스트 조합으로 "문제 순서 섞기" 구현
                        Column(
                          mainAxisSize: MainAxisSize.min, // 최소 크기로 설정
                          children: [
                            Checkbox(
                              value: widget.quizLayout
                                  .getShuffleQuestions(), // 초기 선택 상태 설정, 실제 사용 시 변수로 관리
                              onChanged: (bool? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    widget.quizLayout
                                        .setShuffleQuestions(newValue);
                                  });
                                }

                                // 체크박스 클릭 시 동작
                                // 여기에 체크박스 상태 변경 로직 추가
                              },
                            ),
                            Text("문제 순서 섞기"), // 체크박스 옆에 표시될 텍스트
                          ],
                        ),
                        // 두 번째 버튼: 임시 저장 버튼
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('임시저장'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizSolver(
                                  quizLayout: widget.quizLayout,
                                  index: curQuizIndex,
                                  isPreview: true,
                                ),
                              ),
                            ).then((value) {
                              if (value is int) {
                                setState(() {
                                  // curQuizIndex를 value로 업데이트
                                  curQuizIndex = value;
                                  _pageController.jumpToPage(value);
                                });
                              }
                            });
                          },
                          child: Text('미리보기'),
                        ),
                        // 세 번째 버튼: 저장 버튼
                        ElevatedButton(
                          onPressed: () async {
                            widget.quizLayout.saveQuizLayout(context);
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                          },
                          child: Text('저장'),
                        ),
                      ],
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showQuizSelectionDialog(BuildContext context, int quizIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: GridView.count(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1,
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, 'Item $index');
                    moveToQuizWidgetGenerator(index, quizIndex);
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Image.asset('assets/images/question2.png',
                              fit: BoxFit.cover),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(stringResources['quizItem$index']!),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  void navigateToQuizWidgetGenerator(AbstractQuiz quiz) {
    int n = quiz.getLayoutType();
    switch (n) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget1(
              quiz: quiz as Quiz1,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz1) {
            setState(() {});
          }
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget2(
              quiz: quiz as Quiz2,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz2) {
            setState(() {});
          }
        });
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget3(
              quiz: quiz as Quiz3,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz3) {
            setState(() {});
          }
        });
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget4(
              quiz: quiz as Quiz4,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz4) {
            setState(() {});
          }
        });
        break;
    }
  }

  void moveToQuizWidgetGenerator(int n, int quizIndex) {
    switch (n) {
      case 0:
        Quiz1 quiz = Quiz1(
          answers: ['', '', '', '', ''],
          ans: [false, false, false, false, false],
          question: '',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget1(
              quiz: quiz,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz1) {
            setState(() {
              widget.quizLayout.addQuizAt(result, quizIndex);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });

        break;
      case 1:
        Quiz2 quiz = Quiz2(
          answers: [],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget2(
              quiz: quiz,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz2) {
            setState(() {
              widget.quizLayout.addQuizAt(result, quizIndex);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });
        break;
      case 2:
        Quiz3 quiz = Quiz3(
          answers: ['', ''],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget3(
              quiz: quiz,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz3) {
            setState(() {
              widget.quizLayout.addQuizAt(result, quizIndex);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });
        break;
      case 3:
        Quiz4 quiz = Quiz4(
          answers: ['', ''],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
          connectionAnswers: ['', ''],
          connectionAnswerIndex: [null, null],
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget4(
              quiz: quiz,
              quizLayout: widget.quizLayout,
            ),
          ),
        ).then((result) {
          if (result is Quiz4) {
            setState(() {
              widget.quizLayout.addQuizAt(result, quizIndex);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });
        break;
      default:
        // Handle the default case here
        break;
    }
  }

  Widget getQuizView(int n, AbstractQuiz quiz) {
    switch (n) {
      case 1:
        return QuizView1(
          quiz: quiz as Quiz1,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
          quizLayout: widget.quizLayout,
        );
      case 2:
        return QuizView2(
          quiz: quiz as Quiz2,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
          quizLayout: widget.quizLayout,
        );
      case 3:
        return QuizView3(
          quiz: quiz as Quiz3,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
          quizLayout: widget.quizLayout,
        );
      case 4:
        return QuizView4(
          quiz: quiz as Quiz4,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
          quizLayout: widget.quizLayout,
          changePageViewState: (bool tint) {},
        );
      default:
        return Container(); // Handle the default case here
    }
  }

  void onPressedBack() {
    setState(() {
      if (curQuizIndex > 0) {
        curQuizIndex--;
        _pageController.animateToPage(curQuizIndex,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    });
  }

  void onPressedForward() {
    setState(() {
      if (curQuizIndex < maxQuizIndex + 1) {
        curQuizIndex++;
        _pageController.animateToPage(curQuizIndex,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    });
  }
}
