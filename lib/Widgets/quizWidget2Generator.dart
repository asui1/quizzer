import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Widgets/dateChooser.dart';
import 'package:table_calendar/table_calendar.dart';

class QuizWidget2 extends StatefulWidget {
  @override
  _QuizWidget2State createState() => _QuizWidget2State();
}

class _QuizWidget2State extends State<QuizWidget2> {
  Quiz2 quiz = Quiz2(
    answers: ['', '', '', '', ''],
    ans: [false, false, false, false, false],
    question: '',
  );
  late TextEditingController questionController;
  late DateTime curFocus;
  late TextEditingController yearController;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: quiz.getQuestion());
    yearController =
        TextEditingController(text: quiz.getYearRange().toString());
  }
  //TODO: 선택한 날을 중심으로 몇 년씩 필요한지.
  //TODO: 정답인 날들의 목록.

  @override
  Widget build(BuildContext context) {
    int maxAnswerSelection = quiz.getMaxAnswerSelection();
    TextEditingController controller =
        TextEditingController(text: maxAnswerSelection.toString());
    curFocus = DateTime(quiz.getCenterDate()[0], quiz.getCenterDate()[1],
        quiz.getCenterDate()[2]);
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
          Container(
            height: 450.0,
            child: TableCalendar(
              firstDay: DateTime.utc(-2000, 1, 1),
              lastDay: DateTime.utc(9999, 12, 31),
              focusedDay: curFocus,
            ),
          ),
          //시작 날짜 ~ 끝나는 날 설정하도록 하기
          Text("중심 날짜를 선택하세요."),

          buildDatePicker(context, quiz, (List<int> date) {
            setState(() {
              quiz.setCenterDate(date);
            });
          }),
          SizedBox(height: 20.0),
          Container(
            width: 100, // Adjust the width as needed
            child: TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                int? yearValue = int.tryParse(value);
                if (yearValue != null) {
                  setState(() {
                    quiz.setYearRange(yearValue);
                  });
                } else {}
              },
              decoration: InputDecoration(
                labelText: '년도 범위',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          

          //정답 날짜 설정

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
      ),
    );
  }
}
