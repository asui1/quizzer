import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

double fontSizeBase = 10.0;

class QuizView2 extends StatefulWidget {
  final Quiz2 quiz; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView2({
    Key? key,
    required this.quiz,
    this.screenWidthModifier = 1,
    this.screenHeightModifier = 1,
  }) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);
    curFocus = widget.quiz.getCurFocus();
    highlightedDates = widget.quiz.getViewerAnswers();
    double strongScreenWidthModifier =
        widget.screenWidthModifier * widget.screenWidthModifier;
    bodyTextStyle = TextStyle(
      fontFamily: quizLayout.getBodyFont(),
      color: quizLayout.getColor(3),
      fontSize: AppConfig.fontSize *
          widget.screenWidthModifier *
          widget.screenWidthModifier,
    );
    return Theme(
      data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
      child: Scaffold(
        body: Container(
          decoration: backgroundDecoration(quizLayout: quizLayout),
          child: Padding(
            padding:
                EdgeInsets.all(AppConfig.padding * widget.screenWidthModifier),
            child: Column(
              children: <Widget>[
                QuestionViewer(
                  question: widget.quiz.getQuestion(),
                  fontSizeModifier: widget.screenWidthModifier,
                  quizLayout: quizLayout,
                ),
                Container(
                  height: AppConfig.screenHeight *
                      0.50 *
                      widget.screenHeightModifier,
                  width:
                      AppConfig.screenWidth * 0.95 * widget.screenWidthModifier,
                  child: TableCalendar(
                    rowHeight: AppConfig.screenHeight *
                        0.05 *
                        widget.screenHeightModifier,
                    daysOfWeekHeight: AppConfig.screenHeight *
                        0.05 *
                        widget.screenHeightModifier,
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
                      titleTextFormatter: (date, locale) {
                        return DateFormat('yyyy.MM')
                            .format(date); // Formats date as "YYYY.MM"
                      },
                      formatButtonVisible: false,
                      titleCentered: true,
                      headerMargin: EdgeInsets.all(AppConfig.padding *
                          widget.screenHeightModifier *
                          0.4),
                      headerPadding: EdgeInsets.all(
                          AppConfig.padding * strongScreenWidthModifier * 0.2),
                      titleTextStyle: TextStyle(
                        fontFamily: quizLayout.getBodyFont(),
                        fontSize:
                            AppConfig.fontSize * strongScreenWidthModifier,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        color: quizLayout.getColor(3),
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        size: AppConfig.iconSize * strongScreenWidthModifier,
                        color: quizLayout.getColor(3),
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        size: AppConfig.iconSize * strongScreenWidthModifier,
                        color: quizLayout.getColor(3),
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
                      cellMargin:
                          EdgeInsets.all(1.0 * strongScreenWidthModifier),
                      isTodayHighlighted: false,
                      defaultTextStyle: bodyTextStyle, // 일반 날짜의 텍스트 색상 설정
                      weekendTextStyle: bodyTextStyle,
                      outsideTextStyle: TextStyle(
                        fontFamily: quizLayout.getBodyFont(),
                        fontSize:
                            AppConfig.fontSize * strongScreenWidthModifier,
                        color: quizLayout.getColor(3).withAlpha(100),
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        if (selectedDay.year == focusedDay.year &&
                            selectedDay.month == focusedDay.month) {
                          // Check if the day is already highlighted
                          final existingIndex = highlightedDates
                              .indexWhere((day) => isSameDay(day, selectedDay));
                          if (existingIndex >= 0) {
                            // If it is, remove it from the list
                            widget.quiz.removeViewerAnswerAt(existingIndex);
                          } else {
                            // If it's not, add it, respecting the maximum selectable limit
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
                              color: quizLayout
                                  .getColorScheme()
                                  .primaryContainer, // Highlight color
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontFamily: quizLayout.getBodyFont(),
                                  color: quizLayout
                                      .getColorScheme()
                                      .onPrimaryContainer,
                                  fontSize: AppConfig.fontSize *
                                      widget.screenWidthModifier *
                                      widget.screenWidthModifier,
                                ), // Text color
                                // Text color
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
                                  fontFamily: quizLayout
                                      .getBodyFont()), // Making text color similar to other days
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                    height: AppConfig.padding * widget.screenWidthModifier),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppConfig.largePadding *
                          3 *
                          strongScreenWidthModifier,
                      right: AppConfig.largePadding *
                          3 *
                          strongScreenWidthModifier), // 왼쪽에 16.0의 패딩 추가
                  child: TextStyleWidget(
                    textStyle: quizLayout.getTextStyle(1),
                    text: Intl.message("Selected Dates"),
                    colorScheme: quizLayout.getColorScheme(),
                    modifier: widget.screenWidthModifier,
                  ),
                ),
                SizedBox(
                    height: AppConfig.padding * widget.screenWidthModifier),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: AppConfig.largePadding *
                            3 *
                            strongScreenWidthModifier,
                        right: AppConfig.largePadding *
                            3 *
                            strongScreenWidthModifier), // 왼쪽에 16.0의 패딩 추가
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: highlightedDates.length,
                      itemBuilder: (context, index) {
                        DateTime date = highlightedDates[index];
                        return TextStyleWidget(
                          textStyle: quizLayout.getTextStyle(2),
                          text:
                              '${index + 1}. ${date.year}. ${date.month}. ${date.day}',
                          colorScheme: quizLayout.getColorScheme(),
                          modifier: widget.screenWidthModifier,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
