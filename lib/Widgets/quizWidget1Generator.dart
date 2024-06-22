import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Widgets/quizBodyTextImageYoutube.dart';

class QuizWidget1 extends StatefulWidget {
  @override
  _QuizWidget1State createState() => _QuizWidget1State();
}

class _QuizWidget1State extends State<QuizWidget1> {
  Quiz1 quiz = Quiz1(
      answers: ['', '', '', '', ''],
      ans: [false, false, false, false, false],
      question: '');
  late TextEditingController questionController;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: quiz.getQuestion());
    _controllers = quiz.answers
        .map((answer) => TextEditingController(text: answer))
        .toList();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> answers = quiz.getAnswers();
    int trueCount = quiz.getAnsLength();
    bool shuffleAnswers = quiz.getShuffleAnswers();
    int maxAnswerSelection = quiz.getMaxAnswerSelection();
    TextEditingController controller =
        TextEditingController(text: maxAnswerSelection.toString());
    return Column(
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
        ContentWidget(
          context: context,
          updateStateCallback: (int value) {
            setState(() {
              quiz.setBodyType(value);
            });
          },
          quiz1: quiz,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: answers.length + 1,
            itemBuilder: (context, index) {
              if (index == answers.length) {
                return Column(
                  children: [
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text('정답 추가.'),
                      onPressed: () {
                        setState(() {
                          quiz.addAnswer('');
                          _controllers.add(TextEditingController(text: ''));
                        });
                      },
                    ),
                    // Add this line
                  ],
                );
              } else {
                return ListTile(
                  leading: Checkbox(
                    value: quiz.isCorrectAns(index),
                    onChanged: (bool? newValue) {
                      setState(() {
                        if (newValue != null) {
                          if (trueCount < maxAnswerSelection ||
                              newValue == false) {
                            quiz.changeCorrectAns(index, newValue);
                          }
                        }
                      });
                    },
                  ),
                  title: TextField(
                    controller: _controllers[index],
                    onChanged: (value) {
                      setState(() {
                        quiz.setAnswer(index, value);
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
                        quiz.removeAnswerAt(index);
                        _controllers.removeAt(index);
                      });
                    },
                  ),
                );
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('정답 섞기 여부 : '),
            Checkbox(
              value: shuffleAnswers,
              onChanged: (bool? newValue) {
                setState(() {
                  if (newValue != null) {
                    quiz.setShuffleAnswers(newValue);
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
                    quiz.setMaxAnswerSelection(
                        int.tryParse(value) ?? maxAnswerSelection);
                  });
                },
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            child: Text('완료'),
            onPressed: () {
              quiz.saveQuiz(9999);
              Navigator.pop(context);
              },
          ),
        ),
      ],
    );
  }
}
