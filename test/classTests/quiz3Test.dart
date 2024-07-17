

import 'package:quizzer/Class/quiz3.dart';
import 'package:test/test.dart';

void main(){
  group('Testing Quiz3 Class', (){
    late Quiz3 quiz;
    late Quiz3 emptyQuiz;
    setUp(() {
      quiz = Quiz3(
        answers: ['11', '22', '33', '44', '55'],
        ans: [true, false, false, false, false],
        question: "11을 고르세요.",
        maxAnswerSelection: 1,
      );
      emptyQuiz = Quiz3(
        answers: ['', '', '', '', ''],
        ans: [],
        question: '',
        maxAnswerSelection: 1,
      );
    });

    test('setShuffledAnswers', (){
      expect(quiz.shuffledAnswers, []);
      quiz.setShuffledAnswers();
      expect(quiz.shuffledAnswers, isNot(['11', '22', '33', '44', '55']));
    });

    test('check', (){
      quiz.setShuffledAnswers();
      expect(quiz.check(), false);
      quiz.shuffledAnswers = ['11', '22', '33', '44', '55'];
      expect(quiz.check(), true);
    });

    test('saveLoad', (){
      var json = quiz.toJson();

      var quiz2 = emptyQuiz.loadQuiz(json["body"]);
      expect(quiz2.answers, quiz.answers);
      expect(quiz2.ans, quiz.ans);
      expect(quiz2.question, quiz.question);
      expect(quiz2.maxAnswerSelection, quiz.maxAnswerSelection);

    });

    test('savable', (){
      expect(emptyQuiz.isSavable(), "질문을 입력해주세요.");
      emptyQuiz.setQuestion("11을 고르세요");
      expect(emptyQuiz.isSavable(), "답변을 모두 입력해주세요.");
      emptyQuiz.setAnswerAt(0, "11");
      expect(emptyQuiz.isSavable(), "답변을 모두 입력해주세요.");
      emptyQuiz.setAnswerAt(1, "22");
      emptyQuiz.setAnswerAt(2, "newString");
      emptyQuiz.setAnswerAt(3, "newString");
      emptyQuiz.setAnswerAt(4, "newString");
      expect(emptyQuiz.isSavable(), "ok");

    });

  });
}