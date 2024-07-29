import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Class/scoreCard.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

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
  late double xRatio;
  late double yRatio;
  String shareText = "";

  @override
  void initState() {
    super.initState();
    score = widget.score;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    scoreCard = widget.quizLayout.getScoreCard();
    scoreCard.initbackGroundImage(widget.quizLayout);
    size = scoreCard.getSize();
    xRatio = scoreCard.getXRatio();
    yRatio = scoreCard.getYRatio();
    shareText = Intl.message(
      "I got {score} in {widget.quizLayout.getTitle()}!",
      name: 'shareText',
      args: [score, widget.quizLayout.getTitle()],
      examples: const {'score': 42, 'title': 'Quiz Title'},
    )
        .replaceAll('{score}', score.toString())
        .replaceAll('{title}', widget.quizLayout.getTitle());
    Logger.log(shareText);
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
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: widget.quizLayout.getColorScheme().surface,
              ),
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
                      FlipCard(front: makeScoreCard(), back: answerCheck()),

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
                        height: AppConfig.largePadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            child: GestureDetector(
                              onTap: () {
                                // Facebook 공유 링크
                                _shareToFacebook(shareText, widget.resultUrl);
                              },
                              child: Image.asset(
                                'assets/images/facebook.png',
                                width: AppConfig.fontSize,
                                height: AppConfig.fontSize,
                              ),
                            ),
                          ),
                          SizedBox(width: AppConfig.padding),
                          CircleAvatar(
                            child: GestureDetector(
                              onTap: () {
                                // Facebook 공유 링크
                                _shareToTwitter(shareText, widget.resultUrl);
                              },
                              child: Image.asset(
                                'assets/images/twitter.png',
                                width: AppConfig.fontSize,
                                height: AppConfig.fontSize,
                              ),
                            ),
                          ),
                          SizedBox(width: AppConfig.padding),
                          CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: IconButton(
                              iconSize: AppConfig.fontSize,
                              icon: Icon(Icons.copy),
                              color: Colors.white,
                              onPressed: () {
                                // Instagram 공유 링크
                                _copyToClipboard(widget.resultUrl);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppConfig.largePadding,
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
                          child: Text(Intl.message("Move_Home"),
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
          ),
        ),
      ),
    );
  }

  Widget makeScoreCard() {
    double shortestSide = math.min(AppConfig.screenWidth * 0.8,
        AppConfig.screenHeight * 0.55 * widget.heightModifier);
    double size = scoreCard.getSize() * shortestSide;
    return Container(
      width: AppConfig.screenWidth * 0.8,
      height: AppConfig.screenHeight * 0.55 * widget.heightModifier,
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
              top: AppConfig.screenHeight *
                      0.55 *
                      widget.heightModifier *
                      scoreCard.getYRatio() -
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
                    color: widget.quizLayout.getColorScheme().error,
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

  Widget answerCheck() {
    int quizCount = widget.quizLayout.getQuizCount();
    List<bool> answerCheckList = widget.quizLayout.getSolveResult();
    return Container(
      width: AppConfig.screenWidth * 0.8,
      height: AppConfig.screenHeight * 0.55 * widget.heightModifier,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: scoreCard.getBackgroundImage(),
      child: ListView.builder(
          itemCount: (answerCheckList.length + 1) ~/ 2, // itemCount를 절반으로 조정
          itemBuilder: (context, index) {
            int actualIndex = index * 2; // 실제 인덱스 계산
            Color stateColor1 =
                widget.quizLayout.getQuiz(actualIndex).getState();
            List<Widget> rowChildren = [
              Spacer(
                flex: 1,
              ),
              answerBox(actualIndex, answerCheckList[actualIndex]),
            ];

            // quizCount가 홀수인 경우를 처리
            if (actualIndex + 1 < quizCount) {
              rowChildren.add(
                  answerBox(actualIndex + 1, answerCheckList[actualIndex + 1]));
            } else {
              // 홀수 번째 항목에 대해 눈에 보이지 않는 answerBox 추가
              rowChildren.add(InvisibleAnswerBox());
            }

            rowChildren.add(Spacer(
              flex: 1,
            ));

            return Row(
              children: rowChildren,
            );
          }),
    );
  }

  Widget answerBox(int index, bool answer, {bool isLast = false}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0), // InkWell 내부 여백
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞춤
          children: [
            SizedBox(width: AppConfig.padding), // Add space between columns
            Text(
              Intl.message("Prob") + ' ${index + 1} : ',
              style: TextStyle(
                fontFamily: widget.quizLayout.getAnswerFont(),
                fontSize: AppConfig.fontSize,
                color: widget.quizLayout.getColorScheme().primary,
              ),
            ), // Displaying quiz number
            answer
                ? Icon(
                    Icons.check,
                    color: widget.quizLayout.getColorScheme().primary,
                    size: AppConfig.fontSize,
                  )
                : Icon(
                    Icons.close,
                    color: widget.quizLayout.getColorScheme().error,
                    size: AppConfig.fontSize,
                  ),
            SizedBox(width: AppConfig.padding), // Add space between columns
          ],
        ),
      ),
    );
  }

  Widget InvisibleAnswerBox() {
    return Opacity(
      opacity: 0.0,
      child: answerBox(0, true, isLast: true), // 인덱스와 색상은 실제로 사용되지 않음
    );
  }

  void _onPopInvoked(bool didPop) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _shareToTwitter(String title, String resultUrl) async {
    Logger.log(title);
    Logger.log(resultUrl);
    final Uri twitterUrl = Uri.parse(
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(resultUrl)}',
    );

    if (await canLaunchUrl(twitterUrl)) {
      await launchUrl(twitterUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch twitter.'),
        ),
      );
    }
  }

  void _shareToFacebook(String title, String resultUrl) async {
    final Uri facebookUrl = Uri.parse(
      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(resultUrl)}&quote=${Uri.encodeComponent(title)}',
    );

    if (await canLaunchUrl(facebookUrl)) {
      await launchUrl(facebookUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch Facebook.'),
        ),
      );
    }
  }

  void _copyToClipboard(String resultUrl) {
    Clipboard.setData(ClipboardData(text: resultUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('URL copied to clipboard.'),
      ),
    );
  }
}
