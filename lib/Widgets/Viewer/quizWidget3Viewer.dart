import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/config.dart';

double fontSizeBase = 10.0;

class QuizView3 extends StatefulWidget {
  final int quizTag; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView3(
      {Key? key,
      required this.quizTag,
      this.screenWidthModifier = 1,
      this.screenHeightModifier = 1})
      : super(key: key);

  @override
  _QuizView3State createState() => _QuizView3State();
}

class _QuizView3State extends State<QuizView3> {
  Quiz3 quizData = Quiz3(
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
  late List<String> _items;

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
      quizData = Quiz3(
        answers: ['111', '222', '333', '444', '555'],
        ans: [true, false, false, false, false],
        question: "11을 고르세요.",
        maxAnswerSelection: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadQuizFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("퀴즈 로드에 실패했습니다."));
          }
          if (isFirstRun) {
            isFirstRun = false;
            quizData.setShuffledAnswers();
            _items = quizData.getShuffledAnswers();
          }
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(AppConfig.padding),
              child: Column(
                children: <Widget>[
                  QuestionViewer(question: quizData.getQuestion(), fontSizeModifier: widget.screenWidthModifier),
                  SizedBox(height: AppConfig.padding),
                  Expanded(
                    child: ReorderableListView.builder(
                      header: ListTile(
                        title: Container(
                          padding: EdgeInsets.all(AppConfig.smallPadding * widget.screenWidthModifier),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            _items[_items.length-1],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppConfig.fontSize * 1.3 * widget.screenWidthModifier,
                            ),
                          ),
                        ),
                      ),
                      buildDefaultDragHandles: false,
                      itemCount: _items.length-1,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Column(
                          key: Key('$item-$index'), // Column에 고유한 Key 추가
                          children: [
                            Icon(
                              
                              Icons.arrow_downward,
                              size: AppConfig.fontSize * 1.3 * widget.screenWidthModifier,
                              color: Colors.blue,
                              
                            ),
                            ReorderableDragStartListener(
                              index: index,
                              key: Key(item),
                              child: ListTile(
                                title: Container(
                                  padding: EdgeInsets.all(AppConfig.smallPadding * widget.screenWidthModifier), // 텍스트 주변에 패딩 추가
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue,
                                        width: 2.0), // 테두리 색상과 두께 설정
                                    borderRadius: BorderRadius.circular(
                                        4.0), // 테두리의 모서리를 둥글게
                                  ),
                                  child: Text(
                                    _items[index],
                                    textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                                    style: TextStyle(
                                      fontSize: AppConfig.fontSize * 1.3 * widget.screenWidthModifier, // 폰트 크기 설정
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
