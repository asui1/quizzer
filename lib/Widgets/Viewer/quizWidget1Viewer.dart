import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/config.dart';

class QuizView1 extends StatefulWidget {
  final Quiz1 quiz; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView1(
      {Key? key,
      required this.quiz,
      this.screenHeightModifier = 1,
      this.screenWidthModifier = 1})
      : super(key: key);

  @override
  _QuizView1State createState() => _QuizView1State();
}

class _QuizView1State extends State<QuizView1> {
  bool isLoading = true;
  List<int> order = [];
  List<bool> currentAnswer = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int trueCount = currentAnswer.where((answer) => answer == true).length;

    if (order.length == 0) {
      order = List<int>.generate(widget.quiz.answers.length, (index) => index);
      currentAnswer =
          List<bool>.generate(widget.quiz.answers.length, (index) => false);
      if (widget.quiz.getShuffleAnswers()) {
        order.shuffle();
      }
    }
    // Future가 완료되면 UI 빌드
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppConfig.padding),
        child: Column(
          children: <Widget>[
            QuestionViewer(
                question: widget.quiz.getQuestion(),
                fontSizeModifier: widget.screenWidthModifier),
            SizedBox(
                height: AppConfig.screenHeight *
                    0.02 *
                    widget.screenHeightModifier),
            _buildQuizBody(widget.quiz, widget.screenWidthModifier),
            SizedBox(
                height: AppConfig.screenHeight *
                    0.02 *
                    widget.screenHeightModifier),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.quiz.getAnswers().length,
                  itemBuilder: (context, index) {
                    int newIndex = order[index];
                    return ListTile(
                      leading: Checkbox(
                        value: currentAnswer[newIndex],
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (newValue != null) {
                              if (trueCount <
                                      widget.quiz.getMaxAnswerSelection() ||
                                  newValue == false) {
                                currentAnswer[newIndex] = newValue;
                              }
                            }
                          });
                        },
                      ),
                      title: Text(
                        widget.quiz.getAnswerAt(order[newIndex]),
                        style: TextStyle(
                            fontSize: AppConfig.fontSize *
                                widget.screenWidthModifier),
                      ),
                      onTap: () {
                        setState(() {
                          if (currentAnswer[newIndex] == false) {
                            if (trueCount <
                                widget.quiz.getMaxAnswerSelection()) {
                              currentAnswer[newIndex] =
                                  !currentAnswer[newIndex];
                            }
                          } else {
                            currentAnswer[newIndex] = !currentAnswer[newIndex];
                          }
                        });
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildQuizBody(Quiz1 quiz, double screenWidthModifier) {
  switch (quiz.getBodyType()) {
    case 0:
      return Container();
    case 1:
      return Container(
        width: AppConfig.screenWidth * 0.8 * screenWidthModifier,
        padding: EdgeInsets.all(8.0), // Add padding around the text
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black), // Add black border around the container
          borderRadius:
              BorderRadius.circular(4.0), // Optional: Add rounded corners
        ),
        child: Text(
          quiz.getBodyText(),
          style: TextStyle(
            fontSize: AppConfig.fontSize * screenWidthModifier,
          ),
        ),
      );
    case 2:
      return Image.asset(
        height: AppConfig.screenHeight * 0.3 * screenWidthModifier,
        width: AppConfig.screenWidth * 0.8 * screenWidthModifier,
        quiz.getImageFile().path,
        fit: BoxFit.cover,
      );
    default:
      return Container();
  }
}
