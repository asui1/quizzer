import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/LinePainter.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/config.dart';

class QuizWidget4 extends StatefulWidget {
  final QuizLayout quizLayout;
  final Quiz4 quiz;
  QuizWidget4({Key? key, required this.quiz, required this.quizLayout})
      : super(key: key);
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
      starts.add(null);
      ends.add(null);
      isDragging.add(false);
      leftKeys.add(GlobalKey());
      rightKeys.add(GlobalKey());
      lineKeys.add(GlobalKey());
    }
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: AppConfig.screenHeight,
            width: AppConfig.screenWidth,
            decoration: backgroundDecoration(quizLayout: widget.quizLayout),
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
                          quizLayout: widget.quizLayout,
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
                                if (index == widget.quiz.getAnswers().length) {
                                  // 마지막 요소인 경우 "+" 버튼을 표시
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        bottom: AppConfig.padding * 6),
                                    width: 64.0,
                                    child: ElevatedButton(
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
                                          WidgetsBinding.instance!
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
                                            controller: _controllersLeft[index],
                                            decoration: InputDecoration(
                                              hintText: '답변 ${index + 1}',
                                            ),
                                            onChanged: (value) {
                                              widget.quiz
                                                  .setAnswerAt(index, value);
                                            },
                                            style: widget.quizLayout
                                                .getAnswerTextStyle(),
                                          ),
                                        ),
                                        Container(
                                          width: AppConfig.screenWidth * 0.5,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: GestureDetector(
                                            onTapDown: (details) {
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
                                                  if (distance <= 20) {
                                                    RenderBox linePaint =
                                                        lineKeys[index]
                                                                .currentContext!
                                                                .findRenderObject()
                                                            as RenderBox;
                                                    Offset position =
                                                        linePaint.globalToLocal(
                                                            globalPosition);
                                                    ends[index] = position;
                                                    widget.quiz
                                                        .setConnectionAnswerIndexAt(
                                                            index,
                                                            rightKeys
                                                                .indexOf(key));
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
                                                      end: ends[index]!,
                                                      color: widget.quizLayout
                                                          .getBorderColor1())
                                                  : null,
                                              child: Container(
                                                height: 100.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      key: leftKeys[index],
                                                      height: 15.0,
                                                      width: 15.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: widget.quizLayout
                                                            .getBorderColor1(),
                                                      ),
                                                    ),
                                                    Container(
                                                      key: rightKeys[index],
                                                      height: 15.0,
                                                      width: 15.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: widget.quizLayout
                                                            .getBorderColor1(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                _controllersRight[index],
                                            decoration: InputDecoration(
                                              hintText: '연결된 답변 ${index + 1}',
                                            ),
                                            onChanged: (value) {
                                              widget.quiz.setConnectionAnswerAt(
                                                  index, value);
                                            },
                                            style: widget.quizLayout
                                                .getAnswerTextStyle(),
                                          ),
                                        ),
                                        IconButton(
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                            setState(() {
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
                                              WidgetsBinding.instance!
                                                  .addPostFrameCallback((_) {
                                                setOffsets();
                                              });
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
    );
  }

  void updateEnds(int deletedIndex) {
    List<int?> connectionAnswerIndex = widget.quiz.getConnectionAnswerIndex();
    for (int i = 0; i < connectionAnswerIndex.length; i++) {
      if (connectionAnswerIndex[i] == null) {
        continue;
      }
      int index = connectionAnswerIndex[i]!;
      int newIndex;
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
