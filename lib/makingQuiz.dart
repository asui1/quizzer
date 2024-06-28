import 'dart:async';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';
import 'package:quizzer/Widgets/Generator/quizWidget1Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget2Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget4Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget1Viewer.dart';
import 'package:quizzer/Widgets/Generator/quizWidget3Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget2Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget3Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget4Viewer.dart';
import 'package:quizzer/config.dart';

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
                          image: AssetImage(
                              widget.quizLayout.getImage(1).getImagePath()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            )
          : null,
      body: Container(
        decoration: widget.quizLayout.getBackgroundImage().isColor()
            ? BoxDecoration(
                color: widget.quizLayout.getBackgroundImage().getColor(),
              )
            : BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      widget.quizLayout.getBackgroundImage().getImagePath()),
                  fit: BoxFit.cover,
                ),
              ),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            // Update the position of the widget here
          },
          child: Stack(
            children: [
              FilpStyle12(
                quizLayout: widget.quizLayout,
                onPressedBack: () {},
                onPressedForward: () {},
              ),
              Center(
                  child: Column(
                children: [
                  Spacer(flex: 1),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: index < widget.quizLayout.getQuizCount()
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: getQuizView(widget.quizLayout.getQuiz(index).getLayoutType()),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        20), // 모서리 둥글기 정도 조절
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
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
                                                    children: List.generate(4,
                                                        (index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context,
                                                              'Item $index');
                                                          moveToQuizWidgetGenerator(
                                                              index);
                                                        },
                                                        child: Card(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Expanded(
                                                                flex: 3,
                                                                child: Image.asset(
                                                                    'images/one.jpg',
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Center(
                                                                  child: Text(
                                                                      'Item $index'),
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
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          width: 100, // 너비 설정
                                          height: 100, // 높이 설정
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200], // 배경색 설정
                                          ),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                  ),
                  Text(
                    '${min(curQuizIndex + 1, widget.quizLayout.getQuizCount())} / ${widget.quizLayout.getQuizCount()}',
                    style: TextStyle(
                      fontSize: 36, // Adjust as needed
                      color: Colors.black, // Adjust as needed
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              )),
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
                          onPressedBack: () {},
                          onPressedForward: () {}),
                    )
                  : Container(
                      height: widget.quizLayout.getBottomBarHeight(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              widget.quizLayout.getImage(2).getImagePath()),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BottomBarStack(
                          quizLayout: widget.quizLayout,
                          onPressedBack: () {},
                          onPressedForward: () {}),
                    ),
            )
          : null,
    );
  }

  void moveToQuizWidgetGenerator(int n) {
    switch (n) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget1(),
          ),
        ).then((result) {
          if (result is Quiz1) {
            setState(() {
              widget.quizLayout.addQuiz(result);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });

        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget2(),
          ),
        ).then((result) {
          if (result is Quiz2) {
            setState(() {
              widget.quizLayout.addQuiz(result);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget3(),
          ),
        ).then((result) {
          if (result is Quiz3) {
            setState(() {
              widget.quizLayout.addQuiz(result);
            });
            // 필요한 추가 작업을 여기에 수행합니다.
          }
        });
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget4(),
          ),
        ).then((result) {
          if (result is Quiz4) {
            setState(() {
              widget.quizLayout.addQuiz(result);
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
  Widget getQuizView(int n) {
    switch (n) {
      case 1:
        return QuizView1(
          quizTag: 999,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
        );
      case 2:
        return QuizView2(
          quizTag: 999,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
        );
      case 3:
        return QuizView3(
          quizTag: 999,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
        );
      case 4:
        return QuizView4(
          quizTag: 999,
          screenHeightModifier: 0.5,
          screenWidthModifier: 0.65,
        );
      default:
        return Container(); // Handle the default case here
    }
  }
}
