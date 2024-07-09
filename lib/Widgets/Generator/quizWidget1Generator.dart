import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
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
  late TextEditingController controller;
  final FocusNode _maxAnswerFocusNode = FocusNode();
  late List<FocusNode> _focusNodes;
  FocusNode? _prevFocusNode = null;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.quiz.getQuestion());
    _controllers = widget.quiz.answers
        .map((answer) => TextEditingController(text: answer))
        .toList();
    _scrollController = ScrollController();
    controller = TextEditingController(
        text: widget.quiz.getMaxAnswerSelection().toString());
    _focusNodes =
        List.generate(widget.quiz.getAnswers().length, (index) => FocusNode());
    for (int i = 0; i < _focusNodes.length; i++) {
      FocusNode currentFocusNode = _focusNodes[i];
      currentFocusNode.addListener(() {
        if (currentFocusNode.hasFocus) {
          if (_prevFocusNode != null && _prevFocusNode != currentFocusNode) {
            currentFocusNode.unfocus();
            _prevFocusNode = null;
            Future.delayed(Duration(milliseconds: 20), () {
              FocusScope.of(context).requestFocus(currentFocusNode);
            });
          }
          _prevFocusNode = null;
          // Temporarily unfocus and then refocus after a short delay
        }
      });
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    controller.dispose();
    _scrollController.dispose();
    _maxAnswerFocusNode.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> answers = widget.quiz.getAnswers();
    int trueCount = widget.quiz.getAnsLength();
    bool shuffleAnswers = widget.quiz.getShuffleAnswers();
    int maxAnswerSelection = widget.quiz.getMaxAnswerSelection();
    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _prevFocusNode = null;
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
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: AppConfig.screenHeight * 0.02),
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
                                  SizedBox(
                                      height: AppConfig.screenHeight * 0.02),
                                  ...List.generate(answers.length + 1, (index) {
                                    if (index == answers.length) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                              height: AppConfig.screenHeight *
                                                  0.02),
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
                                                FocusNode newNode = FocusNode();
                                                newNode.addListener(() {
                                                  if (newNode
                                                      .hasFocus) {
                                                    if (_prevFocusNode !=
                                                            null &&
                                                        _prevFocusNode !=
                                                            newNode) {
                                                      newNode
                                                          .unfocus();
                                                      _prevFocusNode = null;
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds: 20),
                                                          () {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                newNode);
                                                      });
                                                    }
                                                    _prevFocusNode = null;
                                                    // Temporarily unfocus and then refocus after a short delay
                                                  }
                                                });
                                                _focusNodes.add(newNode);
                                                _controllers.add(
                                                    TextEditingController(
                                                        text: ''));
                                              });
                                            },
                                          ),
                                          SizedBox(
                                              height: AppConfig.screenHeight *
                                                  0.02),
                                        ],
                                      );
                                    } else {
                                      return ListTile(
                                        leading: Checkbox(
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary, // 체크박스 활성화 색상을 테마의 주 색상으로 설정
                                          checkColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary, // 체크 표시 색상을 테마의 onPrimary 색상으로 설정
                                          value:
                                              widget.quiz.isCorrectAns(index),
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
                                        title: TextField(
                                          focusNode: _focusNodes[index],
                                          textInputAction:
                                              index == answers.length - 1
                                                  ? TextInputAction.done
                                                  : TextInputAction.next,
                                          onSubmitted: (_) {
                                            // Step 4: Move focus on submission
                                            if (index < answers.length - 1) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _focusNodes[index + 1]);
                                            } else {
                                              _focusNodes[index].unfocus();
                                            }
                                          },
                                          style: TextStyle(
                                            fontSize: AppConfig.fontSize,
                                            fontFamily: widget.quizLayout
                                                .getAnswerFont(),
                                          ),
                                          controller: _controllers[index],
                                          onChanged: (value) {
                                            setState(() {
                                              widget.quiz
                                                  .setAnswer(index, value);
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Answer ${index + 1}',
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary, // 아이콘 색상을 테마의 보조 색상으로 설정
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              widget.quiz.removeAnswerAt(index);
                                              _controllers.removeAt(index);
                                              _focusNodes.removeAt(index);
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
                                          focusNode: _maxAnswerFocusNode,
                                          controller: controller,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
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
