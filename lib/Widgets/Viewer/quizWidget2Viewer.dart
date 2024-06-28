import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/config.dart';
import 'package:table_calendar/table_calendar.dart';

double fontSizeBase = 10.0;

class QuizView2 extends StatefulWidget {
  final int quizTag; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView2(
      {Key? key,
      required this.quizTag,
      this.screenWidthModifier = 1,
      this.screenHeightModifier = 1})
      : super(key: key);

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
  bool isLoading = true;
  List<int> order = [];
  List<bool> currentAnswer = [];
  late DateTime curFocus;
  List<DateTime> highlightedDates = [];
  late Future<void> _loadQuizFuture;
  bool isFirstRun = true;

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
      quizData = Quiz2(
        answers: ['11', '22', '33', '44', '55'],
        ans: [true, false, false, false, false],
        question: "11을 고르세요.",
        maxAnswerSelection: 1,
        centerDate: [2024, 6, 22],
        yearRange: 10,
        answerDate: [
          [2024, 6, 22],
          [2024, 6, 20]
        ],
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
          if (isFirstRun) {
            isFirstRun = false;
            curFocus = DateTime(quizData.getCenterDate()[0],
                quizData.getCenterDate()[1], quizData.getCenterDate()[2]);
          }
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(AppConfig.padding),
              child: Column(
                children: <Widget>[
                  QuestionViewer(question: quizData.getQuestion(), fontSizeModifier: widget.screenWidthModifier,),
                  Container(
                    height: AppConfig.screenHeight * 0.5 * widget.screenHeightModifier,
                    width: AppConfig.screenWidth * 0.8 * widget.screenWidthModifier,
                    child: TableCalendar(
                      shouldFillViewport: true,
                      firstDay: DateTime.utc(
                          quizData.getCenterDate()[0] - quizData.getYearRange(),
                          1,
                          1),
                      lastDay: DateTime.utc(
                          quizData.getCenterDate()[0] + quizData.getYearRange(),
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
                          curFocus =
                              focusedDay; // curFocus 변수를 새로운 포커스된 날짜로 업데이트합니다.
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
                                quizData.getMaxAnswerSelection()) {
                              highlightedDates.add(selectedDay);
                            }
                          }
                          curFocus = focusedDay; // Update the focused day
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          bool isHighlighted = highlightedDates.any(
                              (highlightedDate) =>
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
                                  style: TextStyle(
                                      color: Colors.white), // Text color
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
                                        .black,
                                        ), // Making text color similar to other days
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: AppConfig.padding),
                  Text(
                    "선택된 날짜들",
                    style: TextStyle(fontSize: AppConfig.fontSize * widget.screenWidthModifier),
                  ),
                  SizedBox(height: AppConfig.padding),
                  Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: highlightedDates.length,
                      itemBuilder: (context, index) {
                        DateTime date = highlightedDates[index];
                        return Text(
                          '${index + 1}. ${date.year}, ${date.month}, ${date.day}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: AppConfig.fontSize * 1.5 * widget.screenWidthModifier),
                        );
                      },
                    ),
                  )
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
