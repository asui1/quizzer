import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz3.dart';

class QuizWidget3 extends StatefulWidget {
  @override
  _QuizWidget3State createState() => _QuizWidget3State();
}

class _QuizWidget3State extends State<QuizWidget3> {
  Quiz3 quiz = Quiz3(
    answers: ['', ''],
    ans: [],
    question: '',
    maxAnswerSelection: 1,
  );
  late TextEditingController questionController;
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: quiz.getQuestion());
    _initControllers();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initControllers() {
    _controllers = quiz.answers
        .map((answer) => TextEditingController(text: answer))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            controller: questionController,
            decoration: InputDecoration(
              hintText: '질문을 입력해주세요.',
            ),
            onChanged: (value) {
              quiz.setQuestion(value);
            },
          ),
          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              for (int index = 0; index < quiz.getAnswersLength(); index++) ...[
                Row(
                  children: [
                    SizedBox(width: 20.0),
                    Expanded(
                      child: TextField(
                        key: ValueKey(index), // TextField에 대한 Key
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '답변 ${index + 1}',
                        ),
                        onChanged: (value) {
                          setState(() {
                            quiz.setAnswerAt(index, value);
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          quiz.removeAnswerAt(index);
                          _controllers.removeAt(index); // 컨트롤러 리스트에서도 해당 항목 제거
                        });
                      },
                    ),
                  ],
                ),
                if (index <
                    quiz.answers.length - 1) // 마지막 TextField 다음에는 아이콘을 추가하지 않음
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.arrow_downward,
                        color: Colors.purple[700],),
                      ),
                    ),
                  ),
              ],
            ],
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                quiz.addAnswer('');
                _controllers.add(TextEditingController());
              });
            },
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                child: Text('완료'),
                onPressed: () {
                  quiz.saveQuiz(9999);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
