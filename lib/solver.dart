

// topbar, bottombar 구현, 넘기기 버튼 구현. body에 QuizView 넣어주기.
// 사용자가 입력한 정답 관리.
// 우선은 앱 레벨에서 채점하고, 나중에 서버에서 채점하도록 수정.
// 채점 후 점수를 가지고 결과 페이지로 이동.
// Solver가 받을 입력 : Quizlayout, int index -> 몇 번째 퀴즈를 화면에 나타낼지.



import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';

class QuizSolver extends StatefulWidget {
  final QuizLayout quizLayout;
  final int index;

  const QuizSolver({
    Key? key,
    required this.quizLayout,
    required this.index,
  }) : super(key: key);

  @override
  _QuizSolverState createState() => _QuizSolverState();
}

class _QuizSolverState extends State<QuizSolver> {
  //정답 관리할 변수 필요.
  //채점 함수는 Functions에 새로운 함수를 만들고 그걸 호출하여 사용할 예정.

  @override
  Widget build(BuildContext context) {
    // 여기에서 widget.quizLayout과 widget.index를 사용하여 UI를 구성합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Solver'),
      ),
      body: Center(
        // 예시로, 현재 퀴즈의 인덱스를 화면에 표시합니다.
        child: Text('Current Quiz Index: ${widget.index}'),
      ),
    );
  }
}