import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/MakingQuizLayout.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/main.dart';
import 'dart:math';

String generateRandomHexColor() {
  final Random random = Random();
  // Generate a random number for each color component (0-255)
  final int red = random.nextInt(256);
  final int green = random.nextInt(256);
  final int blue = random.nextInt(256);

  // Convert each component to a hex string and concatenate
  return '${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
}

Future<void> doubleTap(WidgetTester tester, Finder finder) async {
  final Offset center = tester.getCenter(finder);
  final TestGesture gesture = await tester.startGesture(center);
  await gesture.up();
  await Future.delayed(const Duration(milliseconds: 100)); // 짧은 지연
  await gesture.down(center);
  await gesture.up();
}

void main() {
  group('Testing App', () {
    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await UserPreferences.init();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
    testWidgets('Quizzer Test: MakeQuizLayout', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      //QUIZ LAYOUT 쭉 넘어가면서 퀴즈 만들고 저장하는 것까지 문제없이 되는지 테스트.
      final fab = find.byKey(const ValueKey('moveToMakingQuizScreen'));
      await tester.tap(fab);
      await tester.pumpAndSettle();

//      사용 동의서 닫기 테스트.
      expect(find.text('사용 동의서'), findsOneWidget);
      NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      //다시 퀴즈로 이동.
      await tester.tap(fab);
      await tester.pumpAndSettle();
      final confirmButtonFinder = find.text('확인');
      expect(confirmButtonFinder, findsOneWidget);
      await tester.tap(confirmButtonFinder);
      await tester.pumpAndSettle();

      //퀴즈 제목 설정.
      final textButton0Finder =
          find.byKey(const ValueKey('MakingQuizLayoutCustomContainer0'));
      await tester.tap(textButton0Finder);
      await tester.pumpAndSettle();
      final customContainer0 = find.text('퀴즈 제목 설정');
      expect(customContainer0, findsOneWidget);
      final titleTextField =
          find.byKey(const ValueKey('MakingQuizLayoutTitleTextField'));
      await tester.enterText(titleTextField, '테스트용 퀴즈 제목');
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      final confirmButtonFinder2 = find.text('확인');
      await tester.tap(confirmButtonFinder2);
      await tester.pumpAndSettle();

      final topBarToggle =
          find.byKey(const ValueKey('MakingQuizLayoutTopBarToggle'));
      await tester.tap(topBarToggle);
      await tester.pumpAndSettle();

      final bottomBarToggle =
          find.byKey(const ValueKey('MakingQuizLayoutBottomBarToggle'));
      await tester.tap(bottomBarToggle);
      await tester.pumpAndSettle();

      //넘기기 스타일 설정.
      final textButton1Finder =
          find.byKey(const ValueKey('MakingQuizLayoutCustomContainer1'));
      await tester.tap(textButton1Finder);
      await tester.pumpAndSettle();
      final customContainer1 = find.text('넘기기 스타일 설정');
      expect(customContainer1, findsOneWidget);
      final quizLayoutOption =
          find.byKey(const ValueKey('MakingQuizLayoutLayoutOption1'));
      await tester.tap(quizLayoutOption);
      await tester.pumpAndSettle();
      final confirmButtonFinder3 = find.text('확인');
      await tester.tap(confirmButtonFinder3);
      await tester.pumpAndSettle();

      //색 설정.
      final textButton2Finder =
          find.byKey(const ValueKey('MakingQuizLayoutCustomContainer2'));
      await tester.tap(textButton2Finder);
      await tester.pumpAndSettle();
      final customContainer2 = find.text('배경/색상 설정');
      expect(customContainer2, findsOneWidget);

      var colorOption =
          find.byKey(const ValueKey('MakingQuizLayoutImageSetButton메인 색1'));
      await tester.tap(colorOption);
      await tester.pumpAndSettle();
      var colorPickerTextField =
          find.byKey(const ValueKey('quizLayoutHexField'));
      await tester.enterText(colorPickerTextField, '');
      await tester.pumpAndSettle();
      await tester.enterText(colorPickerTextField, generateRandomHexColor());
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      var confirmButtonFinder4 =
          find.byKey(const ValueKey('ColorPickerConfirm'));
      await tester.tap(confirmButtonFinder4);
      await tester.pumpAndSettle();

      colorOption =
          find.byKey(const ValueKey('MakingQuizLayoutImageSetButton메인 색2'));
      await tester.tap(colorOption);
      await tester.pumpAndSettle();
      colorPickerTextField = find.byKey(const ValueKey('quizLayoutHexField'));
      await tester.enterText(colorPickerTextField, '');
      await tester.pumpAndSettle();
      await tester.enterText(colorPickerTextField, generateRandomHexColor());
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      confirmButtonFinder4 = find.byKey(const ValueKey('ColorPickerConfirm'));
      await tester.tap(confirmButtonFinder4);
      await tester.pumpAndSettle();

      colorOption =
          find.byKey(const ValueKey('MakingQuizLayoutImageSetButton메인 색3'));
      await tester.tap(colorOption);
      await tester.pumpAndSettle();
      colorPickerTextField = find.byKey(const ValueKey('quizLayoutHexField'));
      await tester.enterText(colorPickerTextField, '');
      await tester.pumpAndSettle();
      await tester.enterText(colorPickerTextField, generateRandomHexColor());
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      confirmButtonFinder4 = find.byKey(const ValueKey('ColorPickerConfirm'));
      await tester.tap(confirmButtonFinder4);
      await tester.pumpAndSettle();

      final colorReset = find
          .byKey(const ValueKey('MakingQuizLayoutColorSchemeRefreshButton'));
      await tester.tap(colorReset);
      await tester.pumpAndSettle(Durations.extralong4);

      final confirmButtonFinder5 = find.text('확인');
      await tester.tap(confirmButtonFinder5);
      await tester.pumpAndSettle();

      //기타 설정.
      final textButton3Finder =
          find.byKey(const ValueKey('MakingQuizLayoutCustomContainer3'));
      await tester.tap(textButton3Finder);
      await tester.pumpAndSettle();

      //TODO. 텍스트 설정에서 랜덤하게 수정하기.
      for (int i = 0; i < 3; i += 1) {
        final additionalSetupInkwell =
            find.byKey(ValueKey('quizLayoutAdditionalSetupInkWell$i'));
        await tester.tap(additionalSetupInkwell);
        await tester.pumpAndSettle();
        final randomInt1 = Random().nextInt(2);
        final randomInt2 = Random().nextInt(5);
        final randomInt3 = Random().nextInt(1);
        var fontFamily = find.byKey(
            ValueKey('additionalSetupNext${AppConfig.fontFamilys.length}'));
        var colorSetting = find.byKey(
            ValueKey('additionalSetupNext${AppConfig.colorStyles.length}'));
        var borderSetting = find.byKey(
            ValueKey('additionalSetupNext${AppConfig.borderType.length}'));
        for (int j = 0; j < randomInt1; j += 1) {
          await tester.tap(fontFamily);
          await tester.pumpAndSettle();
        }
        for (int j = 0; j < randomInt2; j += 1) {
          await tester.tap(colorSetting);
          await tester.pumpAndSettle();
        }
        for (int j = 0; j < randomInt3; j += 1) {
          await tester.tap(borderSetting);
          await tester.pumpAndSettle();
        }
        final closeButton = find.text('닫기');
        await tester.tap(closeButton);
        await tester.pumpAndSettle();
      }

      navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      await tester.tap(topBarToggle);
      await tester.pumpAndSettle();

      await tester.tap(bottomBarToggle);
      await tester.pumpAndSettle();

      //MakingQuiz로 넘어가기.
      final iconFinder = find.byIcon(Icons.arrow_forward);
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();

      //Quiz1 만들기.(추가 버튼 눌러서 만들고, 질문만 채우고 저장하기.) ->
      //더블탭 해서 수정해서 질문 만들기 -> 완료 -> 미리보기 -> 뒤로가기.
      //Quiz1,2는 이렇게 하고 3,4는 아래 버튼으로 하기.
      var addPageView0 = find.byKey(const ValueKey('makingQuizPageView0'));
      await tester.tap(addPageView0);
      await tester.pumpAndSettle();

      final quizSelection1 = find.byKey(const ValueKey('quizSelectionDialog0'));
      await tester.tap(quizSelection1);
      await tester.pumpAndSettle();

      var questionField =
          find.byKey(const ValueKey('QuizGeneratorQuestionField'));
      await tester.enterText(questionField, '테스트용 질문');
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      var confirmButtonFinder6 = find.text('완료');
      await tester.tap(confirmButtonFinder6);
      await tester.pumpAndSettle();

      var quiz1 = find.byKey(const ValueKey('makingQuizPageView0'));
      await doubleTap(tester, quiz1);
      await tester.pumpAndSettle();

      final addAnswer = find.byKey(const ValueKey('add_answer'));
      await tester.tap(addAnswer);
      await tester.pumpAndSettle();

      for (int i = 0; i < 6; i++) {
        final answerField = find.byKey(ValueKey('answer_textfield_$i'));
        await tester.ensureVisible(answerField);
        await tester.pumpAndSettle();
        await tester.enterText(answerField, '테스트용 답변 $i');
        await tester.pumpAndSettle();
      }
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      final deleteAnswer = find.byKey(const ValueKey('delete_answer_2'));
      await tester.ensureVisible(deleteAnswer);
      await tester.pumpAndSettle();
      await tester.tap(deleteAnswer);
      await tester.pumpAndSettle();

      final correctAnswerCheckBox =
          find.byKey(const ValueKey('answer_checkbox_0'));
      await tester.ensureVisible(correctAnswerCheckBox);
      await tester.pumpAndSettle();
      await tester.tap(correctAnswerCheckBox);
      await tester.pumpAndSettle();

      confirmButtonFinder6 = find.text('완료');
      await tester.tap(confirmButtonFinder6);
      await tester.pumpAndSettle();

      //Quiz2 만들기.

      var addQuizView1 = find.byKey(const ValueKey('makingQuizPageView1'));
      await tester.ensureVisible(addQuizView1);
      await tester.pumpAndSettle();
      await tester.tap(addQuizView1);
      await tester.pumpAndSettle();

      final quizSelection2 = find.byKey(const ValueKey('quizSelectionDialog1'));
      await tester.tap(quizSelection2);
      await tester.pumpAndSettle();

      questionField = find.byKey(const ValueKey('QuizGeneratorQuestionField'));
      await tester.enterText(questionField, '테스트용 질문');
      await tester.pumpAndSettle();

      final dropdownButton = find.byKey(const ValueKey('yearDropdown9999'));
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      final dropdownMenuItem = find.text('2019');
      await tester.tap(dropdownMenuItem);
      await tester.pumpAndSettle();

      final addAnswerButton = find.byKey(const ValueKey('add_answer_date'));
      await tester.tap(addAnswerButton);
      await tester.pumpAndSettle();
      await tester.tap(addAnswerButton);
      await tester.pumpAndSettle();

      final Finder deleteButton = find.byKey(const ValueKey('deleteButton1'));
      expect(deleteButton, findsWidgets);

      // Tap on the second widget with the duplicate key
      await tester.tap(deleteButton);
      await tester.pump(); // Trigger a frame

      confirmButtonFinder6 = find.text('완료');
      await tester.tap(confirmButtonFinder6);
      await tester.pumpAndSettle();

      //Quiz3 만들기.
      final addQuizButton = find.byKey(const ValueKey('addQuizButton'));
      await tester.tap(addQuizButton);
      await tester.pumpAndSettle();

      final quizSelection3 = find.byKey(const ValueKey('quizSelectionDialog2'));
      await tester.tap(quizSelection3);
      await tester.pumpAndSettle();

      questionField = find.byKey(const ValueKey('QuizGeneratorQuestionField'));
      await tester.enterText(questionField, '테스트용 질문');
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      final addAnswerButton2 = find.byKey(const ValueKey('addAnswerButton'));
      await tester.tap(addAnswerButton2);
      await tester.pumpAndSettle();
      await tester.tap(addAnswerButton2);
      await tester.pumpAndSettle();

      for (int i = 0; i < 5; i += 1) {
        final answerField = find.byKey(ValueKey(i));
        await tester.ensureVisible(answerField);
        await tester.pumpAndSettle();
        await tester.enterText(answerField, '테스트용 답변 $i');
        await tester.pumpAndSettle(Durations.extralong1);
      }

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      final deleteAnswer2 = find.byKey(const ValueKey('deleteIcon2'));
      await tester.ensureVisible(deleteAnswer2);
      await tester.pumpAndSettle();

      confirmButtonFinder6 = find.text('완료');
      await tester.tap(confirmButtonFinder6);
      await tester.pumpAndSettle();

      final editButton = find.byKey(const ValueKey('editQuizButton'));
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      confirmButtonFinder6 = find.text('완료');
      await tester.tap(confirmButtonFinder6);
      await tester.pumpAndSettle();

      //Quiz4 만들기.
      await tester.tap(addQuizButton);
      await tester.pumpAndSettle();

      final quizSelection4 = find.byKey(const ValueKey('quizSelectionDialog3'));
      await tester.tap(quizSelection4);
      await tester.pumpAndSettle();

      questionField = find.byKey(const ValueKey('QuizGeneratorQuestionField'));
      await tester.enterText(questionField, '테스트용 질문');
      await tester.pumpAndSettle();

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.

      final addAnswerButton3 = find.byKey(const ValueKey('addAnswerButton'));
      await tester.tap(addAnswerButton3);
      await tester.pumpAndSettle();
      await tester.tap(addAnswerButton3);
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; i += 1) {
        final dotRow = find.byKey(ValueKey('dots$i'));
        final firstChildFinder = find.descendant(
            of: dotRow,
            matching: find
                .byType(Container)).at(0); // Replace WidgetType with the actual type
        final secondChildFinder = find
            .descendant(of: dotRow, matching: find.byType(Container))
            .at(1); // Use .at(1) to get the second instance

        // Now, get the offsets of these children
        final Offset firstChildOffset = tester.getTopLeft(firstChildFinder);
        final Offset secondChildOffset = tester.getTopLeft(secondChildFinder);
        await tester.dragFrom(
            firstChildOffset, secondChildOffset - firstChildOffset);
        await tester.pumpAndSettle();
        final answerFieldLeft = find.byKey(ValueKey('answerLeft$i'));
        final answerFieldRight = find.byKey(ValueKey('answerRight$i'));
        await tester.enterText(answerFieldLeft, '테스트용 left $i');
        await tester.pumpAndSettle();
        await tester.enterText(answerFieldRight, '테스트용 right $i');
        await tester.pumpAndSettle();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle(); // 위젯 트리가 안정될 때까지 기다립니다.
      }

      final removeAnswerKey = find.byKey(const ValueKey('removeAnswerButton2'));
      await tester.tap(removeAnswerKey);
      await tester.pumpAndSettle();

      confirmButtonFinder6 = find.text('완료');
      await tester.tap(confirmButtonFinder6);
      await tester.pumpAndSettle();

      //하나 더 만들고 삭제버튼 누르기.
      await tester.tap(addQuizButton);
      await tester.pumpAndSettle();

      final quizSelection5 = find.byKey(const ValueKey('quizSelectionDialog3'));
      await tester.tap(quizSelection5);
      await tester.pumpAndSettle();

      confirmButtonFinder6 = find.text('완료');
      await tester.tap(confirmButtonFinder6);
      await tester.pumpAndSettle();

      final removeQuizButton = find.byKey(const ValueKey('deleteQuizButton'));
      await tester.tap(removeQuizButton);
      await tester.pumpAndSettle();

      final previewButton = find.byKey(const ValueKey('previewButton'));
      await tester.tap(previewButton);
      await tester.pumpAndSettle();

      final backButton = find.byKey(const ValueKey('solverBackbutton'));
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      final tempSave = find.byKey(const ValueKey('tempSaveButton'));
      await tester.tap(tempSave);
      await tester.pumpAndSettle();

      await tester.tap(fab);
      await tester.pumpAndSettle();
      await tester.tap(confirmButtonFinder);
      await tester.pumpAndSettle();

      final loadQuizLayoutButton =
          find.byKey(const ValueKey('loadQuizLayoutButton'));
      await tester.tap(loadQuizLayoutButton);
      await tester.pumpAndSettle();

      //TODO: 임시저장하고 나가기.

      //TODO: 임시저장한거 불러와서 업로드하기.
      final Completer<void> completer = Completer<void>();
      await completer.future; // This future never completes
    });
  });
}
