import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Class/scoreCard.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';

class ScoringScreen extends StatefulWidget {
  final QuizLayout quizLayout;
  final double heightModifier;
  final int score;
  final String resultUrl;
  final String userName;

  const ScoringScreen(
      {Key? key,
      required this.quizLayout,
      required this.heightModifier,
      required this.score,
      required this.resultUrl,
      required this.userName})
      : super(key: key);

  @override
  _ScoringScreenState createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  late int score;
  late ScoreCard scoreCard;
  late double size;
  late Offset position;

  @override
  void initState() {
    super.initState();
    score = widget.score;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    scoreCard = widget.quizLayout.getScoreCard();
    scoreCard.initbackGroundImage(widget.quizLayout);
    size = scoreCard.getSize();
    position = scoreCard.getPosition();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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
      child: Theme(
        data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
        child: Scaffold(
          appBar: viewerAppBar(
              quizLayout: widget.quizLayout, showDragHandle: false),
          body: Container(
            decoration: backgroundDecoration(quizLayout: widget.quizLayout),
            child: Stack(
              children: [
                Column(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.quizLayout.getTitle(),
                          style: TextStyle(
                            fontSize: AppConfig.fontSize * 1.3,
                            fontWeight: FontWeight.bold,
                            color: widget.quizLayout.getColorScheme().primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppConfig.padding,
                    ),
                    Text(
                      widget.quizLayout.getCreator(),
                      style: TextStyle(
                        fontSize: AppConfig.fontSize * 0.7,
                        fontWeight: FontWeight.w300,
                        color: widget.quizLayout.getColorScheme().primary,
                      ),
                    ),
                    SizedBox(
                      height: AppConfig.padding,
                    ),
                    //TODO: 컨테이너 클릭하면 뒤집어지면서 틀린 문제 확인.
                    Container(
                      width: AppConfig.screenWidth * 0.8,
                      height:
                          AppConfig.screenHeight * 0.55 * widget.heightModifier,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: scoreCard.getBackgroundImage(),
                      child: Container(
                        width: scoreCard.getSize(),
                        height: scoreCard.getSize(),
                        child: Stack(
                          children: [
                            Positioned(
                              left: position.dx - size / 2 + 10,
                              top: position.dy - size / 2 + 10,
                              child: Container(
                                alignment: Alignment.center,
                                width: size,
                                height: size,
                                decoration: BoxDecoration(
                                  color: Colors
                                      .transparent, // Keep the container transparent
                                ),
                                child: Text(
                                  score.toString(),
                                  style: TextStyle(
                                    fontSize: size / 2,
                                    fontWeight: FontWeight.w800,
                                    color: widget.quizLayout
                                        .getColorScheme()
                                        .error,
                                    fontFamily: MyFonts.ongleYunu,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //TODO : sns로 결과 공유하는 기능 만들어야하는데, 점수를 공유하고 웹사이트로 이동시킬 수 있어야하니까 이건 나중에 구현하는걸로 하고 지금은 점수 UI만 좀 예쁘게 만들어보는걸로.
                    SizedBox(
                      height: AppConfig.padding,
                    ),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: AppConfig.fontSize * 0.7,
                        fontWeight: FontWeight.w300,
                        color: widget.quizLayout.getColorScheme().primary,
                      ),
                    ),
                    SizedBox(
                      height: AppConfig.largePadding * 2,
                    ),
                    SizedBox(
                      width: AppConfig.screenWidth * 0.8,
                      child: FloatingActionButton(
                        foregroundColor: widget.quizLayout
                            .getColorScheme()
                            .secondaryContainer,
                        onPressed: () {
                          _onPopInvoked(true);
                        },
                        child: Text("돌아가기",
                            style: TextStyle(
                              color: widget.quizLayout
                                  .getColorScheme()
                                  .onSecondaryContainer,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: AppConfig.largePadding,
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: viewerBottomBar(
            quizLayout: widget.quizLayout,
            onPressedForward: () {},
            onPressedBack: () {},
            showDragHandle: false,
            showSwitchButton: false,
          ),
        ),
      ),
    );
  }

  void _onPopInvoked(bool didPop) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
