import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Widgets/LinePainter.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/config.dart';

double fontSizeBase = 10.0;

class QuizView4 extends StatefulWidget {
  final int quizTag;
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView4(
      {Key? key,
      required this.quizTag,
      this.screenHeightModifier = 1,
      this.screenWidthModifier = 1})
      : super(key: key);

  @override
  _QuizView4State createState() => _QuizView4State();
}

class _QuizView4State extends State<QuizView4> {
  Quiz4 quizData = Quiz4(
    answers: [],
    ans: [],
    question: '',
    maxAnswerSelection: 1,
  );

  List<Offset?> starts = [];
  List<Offset?> ends = [];
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

  @override
  void initState() {
    super.initState();
    _loadQuizFuture = loadQuiz();
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

  Future<void> loadQuiz() async {
    try {
      await quizData.loadQuiz(widget.quizTag); // 퀴즈 로드
      setState(() {});
    } catch (e) {
      print("퀴즈 로드 실패: $e");
      quizData = Quiz4(
        answers: ['11', '22', '33', '44', '55'],
        ans: [true, false, false, false, false],
        question: "11을 고르세요.",
        maxAnswerSelection: 1,
        connectionAnswers: ['C', 'E', 'A', 'B', 'D'],
        connectionAnswerIndex: [2, 4, 0, 1, 3],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadQuizFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("퀴즈 로드에 실패했습니다."));
          }
          if (starts.length == 0) {
            for (int i = 0; i < quizData.getAnswers().length; i++) {
              leftKeys.add(GlobalKey());
              rightKeys.add(GlobalKey());
              lineKeys.add(GlobalKey());
              curAnswer.add(-1);
              starts.add(null);
              ends.add(null);
              isDragging.add(false);
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                setOffsets();
              });
            }
          }
          // Future가 완료되면 UI 빌드
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(AppConfig.padding),
              child: Center(
                // Wrap the Column with a Center widget for horizontal centering
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Vertically center the content
                  children: <Widget>[
                    QuestionViewer(
                        question: quizData.getQuestion(),
                        fontSizeModifier: widget.screenWidthModifier),
                    SizedBox(height: AppConfig.padding),
                    Expanded(
                      // ListView.builder를 Expanded로 감싸기
                      child: ListView.builder(
                        itemCount:
                            quizData.getAnswers().length, // 마지막 "+" 버튼을 위해 +1
                        itemBuilder: (context, index) {
                          // 나머지 요소들은 기존 로직을 따름
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: AppConfig.padding *
                                    widget.screenHeightModifier),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppConfig.padding *
                                            2 *
                                            widget.screenWidthModifier,
                                        vertical: AppConfig.padding *
                                            widget
                                                .screenWidthModifier), // 텍스트 주변에 여백 추가
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue,
                                          width: 2), // 테두리 색상과 너비 설정
                                      borderRadius: BorderRadius.circular(
                                          5), // 테두리 둥근 모서리 설정
                                    ),
                                    child: Text(
                                      quizData.getAnswerAt(index),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: AppConfig.fontSize *
                                              3 *
                                              widget
                                                  .screenWidthModifier), // 텍스트 스타일 설정
                                    ),
                                  ),
                                ),
                                Container(
                                  width: AppConfig.screenWidth *
                                      0.3 *
                                      widget.screenWidthModifier,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppConfig.largePadding),
                                  child: GestureDetector(
                                    onTapDown: (details) {
                                      setState(() {
                                        isDragging[index] = true;
                                        Offset position =
                                            leftDotLinePaintLocal[index];
                                        starts[index] =
                                            position; // 드래그 시작 시 시작점 업데이트
                                        ends[index] = position;
                                      });
                                    },
                                    onPanUpdate: (details) {
                                      if (isDragging[index] == false) return;
                                      setState(() {
                                        ends[index] = details
                                            .localPosition; // 드래그하는 동안 끝점 업데이트
                                      });
                                    },
                                    onPanEnd: (details) {
                                      if (isDragging[index] == false) return;
                                      setState(() {
                                        for (var key in rightKeys) {
                                          Offset globalPosition =
                                              rightDotGlobal[
                                                  rightKeys.indexOf(key)];
                                          double distance = (globalPosition -
                                                  details.globalPosition)
                                              .distance;
                                          if (distance <= 20) {
                                            RenderBox linePaint =
                                                lineKeys[index]
                                                        .currentContext!
                                                        .findRenderObject()
                                                    as RenderBox;
                                            Offset position = linePaint
                                                .globalToLocal(globalPosition);
                                            ends[index] = position;
                                            quizData.setConnectionAnswerIndexAt(
                                                index, rightKeys.indexOf(key));
                                            break;
                                          } else {
                                            ends[index] = null;
                                          }
                                        }

                                        // 드래그 종료 후 필요한 작업 수행
                                        isDragging[index] = false;
                                      });
                                    },
                                    child: CustomPaint(
                                      key: lineKeys[index],
                                      painter: starts[index] != null &&
                                              ends[index] != null
                                          ? LinePainter(
                                              start: starts[index]!,
                                              end: ends[index]!)
                                          : null,
                                      child: Container(
                                        height: AppConfig.screenHeight * 0.15 * widget.screenHeightModifier,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              key: leftKeys[index],
                                              height: 15.0 * widget.screenWidthModifier,
                                              width: 15.0 * widget.screenWidthModifier,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Container(
                                              key: rightKeys[index],
                                              height: 15.0 * widget.screenWidthModifier,
                                              width: 15.0 * widget.screenWidthModifier,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppConfig.largePadding,
                                        vertical: AppConfig.padding), // 텍스트 주변에 여백 추가
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue,
                                          width: 2), // 테두리 색상과 너비 설정
                                      borderRadius: BorderRadius.circular(
                                          5), // 테두리 둥근 모서리 설정
                                    ),
                                    child: Text(
                                      quizData.getConnectionAnswerAt(index),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize:
                                              AppConfig.fontSize * 3 * widget.screenWidthModifier), // 텍스트 스타일 설정
                                    ),
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
          );
        } else {
          // 로딩 중 UI
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
