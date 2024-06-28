import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/config.dart';

class QuizView1 extends StatefulWidget {
  final int quizTag; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView1(
      {Key? key,
      required this.quizTag,
      this.screenHeightModifier = 1,
      this.screenWidthModifier = 1})
      : super(key: key);

  @override
  _QuizView1State createState() => _QuizView1State();
}

class _QuizView1State extends State<QuizView1> {
  Quiz1 quizData = Quiz1(
    answers: [],
    ans: [],
    question: '',
  );
  bool isLoading = true;
  List<int> order = [];
  List<bool> currentAnswer = [];
  late Future<void> _loadQuizFuture;

  @override
  void initState() {
    super.initState();
    _loadQuizFuture = loadQuiz();
  }

  Future<void> loadQuiz() async {
    try {
      await quizData.loadQuiz(widget.quizTag); // 퀴즈 로드
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("퀴즈 로드 실패: $e");
      quizData = Quiz1(
        answers: ['11', '22', '33', '44', '55'],
        ans: [true, false, false, false, false],
        question: "11을 고르세요.",
        bodyType: 1,
        bodyText: "본문입니다.",
        shuffleAnswers: true,
        maxAnswerSelection: 1,
      );
      // 에러 처리 로직 추가
    }
  }

  @override
  Widget build(BuildContext context) {
    int trueCount = currentAnswer.where((answer) => answer == true).length;

    return FutureBuilder(
      future: _loadQuizFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("퀴즈 로드에 실패했습니다."));
          }
          if (order.length == 0) {
            order =
                List<int>.generate(quizData.answers.length, (index) => index);
            currentAnswer =
                List<bool>.generate(quizData.answers.length, (index) => false);
            if (quizData.getShuffleAnswers()) {
              order.shuffle();
            }
          }
          // Future가 완료되면 UI 빌드
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(AppConfig.padding),
              child: Column(
                children: <Widget>[
                  QuestionViewer(question: quizData.getQuestion(), fontSizeModifier: widget.screenWidthModifier),
                  SizedBox(height: AppConfig.screenHeight * 0.02 * widget.screenHeightModifier),
                  _buildQuizBody(quizData, widget.screenWidthModifier),
                  SizedBox(height: AppConfig.screenHeight * 0.02 * widget.screenHeightModifier),
                  Expanded(
                    child: ListView.builder(
                        itemCount: quizData.getAnswers().length,
                        itemBuilder: (context, index) {
                          int newIndex = order[index];
                          return ListTile(
                            leading: Checkbox(
                              value: currentAnswer[newIndex],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    if (trueCount <
                                            quizData.getMaxAnswerSelection() ||
                                        newValue == false) {
                                      currentAnswer[newIndex] = newValue;
                                    }
                                  }
                                });
                              },
                            ),
                            title: Text(
                              quizData.getAnswerAt(order[newIndex]),
                              style: TextStyle(fontSize: AppConfig.fontSize * widget.screenWidthModifier),
                            ),
                            onTap: () {
                              setState(() {
                                if (currentAnswer[newIndex] == false) {
                                  if (trueCount <
                                      quizData.getMaxAnswerSelection()) {
                                    currentAnswer[newIndex] =
                                        !currentAnswer[newIndex];
                                  }
                                } else {
                                  currentAnswer[newIndex] =
                                      !currentAnswer[newIndex];
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
        } else {
          // 로딩 중 UI
          return Center(child: CircularProgressIndicator());
        }
      },
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
