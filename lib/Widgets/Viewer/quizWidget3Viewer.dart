
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

class QuizView3 extends StatefulWidget {
  final Quiz3 quiz; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView3({
    Key? key,
    required this.quiz,
    this.screenWidthModifier = 1,
    this.screenHeightModifier = 1,
  }) : super(key: key);

  @override
  _QuizView3State createState() => _QuizView3State();
}

class _QuizView3State extends State<QuizView3> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);
    widget.quiz.getAnswers();
    if (widget.quiz.shuffledAnswers.isEmpty) widget.quiz.setShuffledAnswers();
    _items = widget.quiz.getShuffledAnswers();
    return Theme(
      data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
      child: Scaffold(
        body: Container(
          decoration: backgroundDecoration(quizLayout: quizLayout),
          child: Padding(
            padding: EdgeInsets.all(AppConfig.padding),
            child: Column(
              children: <Widget>[
                QuestionViewer(
                    question: widget.quiz.getQuestion(),
                    fontSizeModifier: widget.screenWidthModifier,
                    quizLayout: quizLayout),
                SizedBox(height: AppConfig.padding),
                Expanded(
                  child: ReorderableListView.builder(
                    header: ListTile(
                      title: TextStyleWidget(
                        textStyle: quizLayout.getTextStyle(1),
                        text: _items[0],
                        colorScheme: quizLayout.getColorScheme(),
                        modifier: widget.screenWidthModifier,
                      ),
                    ),
                    buildDefaultDragHandles: false,
                    itemCount: _items.length - 1,
                    itemBuilder: (context, index) {
                      final item = _items[index + 1];
                      return Column(
                        key: Key('$item-$index'), // Column에 고유한 Key 추가
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            size: AppConfig.fontSize *
                                1.3 *
                                widget.screenWidthModifier,
                            color: quizLayout.getColorScheme().outline,
                          ),
                          ReorderableDragStartListener(
                            index: index,
                            key: Key(item),
                            child: ListTile(
                              title: TextStyleWidget(
                                textStyle: quizLayout.getTextStyle(2),
                                text: item,
                                colorScheme: quizLayout.getColorScheme(),
                                modifier: widget.screenWidthModifier,
                                setBorder: true,
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
                            widget.quiz.removeShuffledAnswerAt(oldIndex + 1);
                        widget.quiz.addShuffledAnswerAt(newIndex + 1, item);
                        _items = widget.quiz.getShuffledAnswers();
                      });
                    },
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
