import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Widgets/dateChooser.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:table_calendar/table_calendar.dart';

class QuizWidget2 extends StatefulWidget {
  final QuizLayout quizLayout;
  final Quiz2 quiz;
  QuizWidget2({Key? key, required this.quiz, required this.quizLayout})
      : super(key: key);

  @override
  _QuizWidget2State createState() => _QuizWidget2State();
}

class _QuizWidget2State extends State<QuizWidget2> {
  late TextEditingController questionController;
  late DateTime curFocus;
  late TextEditingController yearController;
  late TextEditingController yearRangeController;
  late TextStyle bodyTextStyle;
  late TextStyle textStyle;
  double deltaY = 0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.quiz.getQuestion());
    yearRangeController =
        TextEditingController(text: widget.quiz.getYearRange().toString());
    yearController =
        TextEditingController(text: widget.quiz.getCenterDate()[0].toString());
    curFocus = DateTime(widget.quiz.getCenterDate()[0],
        widget.quiz.getCenterDate()[1], widget.quiz.getCenterDate()[2]);
    bodyTextStyle = TextStyle(
      fontFamily: widget.quizLayout.getBodyFont(),
      color: widget.quizLayout.getColor(4),
    );
    textStyle = TextStyle(
        fontFamily: widget.quizLayout.getAnswerFont(),
        fontSize: AppConfig.fontSize);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    questionController.dispose();
    yearController.dispose();
    yearRangeController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int maxAnswerSelection = widget.quiz.getMaxAnswerSelection();
    TextEditingController controller =
        TextEditingController(text: maxAnswerSelection.toString());
    final highlightedDates = widget.quiz.getAnswerDate().map((date) {
      return DateTime.utc(date[0], date[1], date[2]);
    }).toList();
    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
              height: AppConfig.screenHeight,
              width: AppConfig.screenWidth,
              decoration: backgroundDecoration(quizLayout: widget.quizLayout),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(AppConfig.padding),
                      child: Column(
                        children: <Widget>[
                          questionInputTextField(
                            controller: questionController,
                            onChanged: (value) {
                              widget.quiz.setQuestion(value);
                            },
                            quizLayout: widget.quizLayout,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConfig.screenHeight * 0.37,
                                    width: AppConfig.screenWidth * 0.8,
                                    child: TableCalendar(
                                      shouldFillViewport: true,
                                      pageJumpingEnabled: true,
                                      onDaySelected:
                                          (selectedDay, focusedDay) => {
                                        setState(() {
                                          curFocus = focusedDay;
                                        })
                                      },
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
                                        titleTextStyle: TextStyle(
                                            fontFamily:
                                                widget.quizLayout.getBodyFont(),
                                            fontWeight: FontWeight.bold,
                                            color: widget.quizLayout
                                                .getColor(3)), // 헤더 제목 색상
                                        leftChevronIcon: Icon(
                                            Icons.chevron_left,
                                            color: widget.quizLayout
                                                .getColor(3)), // 왼쪽 화살표 아이콘 색상
                                        rightChevronIcon: Icon(
                                            Icons.chevron_right,
                                            color: widget.quizLayout
                                                .getColor(3)), // 오른쪽 화살표 아이콘 색상
                                      ),
                                      daysOfWeekStyle: DaysOfWeekStyle(
                                        weekdayStyle:
                                            bodyTextStyle, // 요일 텍스트 색상
                                        weekendStyle:
                                            bodyTextStyle, // 주말 텍스트 색상
                                      ),
                                      onPageChanged: (focusedDay) {
                                        // 사용자가 달력의 페이지를 변경할 때 호출됩니다.
                                        // focusedDay는 새로운 포커스된 날짜입니다.
                                        setState(() {
                                          curFocus =
                                              focusedDay; // curFocus 변수를 새로운 포커스된 날짜로 업데이트합니다.
                                        });
                                      },
                                      calendarStyle: CalendarStyle(
                                        isTodayHighlighted: false,
                                        defaultTextStyle:
                                            bodyTextStyle, // 일반 날짜의 텍스트 색상 설정
                                        weekendTextStyle: bodyTextStyle,
                                        outsideTextStyle: TextStyle(
                                          color: widget.quizLayout
                                              .getColor(4)
                                              .withAlpha(100),
                                        ),
                                      ),

                                      calendarFormat: CalendarFormat
                                          .month, // Set your desired format here
                                      calendarBuilders: CalendarBuilders(
                                        defaultBuilder:
                                            (context, day, focusedDay) {
                                          bool isHighlighted = highlightedDates
                                              .any((highlightedDate) =>
                                                  day.year ==
                                                      highlightedDate.year &&
                                                  day.month ==
                                                      highlightedDate.month &&
                                                  day.day ==
                                                      highlightedDate.day);

                                          // If it is highlighted, customize its appearance
                                          if (isHighlighted) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: widget.quizLayout
                                                    .getColor(
                                                        5), // Highlight color
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${day.day}',
                                                  style: TextStyle(
                                                      color: widget.quizLayout
                                                          .getColor(
                                                              8)), // Text color
                                                ),
                                              ),
                                            );
                                          }

                                          // Return null for default appearance on non-highlighted days
                                          return null;
                                        },
                                        todayBuilder:
                                            (context, day, focusedDay) {
                                          // Customizing today's appearance to look like a regular day
                                          return Container(
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: bodyTextStyle,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  //시작 날짜 ~ 끝나는 날 설정하도록 하기
                                  SizedBox(height: AppConfig.smallPadding),
                                  Text(
                                    "중심 날짜를 선택하세요.",
                                    style: textStyle,
                                  ),
                                  SizedBox(height: AppConfig.smallPadding),
                                  buildDatePicker(
                                    context,
                                    widget.quiz,
                                    (List<int> date) {
                                      setState(() {
                                        widget.quiz.setCenterDate(date);
                                        curFocus = DateTime.utc(
                                            date[0], date[1], date[2]);
                                      });
                                    },
                                    true,
                                    false,
                                    () {},
                                    -1,
                                    textStyle,
                                    yearController: yearController,
                                    yearRangeController: yearRangeController,
                                  ),
                                  SizedBox(height: AppConfig.padding),
                                  Text(
                                    "정답인 날짜들을 입력해주세요.",
                                    style: textStyle,
                                  ),
                                  SizedBox(height: AppConfig.smallPadding),
                                  SizedBox(height: AppConfig.smallPadding),
                                  ...List.generate(
                                    widget.quiz.getAnswerDate().length,
                                    (index) {
                                      return buildDatePicker(
                                        context,
                                        widget.quiz,
                                        (List<int> date) {
                                          setState(() {
                                            widget.quiz.updateAnswerDateAt(
                                                index, date);
                                          });
                                        },
                                        false,
                                        true,
                                        () {
                                          setState(() {
                                            widget.quiz
                                                .removeAnswerDateAt(index);
                                          });
                                        },
                                        index,
                                        textStyle,
                                      );
                                    },
                                  ),
                                  SizedBox(height: AppConfig.smallPadding),
                                  ElevatedButton(
                                    child: Text('+'),
                                    onPressed: () {
                                      setState(() {
                                        widget.quiz.addAnswerDate(
                                            widget.quiz.getCenterDate());
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: AppConfig.padding * 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppConfig.padding, // Adjust the position as needed
                    bottom: AppConfig.padding, // Adjust the position as needed
                    child: GeneratorDoneButton(
                      onPressed: () {
                        Navigator.pop(context, widget.quiz);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
