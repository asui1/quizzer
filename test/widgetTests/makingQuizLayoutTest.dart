import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/MakingQuizLayout.dart';

Widget createMakingQuizLayoutScreen() => ChangeNotifierProvider<QuizLayout>(
      create: (context) => QuizLayout(),
      child: MaterialApp(
        home: MakingQuizscreen(),
      ),
    );
void main() {
  group('makingQuizLayout test', () {
    QuizLayout quizLayout = QuizLayout();
    testWidgets('makingQuizLayout test', (WidgetTester tester) async {
      Widget testWidget = ChangeNotifierProvider<QuizLayout>.value(
        value: quizLayout,
        child: MaterialApp(
          home: MakingQuizscreen(),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pump();

      //사용 동의 확인
      expect(find.text('사용 동의서'), findsOneWidget);
      final confirmButtonFinder = find.text('확인');
      await tester.tap(confirmButtonFinder);
      await tester.pumpAndSettle();

      //메인 화면, 1. 퀴즈 제목 설정에 포커스 확인.
      expect(find.text('사용 동의서'), findsNothing);
      // 텍스트 위젯을 찾습니다.
      final textButton1Finder = find.widgetWithText(TextButton, '1. 퀴즈 제목 설정.');
      // TextButton이 존재하는지 확인합니다.
      expect(textButton1Finder, findsOneWidget);
      final textButton = tester.widget<TextButton>(textButton1Finder);
      final Color focusColor = textButton.style?.foregroundColor?.resolve({}) ??
          Colors.transparent; // 아무 상태도 적용되지 않은 경우의 색상을 가져옵니다.
      expect(
          focusColor, quizLayout.getColorScheme().primary); // 예상하는 색상으로 변경하세요.

      final textButton2Finder =
          find.widgetWithText(TextButton, '2. 넘기기 스타일 설정.');
      expect(textButton2Finder, findsOneWidget);
      final textButton2 = tester.widget<TextButton>(textButton2Finder);
      final Color focusColor2 =
          textButton2.style?.foregroundColor?.resolve({}) ??
              Colors.transparent; // 아무 상태도 적용되지 않은 경우의 색상을 가져옵니다.
      expect(focusColor2,
          quizLayout.getColorScheme().primaryContainer); // 예상하는 색상으로 변경하세요.
    });
  });
}
