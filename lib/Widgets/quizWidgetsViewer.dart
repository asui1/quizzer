import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz1.dart';

double fontSizeBase = 10.0;

class QuizPage extends StatefulWidget {
  final int quizTag; // 퀴즈 태그

  QuizPage({Key? key, required this.quizTag}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Quiz1 quizData = Quiz1(
    answers: [],
    ans: [],
    question: '',
  );
  Quiz1 quizTest = Quiz1(
    answers: ['11', '22', '33', '44', '55'],
    ans: [true, false, false, false, false],
    question: "11을 고르세요.",
    bodyType: 1,
    bodyText: "본문입니다.",
    shuffleAnswers: true,
    maxAnswerSelection: 1,
  );
  bool isLoading = true;
  List<int> order = [];
  List<bool> currentAnswer = [];

  @override
  void initState() {
    super.initState();
    loadQuiz();
    order = List<int>.generate(quizTest.answers.length, (index) => index);
    if (quizTest.getShuffleAnswers()) {
      order.shuffle();
    }
    currentAnswer =
        List<bool>.generate(quizTest.answers.length, (index) => false);
  }

  void loadQuiz() async {
    try {
      await quizData.loadQuiz(widget.quizTag); // 퀴즈 로드
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("퀴즈 로드 실패: $e");
      // 에러 처리 로직 추가
    }
  }

  @override
  Widget build(BuildContext context) {
    int trueCount = currentAnswer.where((answer) => answer == true).length;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            quizTest.getQuestion(),
            style: TextStyle(
              fontSize: fontSizeBase * 3,
            ),
          ),
          _buildQuizBody(quizTest),
          Expanded(
            child: ListView.builder(
                itemCount: quizTest.getAnswers().length,
                itemBuilder: (context, index) {
                  int newIndex = order[index];
                  return ListTile(
                    leading: Checkbox(
                      value: currentAnswer[newIndex],
                      onChanged: (bool? newValue) {
                        setState(() {
                          if (newValue != null) {
                            if (trueCount < quizTest.getMaxAnswerSelection() ||
                                newValue == false) {
                              currentAnswer[newIndex] = newValue;
                            }
                          }
                        });
                      },
                    ),
                    title: Text(quizTest.getAnswerAt(order[newIndex])),
                    onTap: () {
                      setState(() {
                        if (currentAnswer[newIndex] == false) {
                          if(trueCount < quizTest.getMaxAnswerSelection()){
                          currentAnswer[newIndex] = !currentAnswer[newIndex];
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
    );
  }
}

Widget _buildQuizBody(Quiz1 quiz) {
  switch (quiz.getBodyType()) {
    case 0:
      return Container();
    case 1:
      return Container(
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
            fontSize: fontSizeBase * 2,
          ),
        ),
      );
    case 2:
      return Image.asset(
        quiz.getImageFile().path,
        fit: BoxFit.cover,
      );
    default:
      return Container();
  }
}
