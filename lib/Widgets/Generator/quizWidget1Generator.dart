import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/customScrollPhysic.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Widgets/quizBodyTextImageYoutube.dart';
import 'package:quizzer/Setup/config.dart';

class QuizWidget1 extends StatefulWidget {
  final QuizLayout quizLayout;
  final Quiz1 quiz;
  QuizWidget1({Key? key, required this.quiz, required this.quizLayout})
      : super(key: key);
  @override
  _QuizWidget1State createState() => _QuizWidget1State();
}

class _QuizWidget1State extends State<QuizWidget1> {
  late TextEditingController questionController;
  late List<TextEditingController> _controllers;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.quiz.getQuestion());
    _controllers = widget.quiz.answers
        .map((answer) => TextEditingController(text: answer))
        .toList();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> answers = widget.quiz.getAnswers();
    print(answers);
    int trueCount = widget.quiz.getAnsLength();
    bool shuffleAnswers = widget.quiz.getShuffleAnswers();
    int maxAnswerSelection = widget.quiz.getMaxAnswerSelection();
    TextEditingController controller =
        TextEditingController(text: maxAnswerSelection.toString());
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
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        questionInputTextField(
                          controller: questionController,
                          onChanged: (value) {
                            widget.quiz.setQuestion(value);
                          },
                          quizLayout: widget.quizLayout,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              SizedBox(height: AppConfig.screenHeight * 0.02),
                              ContentWidget(
                                context: context,
                                updateStateCallback: (int value) {
                                  setState(() {
                                    widget.quiz.setBodyType(value);
                                  });
                                },
                                updateBodyTextCallback: (String value) {
                                  setState(() {
                                    widget.quiz.setBodyText(value);
                                  });
                                },
                                quiz1: widget.quiz,
                                quizLayout: widget.quizLayout,
                              ),
                              SizedBox(height: AppConfig.screenHeight * 0.02),
                              ...List.generate(answers.length + 1, (index) {
                                if (index == answers.length) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                          height:
                                              AppConfig.screenHeight * 0.02),
                                      ElevatedButton(
                                        child: Text(
                                          '정답 추가.',
                                          style: TextStyle(
                                            fontSize: AppConfig.fontSize,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            widget.quiz.addAnswer('');
                                            _controllers.add(
                                                TextEditingController(
                                                    text: ''));
                                          });
                                        },
                                      ),
                                      SizedBox(
                                          height:
                                              AppConfig.screenHeight * 0.02),
                                    ],
                                  );
                                } else {
                                  return ListTile(
                                    leading: Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          checkColor: WidgetStateProperty.all(
                                              Colors.white), // 체크 표시 색상
                                          fillColor: WidgetStateProperty.all(widget
                                              .quizLayout
                                              .getSelectedColor()), // 박스 배경 색상
                                        ),
                                      ),
                                      child: Checkbox(
                                        value: widget.quiz.isCorrectAns(index),
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            if (newValue != null) {
                                              if (trueCount <
                                                      widget.quiz
                                                          .getMaxAnswerSelection() ||
                                                  newValue == false) {
                                                widget.quiz.changeCorrectAns(
                                                    index, newValue);
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    title: TextField(
                                      style: TextStyle(
                                        fontSize: AppConfig.fontSize,
                                        color: widget.quizLayout.getTextColor(),
                                        fontFamily:
                                            widget.quizLayout.getAnswerFont(),
                                      ),
                                      controller: _controllers[index],
                                      onChanged: (value) {
                                        setState(() {
                                          widget.quiz.setAnswer(index, value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Answer ${index + 1}',
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          widget.quiz.removeAnswerAt(index);
                                          _controllers.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                }
                              }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('정답 섞기 여부 : '),
                                  Checkbox(
                                    value: shuffleAnswers,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        if (newValue != null) {
                                          widget.quiz
                                              .setShuffleAnswers(newValue);
                                        }
                                      });
                                    },
                                  ),
                                  Text('선택 가능한 정답 수 : '),
                                  Container(
                                    width: 50.0,
                                    child: TextField(
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ], // Only numbers can be entered
                                      onChanged: (value) {
                                        setState(() {
                                          widget.quiz.setMaxAnswerSelection(
                                              int.tryParse(value) ??
                                                  maxAnswerSelection);
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppConfig.padding * 6,
                              ),
                            ],
                          )),
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
}
