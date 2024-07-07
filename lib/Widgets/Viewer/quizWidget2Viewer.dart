import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

double fontSizeBase = 10.0;

class QuizView2 extends StatefulWidget {
  final Quiz2 quiz; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;
  final QuizLayout quizLayout;

  QuizView2(
      {Key? key,
      required this.quiz,
      this.screenWidthModifier = 1,
      this.screenHeightModifier = 1,
      required this.quizLayout})
      : super(key: key);

  @override
  _QuizView2State createState() => _QuizView2State();
}

class _QuizView2State extends State<QuizView2> {
  late DateTime curFocus;
  late List<DateTime> highlightedDates;
  late TextStyle bodyTextStyle;

  @override
  void initState() {
    super.initState();
    bodyTextStyle = TextStyle(
        color: widget.quizLayout.getBodyTextColor(),
        fontFamily: widget.quizLayout.getBodyFont());
  }

  @override
  Widget build(BuildContext context) {
    curFocus = widget.quiz.getCurFocus();
    highlightedDates = widget.quiz.getViewerAnswers();
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(quizLayout: widget.quizLayout),
        child: Padding(
          padding: EdgeInsets.all(AppConfig.padding),
          child: Column(
            children: <Widget>[
              QuestionViewer(
                question: widget.quiz.getQuestion(),
                fontSizeModifier: widget.screenWidthModifier,
                quizLayout: widget.quizLayout,
              ),
              Container(
                height:
                    AppConfig.screenHeight * 0.5 * widget.screenHeightModifier,
                width: AppConfig.screenWidth * 0.8 * widget.screenWidthModifier,
                child: TableCalendar(
                  shouldFillViewport: true,
                  pageJumpingEnabled: true,
                  firstDay: DateTime.utc(
                      widget.quiz.getCenterDate()[0] -
                          widget.quiz.getYearRange(),
                      1,
                      1),
                  lastDay: DateTime.utc(
                      widget.quiz.getCenterDate()[0] +
                          widget.quiz.getYearRange(),
                      12,
                      31),
                  focusedDay: curFocus,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    headerMargin: EdgeInsets.all(
                        AppConfig.padding * widget.screenHeightModifier * 0.5),
                    headerPadding: EdgeInsets.all(
                        AppConfig.padding * widget.screenWidthModifier * 0.5),
                    titleTextStyle: TextStyle(
                      fontFamily: widget.quizLayout.getBodyFont(),
                      fontSize:
                          AppConfig.fontSize * widget.screenHeightModifier,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: widget.quizLayout.getBodyTextColor(),
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      size: AppConfig.iconSize * widget.screenWidthModifier,
                      color: widget.quizLayout.getBodyTextColor(),
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      size: AppConfig.iconSize * widget.screenWidthModifier,
                      color: widget.quizLayout.getBodyTextColor(),
                    ),
                  ),
                  onPageChanged: (focusedDay) {
                    // 사용자가 달력의 페이지를 변경할 때 호출됩니다.
                    // focusedDay는 새로운 포커스된 날짜입니다.
                    setState(() {
                      widget.quiz.setCurFocus(
                          focusedDay); // curFocus 변수를 새로운 포커스된 날짜로 업데이트합니다.
                    });
                  },
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: bodyTextStyle, // 요일 텍스트 색상
                    weekendStyle: bodyTextStyle, // 주말 텍스트 색상
                  ),
                  calendarFormat:
                      CalendarFormat.month, // Set your desired format here
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: false,
                    defaultTextStyle: bodyTextStyle, // 일반 날짜의 텍스트 색상 설정
                    weekendTextStyle: bodyTextStyle,
                    outsideTextStyle: TextStyle(
                      color:
                          widget.quizLayout.getBodyTextColor().withAlpha(100),
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      // Check if the day is already highlighted
                      final existingIndex = highlightedDates
                          .indexWhere((day) => isSameDay(day, selectedDay));
                      if (existingIndex >= 0) {
                        // If it is, remove it from the list
                        widget.quiz.removeViewerAnswerAt(existingIndex);
                      } else {
                        // If it's not, add it, respecting the maximum selectable limit
                        if (highlightedDates.length <
                            widget.quiz.getMaxAnswerSelection()) {
                          widget.quiz.addViewerAnswer(selectedDay);
                        }
                      }
                      widget.quiz.setCurFocus(focusedDay);
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
                            color: widget.quizLayout
                                .getSelectedColor(), // Highlight color
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                  color: widget.quizLayout.getBodyTextColor(),
                                  fontFamily: widget.quizLayout
                                      .getBodyFont()), // Text color
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
                                color: widget.quizLayout.getBodyTextColor(),
                                fontFamily: widget.quizLayout
                                    .getBodyFont()), // Making text color similar to other days
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
                style: TextStyle(
                    fontFamily: widget.quizLayout.getAnswerFont(),
                    color: widget.quizLayout.getTextColor(),
                    fontSize: AppConfig.fontSize * widget.screenWidthModifier),
              ),
              SizedBox(height: AppConfig.padding),
              Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: highlightedDates.length,
                  itemBuilder: (context, index) {
                    DateTime date = highlightedDates[index];
                    return Text(
                      '${index + 1}. ${date.year}. ${date.month}. ${date.day}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppConfig.fontSize *
                            1.5 *
                            widget.screenWidthModifier,
                        color: widget.quizLayout.getTextColor(),
                        fontFamily: widget.quizLayout.getAnswerFont(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
