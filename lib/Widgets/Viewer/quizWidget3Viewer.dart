import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

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
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    widget.quiz.setShuffledAnswers();
    _items = widget.quiz.getShuffledAnswers();
  }

  @override
  Widget build(BuildContext context) {
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
                child: ReorderableListView.builder(
                    header: ListTile(
                      title: Container(
                        padding: EdgeInsets.all(AppConfig.smallPadding *
                            widget.screenWidthModifier),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          _items[0],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: widget.quizLayout.getAnswerFont(),
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
                      final item = _items[index+1];
                      return Column(
                        key: Key('$item-$index'), // Column에 고유한 Key 추가
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            size: AppConfig.fontSize *
                                1.3 *
                                widget.screenWidthModifier,
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
                                      width: 2.0), // 테두리 색상과 두께 설정
                                  borderRadius: BorderRadius.circular(
                                      4.0), // 테두리의 모서리를 둥글게
                                ),
                                child: Text(
                                  _items[index+1],
                                  textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                                  style: TextStyle(
                                    fontSize: AppConfig.fontSize *
                                        1.3 *
                                        widget.screenWidthModifier,
                                    fontFamily:
                                        widget.quizLayout.getAnswerFont(),
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
                        final item =
                            widget.quiz.removeShuffledAnswerAt(oldIndex+1);
                        widget.quiz.addShuffledAnswerAt(newIndex+1, item);
                        _items = widget.quiz.getShuffledAnswers();});
                    },
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
