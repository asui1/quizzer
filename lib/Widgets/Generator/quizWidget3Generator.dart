import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

class QuizWidget3 extends StatefulWidget {
  final QuizLayout quizLayout;
  final Quiz3 quiz;
  QuizWidget3({Key? key, required this.quiz, required this.quizLayout})
      : super(key: key);

  @override
  _QuizWidget3State createState() => _QuizWidget3State();
}

class _QuizWidget3State extends State<QuizWidget3> {
  late TextEditingController questionController;
  List<TextEditingController> _controllers = [];
  late List<FocusNode> _focusNodes;
  FocusNode? _prevFocusNode = null;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.quiz.getQuestion());
    _initControllers();
    _focusNodes =
        List.generate(widget.quiz.getAnswers().length, (index) => FocusNode());
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          if (_prevFocusNode != null && _prevFocusNode != _focusNodes[i]) {
            _focusNodes[i].unfocus();
            _prevFocusNode = _focusNodes[i];
            Future.delayed(Duration(milliseconds: 20), () {
              FocusScope.of(context).requestFocus(_focusNodes[i]);
            });
          }
          _prevFocusNode = _focusNodes[i];
          // Temporarily unfocus and then refocus after a short delay
        }
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    questionController.dispose();
    super.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
  }

  void _initControllers() {
    _controllers = widget.quiz
        .getAnswers()
        .map((answer) => TextEditingController(text: answer))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: GestureDetector(
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
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  for (int index = 0;
                                      index < widget.quiz.getAnswersLength();
                                      index++) ...[
                                    Row(
                                      children: [
                                        SizedBox(height: AppConfig.padding),
                                        Expanded(
                                          child: TextField(
                                              focusNode: _focusNodes[index],
                                              textInputAction: index ==
                                                      widget.quiz
                                                              .getAnswersLength() -
                                                          1
                                                  ? TextInputAction.done
                                                  : TextInputAction.next,
                                              onSubmitted: (_) {
                                                // Step 4: Move focus on submission
                                                if (index <
                                                    widget.quiz
                                                            .getAnswersLength() -
                                                        1) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_focusNodes[
                                                          index + 1]);
                                                } else {
                                                  _focusNodes[index].unfocus();
                                                }
                                              },
                                              key: ValueKey(
                                                  index), // TextField에 대한 Key
                                              controller: _controllers[index],
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  // 활성화되지 않았을 때의 테두리 스타일
                                                  borderSide: BorderSide(
                                                    width: 2.0, // 테두리 두께 변경
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // 테두리 모서리 둥글기 변경
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  // 포커스를 받았을 때의 테두리 스타일
                                                  borderSide: BorderSide(
                                                    width: 2.5, // 테두리 두께 변경
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // 테두리 모서리 둥글기 변경
                                                ),
                                                hintText: '답변 ${index + 1}',
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  widget.quiz.setAnswerAt(
                                                      index, value);
                                                });
                                              },
                                              style: widget.quizLayout
                                                  .getAnswerTextStyle()),
                                        ),
                                        IconButton(
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                            setState(() {
                                              widget.quiz.removeAnswerAt(index);
                                              _controllers.removeAt(
                                                  index); // 컨트롤러 리스트에서도 해당 항목 제거
                                              _focusNodes.removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    if (index <
                                        widget.quiz.answers.length -
                                            1) // 마지막 TextField 다음에는 아이콘을 추가하지 않음
                                      IgnorePointer(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.arrow_downward,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                  SizedBox(height: 20.0),
                                  ElevatedButton(
                                    child: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        widget.quiz.addAnswer('');
                                        _controllers
                                            .add(TextEditingController());
                                        FocusNode newNode = FocusNode();
                                        newNode.addListener(() {
                                          if (newNode.hasFocus) {
                                            if (_prevFocusNode != null &&
                                                _prevFocusNode != newNode) {
                                              newNode.unfocus();
                                              _prevFocusNode = null;
                                              Future.delayed(
                                                  Duration(milliseconds: 20),
                                                  () {
                                                FocusScope.of(context)
                                                    .requestFocus(newNode);
                                              });
                                            }
                                            _prevFocusNode = null;
                                            // Temporarily unfocus and then refocus after a short delay
                                          }
                                        });
                                        _focusNodes.add(newNode);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: AppConfig.padding * 6,
                                  ),
                                ],
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
}
