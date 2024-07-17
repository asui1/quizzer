import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:quizzer/Widgets/LinePainter.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

class QuizView4 extends StatefulWidget {
  final Quiz4 quiz;
  final double screenWidthModifier;
  final double screenHeightModifier;
  final Function(bool) changePageViewState;

  QuizView4({
    Key? key,
    required this.quiz,
    this.screenHeightModifier = 1,
    this.screenWidthModifier = 1,
    required this.changePageViewState,
  }) : super(key: key);

  @override
  _QuizView4State createState() => _QuizView4State();
}

class _QuizView4State extends State<QuizView4> {
  late List<Offset?> starts;
  late List<Offset?> ends;
  List<bool> isDragging = [];
  List<GlobalKey> leftKeys = [];
  List<GlobalKey> rightKeys = [];
  List<GlobalKey> lineKeys = [];
  List<int> curAnswer = [];
  late Future<void> _loadQuizFuture;
  List<Offset> leftDotGlobal = [];
  List<Offset> leftDotLinePaintLocal = [];
  List<Offset> rightDotGlobal = [];
  bool needUpdate = true;
  double dx = 0.0;
  double dy = 0.0;
  Offset dragStart = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    initializeQuiz();
  }

  void initializeQuiz() {
    widget.quiz.initOffsets();
    starts = widget.quiz.getUserStarts();
    ends = widget.quiz.getUserEnds();
    leftKeys.clear();
    rightKeys.clear();
    lineKeys.clear();
    curAnswer.clear();
    isDragging.clear();
    for (int i = 0; i < widget.quiz.getAnswers().length; i++) {
      leftKeys.add(GlobalKey());
      rightKeys.add(GlobalKey());
      lineKeys.add(GlobalKey());
      curAnswer.add(-1);
      isDragging.add(false);
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setOffsets();
    });
  }

  void setOffsets() {
    if (needUpdate) {
      leftDotGlobal = leftKeys.map((key) {
        RenderBox leftDot = key.currentContext!.findRenderObject() as RenderBox;
        Offset GlobalPosition = leftDot.localToGlobal(Offset.zero);
        GlobalPosition = Offset(GlobalPosition.dx + leftDot.size.width / 2,
            GlobalPosition.dy + leftDot.size.height / 2);
        return GlobalPosition;
      }).toList();
      leftDotLinePaintLocal = lineKeys.map((key) {
        RenderBox linePaint =
            key.currentContext!.findRenderObject() as RenderBox;
        Offset position =
            linePaint.globalToLocal(leftDotGlobal[lineKeys.indexOf(key)]);
        return position;
      }).toList();
      rightDotGlobal = rightKeys.map((key) {
        RenderBox rightDot =
            key.currentContext!.findRenderObject() as RenderBox;
        Offset GlobalPosition = rightDot.localToGlobal(Offset.zero);
        GlobalPosition = Offset(GlobalPosition.dx + rightDot.size.width / 2,
            GlobalPosition.dy + rightDot.size.height / 2);
        return GlobalPosition;
      }).toList();
      needUpdate = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);
    if (widget.quiz.getNeedUpdate()) {
      initializeQuiz();
    }
    starts = widget.quiz.getUserStarts();
    ends = widget.quiz.getUserEnds();
    // Future가 완료되면 UI 빌드
    return Theme(
      data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
      child: Scaffold(
        body: Container(
          decoration: backgroundDecoration(quizLayout: quizLayout),
          child: Padding(
            padding: EdgeInsets.all(AppConfig.padding),
            child: Center(
              // Wrap the Column with a Center widget for horizontal centering
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Vertically center the content
                children: <Widget>[
                  QuestionViewer(
                      question: widget.quiz.getQuestion(),
                      fontSizeModifier: widget.screenWidthModifier,
                      quizLayout: quizLayout),
                  SizedBox(height: AppConfig.padding),
                  Expanded(
                    // ListView.builder를 Expanded로 감싸기
                    child: ListView.builder(
                      itemCount:
                          widget.quiz.getAnswers().length, // 마지막 "+" 버튼을 위해 +1
                      itemBuilder: (context, index) {
                        // 나머지 요소들은 기존 로직을 따름
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: AppConfig.padding *
                                  widget.screenHeightModifier),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: TextStyleWidget(
                                  textStyle: quizLayout.getTextStyle(2),
                                  text: widget.quiz.getAnswerAt(index),
                                  colorScheme: quizLayout.getColorScheme(),
                                  modifier: widget.screenWidthModifier,
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onHorizontalDragStart: (details) {
                                    Logger.log("Drag start");
                                    setState(() {
                                      isDragging[index] = true;
                                      widget.changePageViewState(
                                          false); // Disable PageView swipe
                                      Offset position =
                                          leftDotLinePaintLocal[index];
                                      widget.quiz
                                          .setUserStartAt(index, position);
                                      widget.quiz.setUserEndAt(index, position);
                                      dragStart = details.localPosition;
                                    });
                                  },
                                  onHorizontalDragUpdate: (details) {
                                    if (!isDragging[index]) return;
                                    setState(() {
                                      widget.quiz.setUserEndAt(
                                          index, details.localPosition);
                                    });
                                  },
                                  onHorizontalDragEnd: (details) {
                                    if (!isDragging[index]) {
                                      widget.changePageViewState(
                                          true); // Enable PageView swipe
                                      return;
                                    }
                                      Offset diff = details.localPosition -
                                          dragStart +
                                          leftDotGlobal[index];
                                      for (var key in rightKeys) {
                                        Offset globalPosition = rightDotGlobal[
                                            rightKeys.indexOf(key)];

                                        double distance =
                                            (globalPosition - diff).distance;
                                        if (distance <= 40) {
                                          Offset position = rightDotGlobal[
                                                  rightKeys.indexOf(key)] -
                                              leftDotGlobal[index];
                                          Offset start = widget.quiz
                                              .getUserStartAt(index)!;
                                          widget.quiz.setUserEndAt(
                                              index, start + position);
                                          widget.quiz.setUserConnectionIndexAt(
                                              index, rightKeys.indexOf(key));
                                          break;
                                        } else {
                                          widget.quiz.setUserEndAt(index, null);
                                        }
                                        widget.changePageViewState(true);
                                      }

                                      // 드래그 종료 후 필요한 작업 수행
                                    setState(() {
                                      isDragging[index] = false;
                                    });
                                  },
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppConfig.largePadding *
                                              widget.screenWidthModifier),
                                      child: CustomPaint(
                                        key: lineKeys[index],
                                        painter: starts[index] != null &&
                                                ends[index] != null &&
                                                widget.screenHeightModifier !=
                                                    0.7
                                            ? LinePainter(
                                                start: starts[index]!,
                                                end: ends[index]!,
                                                color: quizLayout
                                                    .getColorScheme()
                                                    .primary,
                                              )
                                            : null,
                                        child: Container(
                                          height: AppConfig.screenHeight *
                                              0.15 *
                                              widget.screenHeightModifier,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                key: leftKeys[index],
                                                height: 15.0 *
                                                    widget.screenWidthModifier,
                                                width: 15.0 *
                                                    widget.screenWidthModifier,
                                                decoration: BoxDecoration(
                                                  color: quizLayout
                                                      .getColorScheme()
                                                      .primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Container(
                                                key: rightKeys[index],
                                                height: 15.0 *
                                                    widget.screenWidthModifier,
                                                width: 15.0 *
                                                    widget.screenWidthModifier,
                                                decoration: BoxDecoration(
                                                  color: quizLayout
                                                      .getColorScheme()
                                                      .primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: TextStyleWidget(
                                  textStyle: quizLayout.getTextStyle(2),
                                  text:
                                      widget.quiz.getConnectionAnswerAt(index),
                                  colorScheme: quizLayout.getColorScheme(),
                                  modifier: widget.screenWidthModifier,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
