import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Class/scoreCard.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/DraggableTextWidget.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';

class ScoreCardGenerator extends StatefulWidget {
  const ScoreCardGenerator({Key? key}) : super(key: key);

  @override
  _ScoreCardGeneratorState createState() => _ScoreCardGeneratorState();
}

class _ScoreCardGeneratorState extends State<ScoreCardGenerator> {
  late ScoreCard scoreCard;
  bool _isTapInProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);
    scoreCard = quizLayout.getScoreCard();
    scoreCard.initbackGroundImage(quizLayout);
    double heightModifier = (AppConfig.screenHeight -
            quizLayout.getAppBarHeight() -
            quizLayout.getBottomBarHeight()) /
        (AppConfig.screenHeight);
    scoreCard.initbackGroundImage(quizLayout);
    Widget card = Container(
      width: AppConfig.screenWidth * 0.8,
      height: AppConfig.screenHeight * 0.55 * heightModifier,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: scoreCard.getBackgroundImage(),
      child: DraggableTextWidget(
        scoreCard: scoreCard,
      ),
    );

    return Theme(
      data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
      child: Scaffold(
        appBar: viewerAppBar(quizLayout: quizLayout, showDragHandle: false),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: quizLayout.getColorScheme().surface,
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Text(
                        quizLayout.getTitle(),
                        style: TextStyle(
                          fontSize: AppConfig.fontSize * 1.3,
                          fontWeight: FontWeight.bold,
                          color: quizLayout.getColorScheme().primary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppConfig.padding * heightModifier,
                    ),
                    Text(
                      quizLayout.getCreator(),
                      style: TextStyle(
                        fontSize: AppConfig.fontSize * 0.7,
                        fontWeight: FontWeight.w300,
                        color: quizLayout.getColorScheme().primary,
                      ),
                    ),
                    SizedBox(
                      height: AppConfig.padding * heightModifier,
                    ),
                    //TODO: 컨테이너 클릭하면 뒤집어지면서 틀린 문제 확인.
                    FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      onFlipDone: (isFront) {
                        scoreCard.nextBackgroundColor(quizLayout);
                        setState(() {});
                      },
                      front: card,
                      back: card,
                    ),
                    SizedBox(
                      height: AppConfig.padding * heightModifier,
                    ),
                    Text(
                      Intl.message("User_Name"),
                      style: TextStyle(
                        fontSize: AppConfig.fontSize * 0.7,
                        fontWeight: FontWeight.w300,
                        color: quizLayout.getColorScheme().primary,
                      ),
                    ),
                    SizedBox(
                      height: AppConfig.largePadding * 2 * heightModifier,
                    ),
                    SizedBox(
                      width: AppConfig.screenWidth * 0.8,
                      child: FloatingActionButton(
                        foregroundColor:
                            quizLayout.getColorScheme().secondaryContainer,
                        onPressed: () async {
                          if (_isTapInProgress)
                            return; // 이미 탭이 진행 중이면 아무 작업도 하지 않음
                          _isTapInProgress = true; // 탭 진행 중 상태로 설정
                          int savable = await quizLayout.checkSavable(context);
                          if (savable == -3) {
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                            _isTapInProgress = false; // 탭 진행 중 상태 해제
                          } else if (savable == -1) {
                            quizLayout.saveQuizLayout(
                                context, false); //실제 저장(업로드)가 이루어지는 함수.
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                            _isTapInProgress = false; // 탭 진행 중 상태 해제
                          } else if (savable == -2) {
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop();
                            _isTapInProgress = false; // 탭 진행 중 상태 해제
                          } else {
                            if (Navigator.of(context).canPop())
                              Navigator.of(context).pop(savable);
                            _isTapInProgress = false; // 탭 진행 중 상태 해제
                          }
                        },
                        child: Text(Intl.message("Upload"),
                            style: TextStyle(
                              color: quizLayout
                                  .getColorScheme()
                                  .onSecondaryContainer,
                            )),
                      ),
                    ),
                    Spacer(),
                  ],
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
        bottomNavigationBar: viewerBottomBar(
          quizLayout: quizLayout,
          onPressedForward: () {},
          onPressedBack: () {},
          showDragHandle: false,
          showSwitchButton: false,
        ),
      ),
    );
  }
}
