import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:test/test.dart';

void main() {
  group('Testing Quiz2 class', () {
    late Quiz2 quiz;
    late Quiz2 emptyQuiz;
    setUp(() {
      quiz = Quiz2(
        answers: ['11', '22', '33', '44', '55'],
        ans: [true, false, false, false, false],
        question: "11을 고르세요.",
        maxAnswerSelection: 1,
        centerDate: [2024, 6, 22],
        yearRange: 10,
        answerDate: [
          [2024, 6, 22],
          [2024, 6, 20]
        ],
      );
      emptyQuiz = Quiz2(
        answers: ['', '', '', '', ''],
        ans: [],
        question: '',
        maxAnswerSelection: 1,
      );
    });

    test('setCurFocus', () {
      DateTime newCurFocus = DateTime(2024, 6, 22);
      expect(quiz.curFocus, null);
      quiz.setCurFocus(newCurFocus);
      expect(quiz.curFocus, newCurFocus);
    });

    test('check', (){
      expect(quiz.check(), false);
      quiz.addViewerAnswer(DateTime(2024, 6, 22));
      quiz.addViewerAnswer(DateTime(2024, 6, 19));
      expect(quiz.check(), false);
      quiz.addViewerAnswer(DateTime(2024, 6, 20));
      expect(quiz.check(), false);
      quiz.removeViewerAnswerAt(1);
      expect(quiz.check(), true);
    });

    test('getState', (){
      expect(quiz.getState(), MyColors().red);
      quiz.addViewerAnswer(DateTime(2024, 6, 22));
      expect(quiz.getState(), MyColors().green);
    });

    test('isSavable', (){
      expect(emptyQuiz.isSavable(), "질문을 입력해주세요.");
      emptyQuiz.setQuestion("New Question");
      expect(emptyQuiz.isSavable(), "답변을 입력해주세요.");
      emptyQuiz.addAnswerDate([1900, 6, 20]);
      expect(emptyQuiz.isSavable(), "답변 날짜가 유효 범위를 벗어났습니다.");
      emptyQuiz.setCenterDate([1900, 5, 10]);
      expect(emptyQuiz.isSavable(), 'ok');
    });

    test ('saveLoad', (){
      var json = quiz.toJson();

      var quiz2 = emptyQuiz.loadQuiz(json["body"]);
      expect(quiz2.answers, quiz.answers);
      expect(quiz2.ans, quiz.ans);
      expect(quiz2.question, quiz.question);
      expect(quiz2.centerDate, quiz.centerDate);
      expect(quiz2.yearRange, quiz.yearRange);
      expect(quiz2.answerDate, quiz.answerDate);
      expect(quiz2.maxAnswerSelection, quiz.maxAnswerSelection);
    });



  });
}
