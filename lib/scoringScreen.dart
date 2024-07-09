import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';

class ScoringScreen extends StatefulWidget {
  final QuizLayout quizLayout;
  final double heightModifier;

  const ScoringScreen(
      {Key? key, required this.quizLayout, required this.heightModifier})
      : super(key: key);

  @override
  _ScoringScreenState createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  late int score;
  @override
  void initState() {
    super.initState();
    score = widget.quizLayout.getScore();

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Future.delayed(Duration.zero, () {
          _onPopInvoked(didPop);
        });
      },
      child: Scaffold(
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
                Column(
                  children: [
                    SizedBox(
                      height: AppConfig.largePadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.quizLayout.titleImagePath.startsWith('images/')
                            ? Container()
                            : Image.file(
                                File(widget.quizLayout.titleImagePath)),
                        Text(
                          widget.quizLayout.getTitle(),
                          style: TextStyle(
                            color: widget.quizLayout.getTitleColor(),
                            fontSize: AppConfig.fontSize * 1.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppConfig.largePadding,
                    ),
                    Container(
                      width: AppConfig.screenWidth * 0.8,
                      height:
                          AppConfig.screenHeight * 0.6 * widget.heightModifier,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue, // 배경 색상
                        borderRadius: BorderRadius.circular(30), // 모서리 둥글기
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // 그림자 색상
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), // 그림자 위치 조정
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // 수직 방향 중앙 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 수평 방향 중앙 정렬
                        children: <Widget>[
                          SizedBox(
                              height:
                                  AppConfig.fontSize), // 텍스트를 수직 방향으로 약간 아래로 이동
                          Text(
                            '$score', // 점수 표시
                            style: TextStyle(
                              color: Colors.white, // 텍스트 색상
                              fontSize: AppConfig.fontSize * 5, // 텍스트 크기
                              fontWeight: FontWeight.bold, // 텍스트 굵기
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppConfig.largePadding,
                    ),
                    SizedBox(
                      width: AppConfig.screenWidth * 0.8,
                      child: FloatingActionButton(
                        onPressed: () {
                          _onPopInvoked(true);
                        },
                        child: const Text("돌아가기"),
                      ),
                    ),
                    //TODO : sns로 결과 공유하는 기능 만들어야하는데, 점수를 공유하고 웹사이트로 이동시킬 수 있어야하니까 이건 나중에 구현하는걸로 하고 지금은 점수 UI만 좀 예쁘게 만들어보는걸로.
                  ],
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
                        child: Container(),
                      )
                    : Container(
                        height: widget.quizLayout.getBottomBarHeight(),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.file(
                              File(
                                  widget.quizLayout.getImage(2).getImagePath()),
                            ).image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        child: Container(),
                      ),
              )
            : null,
      ),
    );
  }

  void _onPopInvoked(bool didPop) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
