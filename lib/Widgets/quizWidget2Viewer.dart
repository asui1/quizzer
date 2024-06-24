import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:table_calendar/table_calendar.dart';

double fontSizeBase = 10.0;

class QuizView2 extends StatefulWidget {
  final int quizTag; // 퀴즈 태그

  QuizView2({Key? key, required this.quizTag}) : super(key: key);

  @override
  _QuizView2State createState() => _QuizView2State();
}

class _QuizView2State extends State<QuizView2> {
  Quiz2 quizData = Quiz2(
    answers: [],
    ans: [],
    question: '',
    maxAnswerSelection: 1,
  );
  Quiz2 quizTest = Quiz2(
    answers: ['11', '22', '33', '44', '55'],
    ans: [true, false, false, false, false],
    question: "11을 고르세요.",
    maxAnswerSelection: 1,
  );
  bool isLoading = true;
  List<int> order = [];
  List<bool> currentAnswer = [];
  late DateTime curFocus;
  List<DateTime> highlightedDates = [];

  @override
  void initState() {
    super.initState();
    loadQuiz();
    quizTest.setCenterDate([2024, 6, 22]);
    quizTest.setYearRange(10);
    quizTest.setAnswerDate([
      [2024, 6, 22],
      [2024, 6, 20]
    ]);
    curFocus = DateTime(quizTest.getCenterDate()[0],
        quizTest.getCenterDate()[1], quizTest.getCenterDate()[2]);
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
          Container(
            height: 450.0,
            child: TableCalendar(
              firstDay: DateTime.utc(
                  quizTest.getCenterDate()[0] - quizTest.getYearRange(), 1, 1),
              lastDay: DateTime.utc(
                  quizTest.getCenterDate()[0] + quizTest.getYearRange(),
                  12,
                  31),
              focusedDay: curFocus,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onPageChanged: (focusedDay) {
                // 사용자가 달력의 페이지를 변경할 때 호출됩니다.
                // focusedDay는 새로운 포커스된 날짜입니다.
                setState(() {
                  curFocus = focusedDay; // curFocus 변수를 새로운 포커스된 날짜로 업데이트합니다.
                });
              },
              calendarFormat:
                  CalendarFormat.month, // Set your desired format here
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  // Check if the day is already highlighted
                  final existingIndex = highlightedDates
                      .indexWhere((day) => isSameDay(day, selectedDay));
                  if (existingIndex >= 0) {
                    // If it is, remove it from the list
                    highlightedDates.removeAt(existingIndex);
                  } else {
                    // If it's not, add it, respecting the maximum selectable limit
                    if (highlightedDates.length <
                        quizTest.getMaxAnswerSelection()) {
                      highlightedDates.add(selectedDay);
                    }
                  }
                  curFocus = focusedDay; // Update the focused day
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  bool isHighlighted = highlightedDates.any((highlightedDate) =>
                      day.year == highlightedDate.year &&
                      day.month == highlightedDate.month &&
                      day.day == highlightedDate.day);

                  // If it is highlighted, customize its appearance
                  if (isHighlighted) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.purple[100], // Highlight color
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                      ),
                    );
                  }

                  // Return null for default appearance on non-highlighted days
                  return null;
                },
                todayBuilder: (context, day, focusedDay) {
                  // Customizing today's appearance to look like a regular day
                  return Container(
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                            color: Colors
                                .black), // Making text color similar to other days
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
