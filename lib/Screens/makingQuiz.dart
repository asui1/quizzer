import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Screens/solver.dart';
import 'package:quizzer/Setup/Strings.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';
import 'package:quizzer/Widgets/Generator/quizWidget1Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget2Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget4Generator.dart';
import 'package:quizzer/Screens/scoreCardCreator.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget1Viewer.dart';
import 'package:quizzer/Widgets/Generator/quizWidget3Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget2Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget3Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget4Viewer.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:uuid/uuid.dart';

class MakingQuiz extends StatefulWidget {
  MakingQuiz({Key? key}) : super(key: key);

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);
    maxQuizIndex = quizLayout.getQuizCount();

    return Theme(
      data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: backgroundDecoration(quizLayout: quizLayout),
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: AppConfig.screenHeight * 0.9,
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: AppConfig.screenHeight * 0.9,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: AppConfig.padding,
                            ),
                            Text(
                              quizLayout.getTitle(),
                              style: TextStyle(
                                fontSize:
                                    AppConfig.fontSize * 2, // Adjust as needed
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: AppConfig.padding,
                            ),
                            Container(
                              height: AppConfig.screenHeight * 0.6,
                              width: AppConfig.screenWidth *
                                  0.9, // AppConfig.ScreenWidth의 1/2 크기로 설정

                              child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      curQuizIndex = index;
                                    });
                                  },
                                  itemCount: quizLayout.getQuizCount() + 1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: index < quizLayout.getQuizCount()
                                          ? GestureDetector(
                                              key: ValueKey(
                                                  "makingQuizPageView$index"),
                                              onDoubleTap: () {
                                                navigateToQuizWidgetGenerator(
                                                    quizLayout.getQuiz(index),
                                                    quizLayout,
                                                    index);
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
                                                      quizLayout
                                                          .getQuiz(index)
                                                          .getLayoutType(),
                                                      quizLayout
                                                          .getQuiz(index)),
                                                ),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // 모서리 둥글기 정도 조절
                                              child: Material(
                                                child: InkWell(
                                                  key: ValueKey(
                                                      "makingQuizPageView$index"),
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
                              height: AppConfig.padding,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 가운데 정렬
                              children: <Widget>[
                                IconButton(
                                  key: const ValueKey('deleteQuizButton'),
                                  onPressed: () {
                                    setState(() {
                                      if (quizLayout.getQuizCount() >
                                          curQuizIndex) {
                                        quizLayout.removeQuiz(curQuizIndex);
                                      }
                                    });
                                    // Delete current quiz logic here
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: quizLayout.getColorScheme().primary,
                                  ),
                                ),
                                SizedBox(
                                  width: AppConfig.largePadding,
                                ),
                                Text(
                                  Intl.message("Quiz") +
                                      ' : ${min(curQuizIndex + 1, quizLayout.getQuizCount())} / ${quizLayout.getQuizCount()}',
                                  style: TextStyle(
                                    fontFamily: MyFonts.gothicA1Bold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppConfig.fontSize *
                                        1.5, // Adjust as needed
                                    color: quizLayout.getColorScheme().primary,
                                  ),
                                ),
                                SizedBox(
                                  width: AppConfig.largePadding,
                                ),
                                IconButton(
                                  key: const ValueKey('editQuizButton'),
                                  icon: Icon(
                                    Icons.edit,
                                    size: AppConfig.fontSize * 1.5,
                                    color: quizLayout.getColorScheme().primary,
                                  ), // "+" 아이콘과 크기 설정
                                  onPressed: () {
                                    if (curQuizIndex <
                                        quizLayout.getQuizCount())
                                      navigateToQuizWidgetGenerator(
                                          quizLayout.getQuiz(curQuizIndex),
                                          quizLayout,
                                          curQuizIndex);
                                  },
                                ),
                                SizedBox(
                                  width: AppConfig.largePadding,
                                ),
                                IconButton(
                                  key: const ValueKey('addQuizButton'),
                                  icon: Icon(
                                    Icons.add_circle,
                                    size: AppConfig.fontSize * 1.5,
                                    color: quizLayout.getColorScheme().primary,
                                  ), // "+" 아이콘과 크기 설정
                                  onPressed: () {
                                    showQuizSelectionDialog(
                                        context, curQuizIndex);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppConfig.largePadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly, // 버튼들 사이에 균등한 공간 배분
                              children: <Widget>[
                                tempSaveButton(context, quizLayout),
                                ElevatedButton(
                                  key: const ValueKey('previewButton'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizSolver(
                                          quizLayout: quizLayout,
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
                                  child: Text(Intl.message("Preview")),
                                ),
                                // 세 번째 버튼: 저장 버튼
                                IconButton(
                                  iconSize: AppConfig.fontSize * 1.5,
                                  icon: Icon(Icons.arrow_forward,
                                      color:
                                          quizLayout.getColorScheme().primary),
                                  onPressed: () async {
                                    final result = await Navigator.of(context)
                                        .push(PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          ScoreCardGenerator(), // 여기서 NewPage()는 새로운 페이지 위젯입니다.
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin =
                                            Offset(1.0, 0.0); // 오른쪽에서 시작
                                        var end = Offset.zero;
                                        var curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ));
                                    if (result != null && result as int >= 0) {
                                      int result2 = result as int;
                                      setState(() {
                                        curQuizIndex = result2;
                                        _pageController.jumpToPage(result2);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppConfig.largePadding,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0, // Set to 0.0 to align at the top
                  left: 10.0, // Set to 0.0 to align at the left
                  child: IconButton(
                    iconSize: AppConfig.fontSize * 1.5,
                    icon: Icon(Icons.arrow_back_ios,
                        color: quizLayout.getColorScheme().primary),
                    onPressed: () {
                      Navigator.pop(
                          context); // Pops the current route from the navigator to get out of the page
                    },
                  ),
                ),
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
            width: AppConfig.screenWidth * 0.8,
            child: GridView.count(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              children: List.generate(4, (index) {
                return GestureDetector(
                  key: ValueKey("quizSelectionDialog$index"),
                  onTap: () {
                    Navigator.pop(context, 'Item $index');
                    moveToQuizWidgetGenerator(index, quizIndex);
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Image.asset(
                              'assets/images/questiontype${index + 1}.jpg',
                              fit: BoxFit.contain),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(Intl.message('quizItem$index')),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(Intl.message("Close")),
            ),
          ],
        );
      },
    );
  }

  void navigateToQuizWidgetGenerator(
      AbstractQuiz quiz, QuizLayout quizLayout, int index) {
    int n = quiz.getLayoutType();
    switch (n) {
      case 1:
        Quiz1 copy = Quiz1.copy(quiz as Quiz1);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget1(
              quiz: copy,
            ),
          ),
        ).then((result) {
          if (result is Quiz1) {
            quizLayout.setQuiz1At(result, index);
          }
        });
        break;
      case 2:
        Quiz2 copy = Quiz2.copy(quiz as Quiz2);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget2(
              quiz: copy,
            ),
          ),
        ).then((result) {
          if (result is Quiz2) {
            quizLayout.setQuiz2At(result, index);
          }
        });
        break;
      case 3:
        Quiz3 copy = Quiz3.copy(quiz as Quiz3);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget3(
              quiz: copy,
            ),
          ),
        ).then((result) {
          if (result is Quiz3) {
            quizLayout.setQuiz3At(result, index);
          }
        });
        break;
      case 4:
        Quiz4 copy = Quiz4.copy(quiz as Quiz4);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget4(
              quiz: copy,
            ),
          ),
        ).then((result) {
          if (result is Quiz4) {
            quizLayout.setQuiz4At(result, index);
          }
        });
        break;
    }
  }

  void moveToQuizWidgetGenerator(int n, int quizIndex) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context, listen: false);
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
            ),
          ),
        ).then((result) {
          if (result is Quiz1) {
            setState(() {
              quizLayout.addQuizAt(result, quizIndex);
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
            ),
          ),
        ).then((result) {
          if (result is Quiz2) {
            setState(() {
              quizLayout.addQuizAt(result, quizIndex);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });
        break;
      case 2:
        Quiz3 quiz = Quiz3(
          answers: ['', '', ''],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget3(
              quiz: quiz,
            ),
          ),
        ).then((result) {
          if (result is Quiz3) {
            setState(() {
              quizLayout.addQuizAt(result, quizIndex);
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
            ),
          ),
        ).then((result) {
          if (result is Quiz4) {
            setState(() {
              quizLayout.addQuizAt(result, quizIndex);
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
          key: ValueKey(quiz.id),
          quiz: quiz as Quiz1,
          screenHeightModifier: 0.7,
          screenWidthModifier: 0.7,
        );
      case 2:
        return QuizView2(
          key: ValueKey(quiz.id),
          quiz: quiz as Quiz2,
          screenHeightModifier: 0.7,
          screenWidthModifier: 0.7,
        );
      case 3:
        return QuizView3(
          key: ValueKey(quiz.id),
          quiz: quiz as Quiz3,
          screenHeightModifier: 0.7,
          screenWidthModifier: 0.7,
        );
      case 4:
        return QuizView4(
          key: ValueKey(quiz.id),
          quiz: quiz as Quiz4,
          screenHeightModifier: 0.7,
          screenWidthModifier: 0.7,
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
