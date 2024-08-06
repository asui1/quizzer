import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Class/quizLayout.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/LinePainter.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

class QuizWidget4 extends StatefulWidget {
  final Quiz4 quiz;
  QuizWidget4({Key? key, required this.quiz}) : super(key: key);
  @override
  _QuizWidget4State createState() => _QuizWidget4State();
}

class _QuizWidget4State extends State<QuizWidget4> {
  late TextEditingController questionController;
  List<TextEditingController> _controllersLeft = [];
  List<TextEditingController> _controllersRight = [];
  List<Offset?> starts = [];
  List<Offset?> ends = [];
  List<bool> isDragging = [];
  List<GlobalKey> leftKeys = [];
  List<GlobalKey> rightKeys = [];
  List<GlobalKey> lineKeys = [];
  List<Offset> leftDotGlobal = [];
  List<Offset> leftDotLinePaintLocal = [];
  List<Offset> rightDotGlobal = [];
  bool needUpdate = true;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.quiz.getQuestion());
    _initControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setOffsets();
    });
  }

  @override
  void dispose() {
    _controllersLeft.forEach((controller) => controller.dispose());
    _controllersRight.forEach((controller) => controller.dispose());
    questionController.dispose();

    super.dispose();
  }

  void _initControllers() {
    _controllersLeft = widget.quiz
        .getAnswers()
        .map((answer) => TextEditingController(text: answer))
        .toList();
    _controllersRight = widget.quiz
        .getConnectionAnswers()
        .map((answer) => TextEditingController(text: answer))
        .toList();
    for (int i = 0; i < widget.quiz.getAnswers().length; i++) {
      isDragging.add(false);
      leftKeys.add(GlobalKey());
      rightKeys.add(GlobalKey());
      lineKeys.add(GlobalKey());
    }
    starts = widget.quiz.getStarts();
    ends = widget.quiz.getEnds();
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
    return Theme(
      data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
              height: AppConfig.screenHeight,
              width: AppConfig.screenWidth,
              decoration: backgroundDecoration(quizLayout: quizLayout),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(AppConfig.padding),
                      child: Column(
                        children: <Widget>[
                          questionInputTextField(
                            controller: questionController,
                            onChanged: (value) {
                              widget.quiz.setQuestion(value);
                            },
                            quizLayout: quizLayout,
                          ),
                          SizedBox(height: AppConfig.padding),
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo is ScrollEndNotification) {
                                  needUpdate = true;
                                  setOffsets(); // 스크롤이 완전히 멈춘 후에 setOffsets 함수를 호출합니다.
                                }
                                return true; // 모든 스크롤 이벤트에 대해 true를 반환하여 이벤트 처리를 계속합니다.
                              },

                              // ListView.builder를 Expanded로 감싸기
                              child: ListView.builder(
                                itemCount: widget.quiz.getAnswers().length +
                                    1, // 마지막 "+" 버튼을 위해 +1
                                itemBuilder: (context, index) {
                                  if (index ==
                                      widget.quiz.getAnswers().length) {
                                    // 마지막 요소인 경우 "+" 버튼을 표시
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          bottom: AppConfig.padding * 6),
                                      width: 64.0,
                                      child: ElevatedButton(
                                        key: const ValueKey('addAnswerButton'),
                                        onPressed: () {
                                          needUpdate = true;
                                          setState(() {
                                            widget.quiz.addAnswerPair();
                                            _controllersLeft
                                                .add(TextEditingController());
                                            _controllersRight
                                                .add(TextEditingController());
                                            starts.add(null);
                                            ends.add(null);
                                            isDragging.add(false);
                                            leftKeys.add(GlobalKey());
                                            rightKeys.add(GlobalKey());
                                            lineKeys.add(GlobalKey());
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              setOffsets();
                                            });
                                          });
                                        },
                                        child: Icon(Icons.add),
                                      ),
                                    );
                                  } else {
                                    // 나머지 요소들은 기존 로직을 따름
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              key: ValueKey('answerLeft$index'),
                                              controller:
                                                  _controllersLeft[index],
                                              decoration: InputDecoration(
                                                hintText:
                                                    Intl.message("Answer") +
                                                        ' ${index + 1}',
                                                hintStyle: TextStyle(
                                                    color: quizLayout
                                                        .getColorScheme()
                                                        .primary), // 힌트 텍스트 색상
                                              ),
                                              style: TextStyle(
                                                  color: quizLayout
                                                      .getColorScheme()
                                                      .primary),
                                              onChanged: (value) {
                                                widget.quiz
                                                    .setAnswerAt(index, value);
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: AppConfig.screenWidth * 0.5,
                                            child: GestureDetector(
                                              key: ValueKey('dragline$index'),
                                              behavior: HitTestBehavior.opaque,
                                              onPanStart: (details) {
                                                setState(() {
                                                  isDragging[index] = true;
                                                  Offset position =
                                                      leftDotLinePaintLocal[
                                                          index];
                                                  starts[index] =
                                                      position; // 드래그 시작 시 시작점 업데이트
                                                });
                                              },
                                              onPanUpdate: (details) {
                                                if (isDragging[index] == false)
                                                  return;
                                                setState(() {
                                                  ends[index] = details
                                                      .localPosition; // 드래그하는 동안 끝점 업데이트
                                                });
                                              },
                                              onPanEnd: (details) {
                                                if (isDragging[index] == false)
                                                  return;
                                                setState(() {
                                                  for (var key in rightKeys) {
                                                    Offset globalPosition =
                                                        rightDotGlobal[rightKeys
                                                            .indexOf(key)];
                                                    double distance =
                                                        (globalPosition -
                                                                details
                                                                    .globalPosition)
                                                            .distance;
                                                    if (distance <= 40) {
                                                      RenderBox linePaint = lineKeys[
                                                                  index]
                                                              .currentContext!
                                                              .findRenderObject()
                                                          as RenderBox;
                                                      Offset position = linePaint
                                                          .globalToLocal(
                                                              globalPosition);
                                                      ends[index] = position;
                                                      widget.quiz
                                                          .setConnectionAnswerIndexAt(
                                                              index,
                                                              rightKeys.indexOf(
                                                                  key));
                                                      break;
                                                    } else {
                                                      ends[index] = null;
                                                    }
                                                  }

                                                  // 드래그 종료 후 필요한 작업 수행
                                                  isDragging[index] = false;
                                                });
                                              },
                                              child: IgnorePointer(
                                                ignoring: true,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: AppConfig
                                                          .largePadding),
                                                  child: CustomPaint(
                                                    key: lineKeys[index],
                                                    painter: starts[index] !=
                                                                null &&
                                                            ends[index] != null
                                                        ? LinePainter(
                                                            start:
                                                                starts[index]!,
                                                            end: ends[index]!,
                                                            color: quizLayout
                                                                .getColorScheme()
                                                                .primary)
                                                        : null,
                                                    child: Container(
                                                      height: 100.0,
                                                      child: Row(
                                                        key: ValueKey(
                                                            'dots$index'),
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            key:
                                                                leftKeys[index],
                                                            height: 15.0,
                                                            width: 15.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: quizLayout
                                                                  .getColorScheme()
                                                                  .primary,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                          Container(
                                                            key: rightKeys[
                                                                index],
                                                            height: 15.0,
                                                            width: 15.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: quizLayout
                                                                  .getColorScheme()
                                                                  .primary,
                                                              shape: BoxShape
                                                                  .circle,
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
                                          Expanded(
                                            child: TextField(
                                              key:
                                                  ValueKey('answerRight$index'),
                                              controller:
                                                  _controllersRight[index],
                                              decoration: InputDecoration(
                                                hintText:
                                                    Intl.message("Answer") +
                                                        ' ${index + 1}',
                                              ),
                                              onChanged: (value) {
                                                widget.quiz
                                                    .setConnectionAnswerAt(
                                                        index, value);
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            key: ValueKey(
                                                'removeAnswerButton$index'),
                                            icon: Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () {
                                              setState(() {
                                                if (widget
                                                        .quiz.answers.length ==
                                                    2) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        Intl.message(
                                                            "At_least_2_answers_are_required"),
                                                      ),
                                                      duration:
                                                          Duration(seconds: 1),
                                                    ),
                                                  );
                                                } else {
                                                  updateEnds(index);
                                                  widget.quiz.removeAnswerPairAt(
                                                      index); // 퀴즈에서 해당 답변 제거
                                                  _controllersLeft.removeAt(
                                                      index); // 왼쪽 컨트롤러 리스트에서 제거
                                                  _controllersRight.removeAt(
                                                      index); // 오른쪽 컨트롤러 리스트에서 제거
                                                  starts.removeAt(index);
                                                  ends.removeAt(index);
                                                  isDragging.removeAt(index);
                                                  leftKeys.removeAt(index);
                                                  rightKeys.removeAt(index);
                                                  lineKeys.removeAt(index);
                                                  needUpdate = true;
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setOffsets();
                                                  });
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppConfig.padding, // Adjust the position as needed
                    bottom: AppConfig.padding, // Adjust the position as needed
                    child: GeneratorDoneButton(
                      onPressed: () {
                        Navigator.pop(context, widget.quiz);
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

  void updateEnds(int deletedIndex) {
    List<int?> connectionAnswerIndex = widget.quiz.getConnectionAnswerIndex();
    for (int i = 0; i < connectionAnswerIndex.length; i++) {
      if (connectionAnswerIndex[i] == null) {
        continue;
      }
      int index = connectionAnswerIndex[i]!;
      if (deletedIndex < index && i < deletedIndex) {
        int newIndex = index - 1;
        RenderBox rightDot =
            rightKeys[newIndex].currentContext!.findRenderObject() as RenderBox;
        RenderBox linePaint =
            lineKeys[i].currentContext!.findRenderObject() as RenderBox;
        Offset GlobalPosition = rightDot.localToGlobal(Offset.zero);
        GlobalPosition = Offset(GlobalPosition.dx + rightDot.size.width / 2,
            GlobalPosition.dy + rightDot.size.height / 2);
        ends[i] = linePaint.globalToLocal(GlobalPosition);
      } else if (deletedIndex > index && i > deletedIndex) {
        int newIndex = index + 1;
        RenderBox rightDot =
            rightKeys[newIndex].currentContext!.findRenderObject() as RenderBox;
        RenderBox linePaint =
            lineKeys[i].currentContext!.findRenderObject() as RenderBox;
        Offset GlobalPosition = rightDot.localToGlobal(Offset.zero);
        GlobalPosition = Offset(GlobalPosition.dx + rightDot.size.width / 2,
            GlobalPosition.dy + rightDot.size.height / 2);
        ends[i] = linePaint.globalToLocal(GlobalPosition);
      } else if (deletedIndex == index) {
        ends[i] = null;
      }
    }
  }
}
