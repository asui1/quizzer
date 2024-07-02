import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/config.dart';

class QuizView3 extends StatefulWidget {
  final Quiz3 quiz; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;
  final QuizLayout quizLayout;

  QuizView3(
      {Key? key,
      required this.quiz,
      this.screenWidthModifier = 1,
      this.screenHeightModifier = 1,
      required this.quizLayout})
      : super(key: key);

  @override
  _QuizView3State createState() => _QuizView3State();
}

class _QuizView3State extends State<QuizView3> {
  bool isLoading = true;
  List<int> order = [];
  List<bool> currentAnswer = [];
  late DateTime curFocus;
  List<DateTime> highlightedDates = [];
  late Future<void> _loadQuizFuture;
  bool isFirstRun = true;
  late List<String> _items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstRun) {
      isFirstRun = false;
      widget.quiz.setShuffledAnswers();
      _items = widget.quiz.getShuffledAnswers();
    }
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
                  quizLayout: widget.quizLayout),
              SizedBox(height: AppConfig.padding),
              Expanded(
                child: Theme(
                  data: ThemeData(
                    canvasColor: widget.quizLayout.getSelectedColor(),
                  ),
                  child: ReorderableListView.builder(
                    header: ListTile(
                      title: Container(
                        padding: EdgeInsets.all(AppConfig.smallPadding *
                            widget.screenWidthModifier),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: widget.quizLayout.getBorderColor2(),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          _items[_items.length - 1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: widget.quizLayout.getAnswerFont(),
                            color: widget.quizLayout.getTextColor(),
                            fontSize: AppConfig.fontSize *
                                1.3 *
                                widget.screenWidthModifier,
                          ),
                        ),
                      ),
                    ),
                    buildDefaultDragHandles: false,
                    itemCount: _items.length - 1,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Column(
                        key: Key('$item-$index'), // Column에 고유한 Key 추가
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            size: AppConfig.fontSize *
                                1.3 *
                                widget.screenWidthModifier,
                            color: widget.quizLayout.getButtonColor(),
                          ),
                          ReorderableDragStartListener(
                            index: index,
                            key: Key(item),
                            child: ListTile(
                              title: Container(
                                padding: EdgeInsets.all(AppConfig.smallPadding *
                                    widget
                                        .screenWidthModifier), // 텍스트 주변에 패딩 추가
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          widget.quizLayout.getBorderColor1(),
                                      width: 2.0), // 테두리 색상과 두께 설정
                                  borderRadius: BorderRadius.circular(
                                      4.0), // 테두리의 모서리를 둥글게
                                ),
                                child: Text(
                                  _items[index],
                                  textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                                  style: TextStyle(
                                    fontSize: AppConfig.fontSize *
                                        1.3 *
                                        widget.screenWidthModifier,
                                    fontFamily:
                                        widget.quizLayout.getAnswerFont(),
                                    color: widget.quizLayout
                                        .getTextColor(), // 폰트 크기 설정
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = _items.removeAt(oldIndex);
                        _items.insert(newIndex, item);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      final double animValue = Curves.easeInOut.transform(animation.value);
      final double elevation = lerpDouble(0, 6, animValue)!;
      return Material(
        elevation: elevation,
        color: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.5),
        child: child,
      );
    },
    child: child,
  );
}