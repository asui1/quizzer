import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Class/scoreCard.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/keys.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Functions/shareResult.dart';
import 'package:quizzer/Setup/config.dart';
import 'dart:math' as math;

class QuizResultViewer extends StatefulWidget {
  final String resultId;

  QuizResultViewer({required this.resultId});

  @override
  _QuizResultViewerState createState() => _QuizResultViewerState();
}

class _QuizResultViewerState extends State<QuizResultViewer> {
  late String title;
  late String creator;
  late int score;
  late ScoreCard scoreCard;
  late String nickname;
  late ColorScheme colorScheme;
  late String uuid;
  String shareText = "";
  String resultUrl = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  Future<bool> loadAndInitializeData() async {
    var result = await loadResult(widget.resultId);
    Logger.log(result);
    if (result.isEmpty) {
      Logger.log("Failed to load result.");
      return false;
    }
    Logger.log("init data");
    initializeData(result);
    Logger.log("Result loaded successfully.");
    return true;
  }

  void initializeData(result) {
    title = result[0];
    creator = result[1];
    score = result[2];
    scoreCard = result[3];
    nickname = result[4];
    colorScheme = result[5];
    uuid = result[6];
    shareText = Intl.message(
      "I got {score} in {title}!",
      name: 'shareText',
      args: [score, title],
      examples: const {'score': 42, 'title': 'Quiz Title'},
    ).replaceAll('{score}', score.toString()).replaceAll('{title}', title);
    resultUrl = quizzerDomain + "#/result/?resultId=" + widget.resultId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadAndInitializeData(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!) {
          return Center(child: Text('Failed to load result.'));
        } else {
          return Theme(
            data: ThemeData.from(colorScheme: colorScheme),
            child: Scaffold(
              body: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                  ),
                  child: SingleChildScrollView(
                    // SingleChildScrollView로 감싸기
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: AppConfig.largePadding * 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: AppConfig.fontSize * 1.3,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppConfig.padding,
                            ),
                            Text(
                              creator,
                              style: TextStyle(
                                fontSize: AppConfig.fontSize * 0.7,
                                fontWeight: FontWeight.w300,
                                color: colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: AppConfig.padding,
                            ),
                            //TODO: 컨테이너 클릭하면 뒤집어지면서 틀린 문제 확인.
                            makeScoreCard(),
                            //TODO : sns로 결과 공유하는 기능 만들어야하는데, 점수를 공유하고 웹사이트로 이동시킬 수 있어야하니까 이건 나중에 구현하는걸로 하고 지금은 점수 UI만 좀 예쁘게 만들어보는걸로.
                            SizedBox(
                              height: AppConfig.padding,
                            ),
                            Text(
                              nickname,
                              style: TextStyle(
                                fontSize: AppConfig.fontSize * 0.7,
                                fontWeight: FontWeight.w300,
                                color: colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: AppConfig.largePadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: AppConfig.fontSize* 0.8,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Facebook 공유 링크
                                      shareToFacebook(
                                          context, shareText, resultUrl);
                                    },
                                    child: Image.asset(
                                      'assets/images/facebook.png',
                                      width: AppConfig.fontSize * 1.5,
                                      height: AppConfig.fontSize * 1.5,
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppConfig.padding),
                                CircleAvatar(
                                  radius: AppConfig.fontSize* 0.8,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Facebook 공유 링크
                                      shareToTwitter(
                                          context, shareText, resultUrl);
                                    },
                                    child: Image.asset(
                                      'assets/images/twitter.png',
                                      width: AppConfig.fontSize * 1.5,
                                      height: AppConfig.fontSize * 1.5,
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppConfig.padding),
                                CircleAvatar(
                                  radius: AppConfig.fontSize* 0.8,
                                  backgroundColor: Colors.purple,
                                  child: IconButton(
                                    iconSize: AppConfig.fontSize * 0.8,
                                    icon: Icon(Icons.copy),
                                    color: Colors.white,
                                    onPressed: () {
                                      // Instagram 공유 링크
                                      copyToClipboard(context, resultUrl);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppConfig.largePadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: AppConfig.screenWidth * 0.25,
                                  child: FloatingActionButton(
                                    heroTag: "resultViewerMoveHome",
                                    foregroundColor:
                                        colorScheme.secondaryContainer,
                                    onPressed: () {
                                      _onPopInvoked(true);
                                    },
                                    child: Text(Intl.message("Move_Home"),
                                        style: TextStyle(
                                          color:
                                              colorScheme.onSecondaryContainer,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: AppConfig.screenWidth * 0.1,
                                ),
                                SizedBox(
                                  width: AppConfig.screenWidth * 0.45,
                                  child: FloatingActionButton(
                                    heroTag: "resultViewerGoSolve",
                                    foregroundColor:
                                        colorScheme.primaryContainer,
                                    onPressed: () {
                                      final Uri newUri = Uri(
                                        path: '/solver',
                                        queryParameters: {'uuid': uuid},
                                      );
                                      Navigator.pop(context); // 현재 화면을 팝합니다.
                                      Navigator.pushNamed(
                                          context, newUri.toString());
                                    },
                                    child: Text(Intl.message("Go_Solve"),
                                        style: TextStyle(
                                          color: colorScheme.onPrimaryContainer,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppConfig.largePadding,
                            ),
                            SizedBox(height: AppConfig.largePadding * 3),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _onPopInvoked(bool didPop) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget makeScoreCard() {
    double shortestSide =
        math.min(AppConfig.screenWidth * 0.8, AppConfig.screenHeight * 0.55);
    double size = scoreCard.getSize() * shortestSide;
    return Container(
      width: AppConfig.screenWidth * 0.8,
      height: AppConfig.screenHeight * 0.55,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: scoreCard.getBackgroundImage(),
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned(
              left: AppConfig.screenWidth * 0.8 * scoreCard.getXRatio() -
                  size / 2 +
                  10,
              top: AppConfig.screenHeight * 0.55 * scoreCard.getYRatio() -
                  size / 2 +
                  10,
              child: Container(
                alignment: Alignment.center,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.transparent, // Keep the container transparent
                ),
                child: Text(
                  score.toString(),
                  style: TextStyle(
                    fontSize: size / 2,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.error,
                    fontFamily: MyFonts.ongleYunu,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
