import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:test/test.dart';

void main() {
  group('Testing Quiz1 class', () {
    late Quiz1 quiz1;
    late Quiz1 emptyQuiz;
    setUp(() {
      quiz1 = Quiz1(
        answers: ['A', 'B', 'C', 'D'],
        ans: [true, false, false, false],
        question: 'Question 1',
      );
      emptyQuiz = Quiz1(
          answers: ['', '', ''], ans: [false, false, false], question: '');
    });
    test('set question', () {
      String question = 'New Question 1';
      quiz1.setQuestion(question);
      expect(quiz1.question, question);
    });
    test('add answer', () {
      String answer = 'E';
      quiz1.addAnswer(answer);
      expect(quiz1.answers.contains(answer), true);
    });
    test('remove answer', () {
      String answer = 'E';
      quiz1.removeAnswer(answer);
      expect(quiz1.answers.contains(answer), false);
    });
    test('set Answer At', () {
      String answer = 'E';
      quiz1.setAnswer(1, answer);
      expect(quiz1.answers[1], answer);
    });
    test('remove Answer At', () {
      quiz1.removeAnswerAt(1);
      expect(quiz1.answers.contains('B'), false);
    });
    test('viewerInit', () {
      quiz1.viewerInit();
      expect(quiz1.viewerAnswers.length, quiz1.answers.length);
      expect(quiz1.viewerAns.length, quiz1.answers.length);
    });
    test('check', () {
      quiz1.viewerInit();
      expect(quiz1.check(), false);
      quiz1.viewerAns[0] = true;
      expect(quiz1.check(), true);
    });
    test('getState', () {
      quiz1.viewerInit();
      expect(quiz1.viewerAns.where((element) => element == true).length, 0);
      expect(quiz1.getState(), MyColors().red);
      quiz1.viewerAns[0] = true;
      expect(quiz1.getState(), MyColors().green);
    });
    test('getViewerAnsAt', () {
      quiz1.viewerInit();
      expect(quiz1.getViewerAnswerAt(0), 'A');
    });
    test('getViewerAns', () {
      quiz1.viewerInit();
      expect(quiz1.getViewerAns().length, quiz1.answers.length);
    });
    test('getViewerAnswers', () {
      quiz1.viewerInit();
      expect(quiz1.getViewerAnswers().length, quiz1.answers.length);
    });
    test('getViewAnsCount', () {
      quiz1.viewerInit();
      expect(quiz1.getViewAnsTrueCount(), 0);
      quiz1.viewerAns[0] = true;
      expect(quiz1.getViewAnsTrueCount(), 1);
    });
    test('getAnswerAt', () {
      expect(quiz1.getAnswerAt(0), 'A');
    });
    test('getAnswers', () {
      expect(quiz1.getAnswers().length, 4);
    });
    test('maxAnswerSelectionTest', () {
      expect(quiz1.getMaxAnswerSelection(), 1);
      quiz1.setMaxAnswerSelection(2);
      expect(quiz1.maxAnswerSelection, 2);
    });
    test('changeCorrectAns', () {
      quiz1.setAnsAt(0, false);
      expect(quiz1.ans[0], false);
    });
    test('shuffleAnswersTest', () {
      quiz1.setShuffleAnswers(true);
      expect(quiz1.getShuffleAnswers(), true);
      quiz1.viewerInit();
      expect(quiz1.answers, isNot(quiz1.viewerAnswers));
      expect(quiz1.getShuffleAnswers(), false);
    });
    test('getAnsLength', () {
      expect(quiz1.getAnsTrueLength(), 1);
      quiz1.ans[1] = true;
      expect(quiz1.getAnsTrueLength(), 2);
    });
    test('isCorrectAns', () {
      expect(quiz1.isCorrectAns(0), true);
      quiz1.ans[0] = false;
      expect(quiz1.isCorrectAns(0), false);
    });

    //NEEDS IMPLEMENTATION BUT TO HEAVY TO DO NOW.
    // test('loadQuiz', (){
    //   var json = {
    //     'answers': ['A', 'B', 'C', 'D'],
    //     'ans': [true, false, false, false],
    //     'question': 'Question 1',
    //   };
    //   var quiz = quiz1.loadQuiz(json);
    //   expect(quiz.answers, json['answers']);
    //   expect(quiz.ans, json['ans']);
    //   expect(quiz.question, json['question']);
    // });

    // test('jsonSaveLoadTest', () {
    //   var json = quiz1.toJson();
    //
    //   var quiz = emptyQuiz.loadQuiz(json["body"]); -> renewed
    //   expect(quiz.answers, quiz1.answers);
    //   expect(quiz.ans, quiz1.ans);
    //   expect(quiz.question, quiz1.question);
    // });

    test('isSavable', () {
      expect(emptyQuiz.isSavable(), '질문을 입력해주세요.');
      emptyQuiz.setQuestion("New Question");
      expect(emptyQuiz.isSavable(), '답변을 모두 입력해주세요.');
      emptyQuiz.setAnswerAt(0, 'answer0');
      emptyQuiz.setAnswerAt(1, 'answer1');
      emptyQuiz.setAnswerAt(2, 'answer2');
      expect(emptyQuiz.isSavable(), '정답을 선택해주세요.');
      emptyQuiz.setAnsAt(0, true);
      expect(emptyQuiz.isSavable(), 'ok');
    });
  });
}
