import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/dateChooser.dart';
import 'package:quizzer/config.dart';
import 'package:table_calendar/table_calendar.dart';

class QuizWidget2 extends StatefulWidget {
  @override
  _QuizWidget2State createState() => _QuizWidget2State();
}

class _QuizWidget2State extends State<QuizWidget2> {
  Quiz2 quiz = Quiz2(
    answers: [],
    ans: [],
    question: '',
    maxAnswerSelection: 1,
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
    curFocus = DateTime(quiz.getCenterDate()[0], quiz.getCenterDate()[1],
        quiz.getCenterDate()[2]);
  }

  @override
  Widget build(BuildContext context) {
    int maxAnswerSelection = quiz.getMaxAnswerSelection();
    TextEditingController controller =
        TextEditingController(text: maxAnswerSelection.toString());
    final highlightedDates = quiz.getAnswerDate().map((date) {
      return DateTime.utc(date[0], date[1], date[2]);
    }).toList();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppConfig.padding),
        child: Column(
          children: <Widget>[
            questionInputTextField(
              controller: questionController,
              onChanged: (value) {
                quiz.setQuestion(value);
              },
            ),
            SizedBox(height: AppConfig.smallPadding),
            Container(
              height: AppConfig.screenHeight * 0.4,
              width: AppConfig.screenWidth * 0.8,
              child: TableCalendar(
                shouldFillViewport: true,
                firstDay: DateTime.utc(
                    quiz.getCenterDate()[0] - quiz.getYearRange(), 1, 1),
                lastDay: DateTime.utc(
                    quiz.getCenterDate()[0] + quiz.getYearRange(), 12, 31),
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
            //시작 날짜 ~ 끝나는 날 설정하도록 하기
            Text("중심 날짜를 선택하세요."),
            SizedBox(height: AppConfig.smallPadding),

            buildDatePicker(
              context,
              quiz,
              (List<int> date) {
                setState(() {
                  quiz.setCenterDate(date);
                  curFocus = DateTime.utc(date[0], date[1], date[2]);
                });
              },
              true,
              false,
              () {},
              -1,
              true,
              (value) {
                int? yearValue = int.tryParse(value);
                if (yearValue != null) {
                  setState(() {
                    quiz.setYearRange(yearValue);
                  });
                } else {}
              },
            ),
            SizedBox(height: AppConfig.padding),
            Text("정답인 날짜들을 입력해주세요."),
            SizedBox(height: AppConfig.smallPadding),

            Column(
              children: <Widget>[
                Column(
                  children: [
                    ElevatedButton(
                      child: Text('+'),
                      onPressed: () {
                        setState(() {
                          quiz.addAnswerDate(quiz.getCenterDate());
                        });
                      },
                    ),
                    SizedBox(height: AppConfig.smallPadding),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height * 0.3, // 화면 높이의 1/3
                      child: ListView.builder(
                        itemCount: quiz.getAnswerDate().length,
                        itemBuilder: (context, index) {
                          return buildDatePicker(
                              context,
                              quiz,
                              (List<int> date) {
                                setState(() {
                                  quiz.updateAnswerDateAt(index, date);
                                });
                              },
                              false,
                              true,
                              () {
                                setState(() {
                                  quiz.removeAnswerDateAt(index);
                                });
                              },
                              index,
                              false,
                              (value) {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(
              flex: 1,
            ),
            GeneratorDoneButton(
              onPressed: () {
                quiz.saveQuiz(9999);
                Navigator.pop(context, quiz);
              },
            ),
          ],
        ),
      ),
    );
  }
}
