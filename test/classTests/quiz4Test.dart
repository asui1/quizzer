

import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:test/test.dart';

void main(){
  group("testing Quiz4 class", (){
    late Quiz4 quiz;
    late Quiz4 emptyQuiz;
    setUp((){
      quiz = Quiz4(
          answers: ['11', '22', '33', '44', '55'],
          ans: [true, false, false, false, false],
          question: "11을 고르세요.",
          maxAnswerSelection: 1,
          connectionAnswers: ['C', 'E', 'A', 'B', 'D'],
          connectionAnswerIndex: [2, 4, 0, 1, 3],
        );
      emptyQuiz = Quiz4(
          answers: [''],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
          connectionAnswers: [''],
          connectionAnswerIndex: [null],
        );
    });

    test('initOffsets', (){
      quiz.initOffsets();
      expect(quiz.starts.length, 5);
      expect(quiz.ends.length, 5);
      quiz.initUserOffsets();
      expect(quiz.userStarts.length, 5);
      expect(quiz.userEnds.length, 5);
    });

    test('check', (){
      quiz.initUserOffsets();
      expect(quiz.check(), false);
      expect(quiz.getState(), MyColors().red);
      quiz.setUserConnectionIndexAt(0, 2);
      quiz.setUserConnectionIndexAt(1, 4);
      quiz.setUserConnectionIndexAt(2, 0);
      quiz.setUserConnectionIndexAt(3, 1);
      expect(quiz.check(), false);
      quiz.setUserConnectionIndexAt(4, 3);
      expect(quiz.check(), true);
      expect(quiz.getState(), MyColors().green);
    });

    test('saveload', (){
      var json = quiz.toJson();

      var quiz2 = emptyQuiz.loadQuiz(json["body"]);
      expect(quiz2.connectionAnswers, quiz.connectionAnswers);
      expect(quiz2.connectionAnswerIndex, quiz.connectionAnswerIndex);
      expect(quiz2.answers, quiz.answers);
      expect(quiz2.ans, quiz.ans);
      expect(quiz2.question, quiz.question);
      expect(quiz2.maxAnswerSelection, quiz.maxAnswerSelection);
    });

    test('isSavable', (){
      expect(emptyQuiz.isSavable(), "질문을 입력해주세요.");
      emptyQuiz.setQuestion("New Question");
      expect(emptyQuiz.isSavable(), "답변을 모두 입력해주세요.");
      emptyQuiz.setAnswerAt(0, "A");
      expect(emptyQuiz.isSavable(), "답변을 모두 입력해주세요.");
      emptyQuiz.setConnectionAnswerAt(0, "B");
      expect(emptyQuiz.isSavable(), "답변을 2개 이상 입력해주세요.");
      emptyQuiz.addAnswerPair();
      emptyQuiz.setAnswerAt(1, "B");
      emptyQuiz.setConnectionAnswerAt(1, "A");
      expect(emptyQuiz.isSavable(), "답변을 모두 연결해주세요.");
      emptyQuiz.setConnectionAnswerIndexAt(0, 1);
      emptyQuiz.setConnectionAnswerIndexAt(1, 0);
      expect(emptyQuiz.isSavable(), "ok");
    });


  });
}