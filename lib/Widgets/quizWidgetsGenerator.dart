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
  final questionController = TextEditingController();
  List<String> answers = ['', '', '', '', ''];
  List<bool> correctAnswers = <bool>[false, false, false, false, false];
  bool shuffleAnswers = false;
  int maxAnswerSelection = 1;
  int bodyWidget = 0;
  Quiz1 quiz = Quiz1();

  @override
  Widget build(BuildContext context) {
    int trueCount = correctAnswers.where((item) => item == true).length;
    TextEditingController controller =
        TextEditingController(text: maxAnswerSelection.toString());
    return Column(
      children: <Widget>[
        TextField(
          controller: questionController,
          decoration: InputDecoration(
            hintText: '질문을 입력해주세요.',
          ),
        ),
        SizedBox(height: 20.0),
        ContentWidget(
          context: context,
          input: bodyWidget,
          updateStateCallback: (int value) {
            setState(() {
              bodyWidget = value;
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
                          answers.add('');
                          correctAnswers.add(false);
                        });
                      },
                    ),
                    // Add this line
                  ],
                );
              } else {
                return ListTile(
                  leading: Checkbox(
                    value: correctAnswers[index],
                    onChanged: (bool? newValue) {
                      setState(() {
                        if (newValue != null) {
                          if (trueCount < maxAnswerSelection ||
                              newValue == false)
                            correctAnswers[index] = newValue;
                        }
                      });
                    },
                  ),
                  title: TextField(
                    onChanged: (value) {
                      setState(() {
                        answers[index] = value;
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
                        answers.removeAt(index);
                        correctAnswers.removeAt(index);
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
                    shuffleAnswers = newValue;
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
                    maxAnswerSelection =
                        int.tryParse(value) ?? maxAnswerSelection;
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
              // Handle 'done' action here
            },
          ),
        ),
      ],
    );
  }
}
