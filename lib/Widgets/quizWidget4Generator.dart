import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Widgets/LinePainter.dart';

class QuizWidget4 extends StatefulWidget {
  @override
  _QuizWidget4State createState() => _QuizWidget4State();
}

class _QuizWidget4State extends State<QuizWidget4> {
  Quiz4 quiz = Quiz4(
    answers: ['', ''],
    ans: [],
    question: '',
    maxAnswerSelection: 1,
    connectionAnswers: ['', ''],
  );
  late TextEditingController questionController;
  List<TextEditingController> _controllersLeft = [];
  List<TextEditingController> _controllersRight = [];
  List<Offset?> starts = [null, null];
  List<Offset?> ends = [null, null];
  List<bool> isDragging = [false, false];
  List<GlobalKey> leftKeys = [GlobalKey(), GlobalKey()];
  List<GlobalKey> rightKeys = [GlobalKey(), GlobalKey()];
  List<GlobalKey> lineKeys = [GlobalKey(), GlobalKey()];

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: quiz.getQuestion());
    _initControllers();
  }

  @override
  void dispose() {
    _controllersLeft.forEach((controller) => controller.dispose());
    _controllersRight.forEach((controller) => controller.dispose());
    questionController.dispose();

    super.dispose();
  }

  void _initControllers() {
    _controllersLeft = quiz
        .getAnswers()
        .map((answer) => TextEditingController(text: answer))
        .toList();
    _controllersRight = quiz
        .getConnectionAnswers()
        .map((answer) => TextEditingController(text: answer))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            controller: questionController,
            decoration: InputDecoration(
              hintText: '질문을 입력해주세요.',
            ),
            onChanged: (value) {
              quiz.setQuestion(value);
            },
          ),
          SizedBox(height: 20.0),
          Expanded(
            // ListView.builder를 Expanded로 감싸기
            child: ListView.builder(
              itemCount: quiz.getAnswers().length + 1, // 마지막 "+" 버튼을 위해 +1
              itemBuilder: (context, index) {
                if (index == quiz.getAnswers().length) {
                  // 마지막 요소인 경우 "+" 버튼을 표시
                  return Container(
                    alignment: Alignment.center,
                    width: 64.0,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          quiz.addAnswerPair();
                          _controllersLeft.add(TextEditingController());
                          _controllersRight.add(TextEditingController());
                          starts.add(null);
                          ends.add(null);
                        });
                      },
                      child: Icon(Icons.add),
                    ),
                  );
                } else {
                  // 나머지 요소들은 기존 로직을 따름
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controllersLeft[index],
                            decoration: InputDecoration(
                              hintText: '답변 ${index + 1}',
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GestureDetector(
                            onPanStart: (details) {
                              setState(() {
                                if (isDragging[index] == true) {
                                  RenderBox leftDot = leftKeys[index]
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  RenderBox linePaint = lineKeys[index]
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  Offset GlobalPosition =
                                      leftDot.localToGlobal(Offset.zero);
                                  GlobalPosition = Offset(
                                      GlobalPosition.dx +
                                          leftDot.size.width / 2,
                                      GlobalPosition.dy +
                                          leftDot.size.height / 2);
                                  Offset position =
                                      linePaint.globalToLocal(GlobalPosition);
                                  starts[index] = position; // 드래그 시작 시 시작점 업데이트
                                  ends[index] = position;
                                }
                              });
                            },
                            onPanUpdate: (details) {
                              if (isDragging[index] == false) return;
                              setState(() {
                                ends[index] =
                                    details.localPosition; // 드래그하는 동안 끝점 업데이트
                              });
                            },
                            onPanEnd: (details) {
                              if (isDragging[index] == false) return;
                              setState(() {
                                for (var key in rightKeys) {
                                  RenderBox rightDot = key.currentContext!
                                      .findRenderObject() as RenderBox;
                                  Offset GlobalPosition =
                                      rightDot.localToGlobal(Offset.zero);
                                  GlobalPosition = Offset(
                                      GlobalPosition.dx +
                                          rightDot.size.width / 2,
                                      GlobalPosition.dy +
                                          rightDot.size.height / 2);
                                  double distance = (GlobalPosition -
                                          details.globalPosition)
                                      .distance;
                                  print(distance);
                                  if (distance <= 10) {
                                    print("connected");
                                    RenderBox linePaint = lineKeys[index]
                                        .currentContext!
                                        .findRenderObject() as RenderBox;
                                    Offset position =
                                        linePaint.globalToLocal(GlobalPosition);
                                    ends[index] = position;
                                    break;
                                  }
                                  else{
                                    ends[index] = null;
                                  }
                                }

                                // 드래그 종료 후 필요한 작업 수행
                                isDragging[index] = false;
                              });
                            },
                            child: CustomPaint(
                              key: lineKeys[index],
                              painter:
                                  starts[index] != null && ends[index] != null
                                      ? LinePainter(
                                          start: starts[index]!,
                                          end: ends[index]!)
                                      : null,
                              child: Container(
                                height: 100.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTapDown: (TapDownDetails details) {
                                        isDragging[index] = true;
                                      },
                                      child: Container(
                                        key: leftKeys[index],
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      key: rightKeys[index],
                                      height: 10.0,
                                      width: 10.0,
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
                          child: TextField(
                            controller: _controllersRight[index],
                            decoration: InputDecoration(
                              hintText: '연결된 답변 ${index + 1}',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              quiz.removeAnswerAt(index); // 퀴즈에서 해당 답변 제거
                              _controllersLeft
                                  .removeAt(index); // 왼쪽 컨트롤러 리스트에서 제거
                              _controllersRight
                                  .removeAt(index); // 오른쪽 컨트롤러 리스트에서 제거
                              starts.removeAt(index);
                              ends.removeAt(index);
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                child: Text('완료'),
                onPressed: () {
                  quiz.saveQuiz(9999);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
