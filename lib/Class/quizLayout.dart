import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart'; // Import the material.dart package
import 'package:flutter/widgets.dart';
import 'package:material_theme_builder/material_theme_builder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Functions/colorGenerator.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:uuid/uuid.dart';

class QuizLayout {
  bool isTopBarVisible = false;
  bool isBottomBarVisible = false;
  double appBarHeight = 75.0;
  double bottomBarHeight = 50.0;
  int highlightedIndex = 0;
  int selectedLayout = 0;
  List<AbstractQuiz> quizzes = [];
  int curQuizIndex = 0;
  bool isTitleSet = false;
  bool isFlipStyleSet = false;
  bool isBackgroundImageSet = false;
  bool isWidgetSizeSet = false;
  ColorScheme colorScheme = deepCopyColorScheme(MyLightColorScheme);

  ImageColor? backgroundImage = null;
  ImageColor? topBarImage =
      ImageColor(color: const Color.fromARGB(255, 186, 220, 248));
  ImageColor? bottomBarImage =
      ImageColor(color: Color.fromARGB(255, 186, 220, 248));

  bool shuffleQuestions = false;
  String title = '';
  String questionFont = MyFonts.gothicA1Bold;
  String bodyFont = MyFonts.gothicA1ExtraBold;
  String answerFont = MyFonts.gothicA1;
  String titleImagePath = 'assets/images/question2.png';
  bool titleImageSet = false;

  QuizLayout({this.highlightedIndex = 0});

  TextStyle getAnswerTextStyle() {
    return TextStyle(
      fontFamily: answerFont,
      fontSize: AppConfig.fontSize,
      color: colorScheme.secondary,
    );
  }

  TextStyle getBodyTextStyle() {
    return TextStyle(
      fontFamily: bodyFont,
      fontSize: AppConfig.fontSize,
      color: colorScheme.tertiary,
    );
  }

  TextStyle getTitleStyle() {
    return TextStyle(
      fontFamily: questionFont,
      fontSize: AppConfig.fontSize * 1.3,
      color: colorScheme.primary,
    );
  }

  int getScore() {
    int score = 0;

    int n = quizzes.length;
    int baseScore = 100 ~/ n; // Integer division to get the base score
    int leftovers = 100 % n; // Remainder to be distributed

    // Initial distribution of scores
    List<int> scores = List<int>.filled(n, baseScore);

    // Distribute leftovers to the quizzes at the end
    for (int i = n - leftovers; i < n; i++) {
      scores[i] += 1;
    }

    // Iterate through quizzes and adjust scores based on quiz.check()
    for (int i = 0; i < n; i++) {
      print(quizzes[i].check());
      if (quizzes[i].check()) {
        score += scores[i];
      }
    }
    return score;
  }

  Future<void> loadQuizLayout(dynamic inputJson) async {
    Map<String, dynamic> inputData = inputJson as Map<String, dynamic>;
    if (inputData['isTopBarVisible'] != null) {
      isTopBarVisible = inputData['isTopBarVisible'];
    }
    if (inputData['isBottomBarVisible'] != null) {
      isBottomBarVisible = inputData['isBottomBarVisible'];
    }
    if (inputData['appBarHeight'] != null) {
      appBarHeight = inputData['appBarHeight'];
    }
    if (inputData['bottomBarHeight'] != null) {
      bottomBarHeight = inputData['bottomBarHeight'];
    }
    if (inputData['highlightedIndex'] != null) {
      highlightedIndex = inputData['highlightedIndex'];
    }
    if (inputData['selectedLayout'] != null) {
      selectedLayout = inputData['selectedLayout'];
    }
    if (inputData['quizzes'] != null) {
      for (var quiz in inputData['quizzes']) {
        if (quiz['layoutType'] == 1) {
          quizzes.add(
              Quiz1(answers: [], ans: [], question: "").loadQuiz(quiz["body"]));
        } else if (quiz['layoutType'] == 2) {
          quizzes.add(
              Quiz2(answers: [], ans: [], question: "", maxAnswerSelection: 1)
                  .loadQuiz(quiz["body"]));
        } else if (quiz['layoutType'] == 3) {
          quizzes.add(
              Quiz3(answers: [], ans: [], question: "").loadQuiz(quiz["body"]));
        } else if (quiz['layoutType'] == 4) {
          quizzes.add(
              Quiz4(answers: [], ans: [], question: "").loadQuiz(quiz["body"]));
        }
      }
    }
    if (inputData['curQuizIndex'] != null) {
      curQuizIndex = inputData['curQuizIndex'];
    }
    if (inputData['isTitleSet'] != null) {
      isTitleSet = inputData['isTitleSet'];
    }
    if (inputData['isFlipStyleSet'] != null) {
      isFlipStyleSet = inputData['isFlipStyleSet'];
    }
    if (inputData['isBackgroundImageSet'] != null) {
      isBackgroundImageSet = inputData['isBackgroundImageSet'];
    }
    if (inputData['isWidgetSizeSet'] != null) {
      isWidgetSizeSet = inputData['isWidgetSizeSet'];
    }
    if (inputData['backgroundImage'] != null) {
      backgroundImage = ImageColor().fromJson(inputData['backgroundImage']);
    }
    if (inputData['topBarImage'] != null) {
      topBarImage = ImageColor().fromJson(inputData['topBarImage']);
    }
    if (inputData['bottomBarImage'] != null) {
      bottomBarImage = ImageColor().fromJson(inputData['bottomBarImage']);
    }
    if (inputData['shuffleQuestions'] != null) {
      shuffleQuestions = inputData['shuffleQuestions'];
    }
    if (inputData['title'] != null) {
      title = inputData['title'];
    }
    if (inputData['questionFont'] != null) {
      questionFont = inputData['questionFont'];
    }
    if (inputData['bodyFont'] != null) {
      bodyFont = inputData['bodyFont'];
    }
    if (inputData['answerFont'] != null) {
      answerFont = inputData['answerFont'];
    }
    if (inputData['titleImagePath'] != null) {
      titleImagePath = inputData['titleImagePath'];
    }
    if (inputData['titleImageSet'] != null) {
      titleImageSet = inputData['titleImageSet'];
    }
    if (inputData['colorScheme'] != null) {
      colorScheme = jsonToColorScheme(inputData['colorScheme']);
    }
  }

  void setFontFamily(int index, String fontFamily) {
    if (index == 0) {
      questionFont = fontFamily;
    } else if (index == 1) {
      bodyFont = fontFamily;
    } else if (index == 2) {
      answerFont = fontFamily;
    }
  }

  String generateUuid() {
    // 현재 시간을 밀리초 단위로 가져와 제목과 결합합니다.
    String name = '$title-${DateTime.now().millisecondsSinceEpoch}';

    // v5 UUID를 생성합니다.
    var uuid = Uuid();
    String generatedUuid = uuid.v5(Uuid.NAMESPACE_URL, name);

    return generatedUuid;
  }

  String getQuestionFont() {
    return questionFont;
  }

  String getFontFamily(int index) {
    if (index == 0) {
      return questionFont;
    } else if (index == 1) {
      return bodyFont;
    } else if (index == 2) {
      return answerFont;
    }
    return questionFont;
  }

  String getAnswerFont() {
    return answerFont;
  }

  String getBodyFont() {
    return bodyFont;
  }

  bool isTitleImageSet() {
    return titleImageSet;
  }

  void setTitle(String newTitle) {
    title = newTitle;
  }

  String getTitle() {
    return title;
  }

  void setTitleImage(String path) {
    titleImagePath = path;
    titleImageSet = true;
  }

  void setIsTitleSet(bool value) {
    isTitleSet = value;
  }

  Image getTitleImage() {
    return Image.file(File(titleImagePath));
  }

  Map<String, dynamic> toJson() {
    return {
      'isTopBarVisible': isTopBarVisible,
      'isBottomBarVisible': isBottomBarVisible,
      'appBarHeight': appBarHeight,
      'bottomBarHeight': bottomBarHeight,
      'highlightedIndex': highlightedIndex,
      'selectedLayout': selectedLayout,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
      'curQuizIndex': curQuizIndex,
      'isTitleSet': isTitleSet,
      'isFlipStyleSet': isFlipStyleSet,
      'isBackgroundImageSet': isBackgroundImageSet,
      'isWidgetSizeSet': isWidgetSizeSet,
      'backgroundImage': backgroundImage?.toJson(),
      'topBarImage': topBarImage?.toJson(),
      'bottomBarImage': bottomBarImage?.toJson(),
      'shuffleQuestions': shuffleQuestions,
      'title': title,
      'titleImageSet': titleImageSet,
      'questionFont': questionFont,
      'bodyFont': bodyFont,
      'answerFont': answerFont,
      'titleImagePath': titleImagePath,
      'colorScheme': colorSchemeToJson(colorScheme),
    };
  }

  void flipShuffleQuestions() {
    shuffleQuestions = !shuffleQuestions;
  }

  void setShuffleQuestions(bool value) {
    shuffleQuestions = value;
  }

  bool getShuffleQuestions() {
    return shuffleQuestions;
  }

  void addQuizAt(AbstractQuiz quiz, int index) {
    if (index > quizzes.length) {
      quizzes.add(quiz);
      return;
    }
    quizzes.insert(index, quiz);
  }

  void addQuiz(AbstractQuiz quiz) {
    quizzes.add(quiz);
  }

  AbstractQuiz getQuiz(int index) {
    return quizzes[index];
  }

  void removeQuiz(int index) {
    quizzes.removeAt(index);
  }

  int getQuizCount() {
    return quizzes.length;
  }

  int getCurQuizIndex() {
    return curQuizIndex;
  }

  ImageColor? getBackgroundImage() {
    return backgroundImage;
  }

  void setBackgroundImage(ImageColor image) {
    backgroundImage = image;
  }

  ImageColor? getTopBarImage() {
    return topBarImage;
  }

  void setTopBarImage(ImageColor image) {
    topBarImage = image;
  }

  ImageColor? getBottomBarImage() {
    return bottomBarImage;
  }

  void setBottomBarImage(ImageColor image) {
    bottomBarImage = image;
  }

  bool getIsTopBarVisible() {
    return isTopBarVisible;
  }

  bool getIsBottomBarVisible() {
    return isBottomBarVisible;
  }

  void toggleTopBarVisibility() {
    isTopBarVisible = !isTopBarVisible;
  }

  void toggleBottomBarVisibility() {
    isBottomBarVisible = !isBottomBarVisible;
  }

  bool getVisibility(int index) {
    if (index == 0) {
      return true;
    } else if (index == 1) {
      return isTopBarVisible;
    } else if (index == 2) {
      return isBottomBarVisible;
    }
    return true;
  }

  Future<void> generateAdequateColors() async {
    Color backgroundColorMain;
    if (backgroundImage == null) {
      backgroundColorMain = colorScheme.surface;
    } else {
      backgroundColorMain = await backgroundImage!.getMainColor() as Color;
    }
    MaterialThemeBuilder temp = MaterialThemeBuilder(
      primary: colorScheme.primary,
      secondary: colorScheme.secondary,
      tertiary: colorScheme.tertiary,
      neutral: backgroundColorMain,
    );
    colorScheme = temp.toScheme();
  }

  ImageColor getImageColorNotNull(int index) {
    if (index == 1) {
      if (topBarImage == null) {
        return ImageColor(color: colorScheme.primary);
      } else {
        return topBarImage!;
      }
    } else if (index == 2) {
      if (bottomBarImage == null) {
        return ImageColor(color: colorScheme.primary);
      } else {
        return bottomBarImage!;
      }
    } else if (index == 3) {
      return ImageColor(color: colorScheme.primary);
    } else if (index == 4) {
      return ImageColor(color: colorScheme.secondary);
    } else if (index == 5) {
      return ImageColor(color: colorScheme.tertiary);
    } else if (index == 6) {
      return ImageColor(color: colorScheme.primaryContainer);
    } else if (index == 7) {
      return ImageColor(color: colorScheme.secondaryContainer);
    } else if (index == 8) {
      return ImageColor(color: colorScheme.tertiaryContainer);
    } else if (index == 9) {
      return ImageColor(color: colorScheme.error);
    } else {
      if (backgroundImage == null) {
        return ImageColor(color: colorScheme.surface);
      } else {
        return backgroundImage!;
      }
    }
  }

  Color getColor(int index) {
    if (index == 3) {
      return colorScheme.primary;
    } else if (index == 4) {
      return colorScheme.secondary;
    } else if (index == 5) {
      return colorScheme.tertiary;
    } else if (index == 6) {
      return colorScheme.primaryContainer;
    } else if (index == 7) {
      return colorScheme.secondaryContainer;
    } else if (index == 8) {
      return colorScheme.tertiaryContainer;
    } else if (index == 9) {
      return colorScheme.error;
    } else {
      return colorScheme.surface;
    }
  }

  void setColor(int index, Color color) {
    if (index == 3) {
      colorScheme = updatePrimaryColorUsingCopyWith(colorScheme, color);
    } else if (index == 4) {
      colorScheme = updateSecondaryColorUsingCopyWith(colorScheme, color);
    } else if (index == 5) {
      colorScheme = updateTertiaryColorUsingCopyWith(colorScheme, color);
    } else if (index == 6) {
      colorScheme =
          updatePrimaryContainerColorUsingCopyWith(colorScheme, color);
    } else if (index == 7) {
      colorScheme =
          updateSecondaryContainerColorUsingCopyWith(colorScheme, color);
    } else if (index == 8) {
      colorScheme =
          updateTertiaryContainerColorUsingCopyWith(colorScheme, color);
    } else if (index == 9) {
      colorScheme = updateErrorColorUsingCopyWith(colorScheme, color);
    } else if (index == 10) {
      colorScheme = updateOnErrorColorUsingCopyWith(colorScheme, color);
    }
  }

  ColorScheme getColorScheme() {
    return colorScheme;
  }

  ImageColor? getImage(int index) {
    if (index == 0) {
      return backgroundImage;
    } else if (index == 1) {
      return topBarImage;
    } else if (index == 2) {
      return bottomBarImage;
    }

    return topBarImage;
  }

  void setImage(int index, ImageColor image) {
    if (index == 0) {
      backgroundImage = image;
    } else if (index == 1) {
      topBarImage = image;
    } else if (index == 2) {
      bottomBarImage = image;
    }
  }

  bool getIsFlipStyleSet() {
    return isFlipStyleSet;
  }

  void setIsFlipStyleSet(bool value) {
    isFlipStyleSet = value;
  }

  bool getIsBackgroundImageSet() {
    return isBackgroundImageSet;
  }

  void setIsBackgroundImageSet(bool value) {
    isBackgroundImageSet = value;
  }

  bool getIsWidgetSizeSet() {
    return isWidgetSizeSet;
  }

  void setIsWidgetSizeSet(bool value) {
    isWidgetSizeSet = value;
  }

  int getNextHighlightedIndex() {
    if (!isTitleSet) {
      highlightedIndex = 0;
      return highlightedIndex;
    }
    if (!isFlipStyleSet) {
      highlightedIndex = 1;
      return highlightedIndex;
    }
    if (!isBackgroundImageSet) {
      highlightedIndex = 2;
      return highlightedIndex;
    }
    if (!isWidgetSizeSet) {
      highlightedIndex = 3;
      return highlightedIndex;
    }
    return 0;
  }

  bool getTopBarVisibility() {
    return isTopBarVisible;
  }

  void setTopBarVisibility(bool visibility) {
    isTopBarVisible = visibility;
  }

  bool getBottomBarVisibility() {
    return isBottomBarVisible;
  }

  void setBottomBarVisibility(bool visibility) {
    isBottomBarVisible = visibility;
  }

  double getAppBarHeight() {
    if (isTopBarVisible == false) {
      return 0.0;
    }
    return appBarHeight;
  }

  void setAppBarHeight(double height) {
    appBarHeight = height;
  }

  double getBottomBarHeight() {
    if (isBottomBarVisible == false) {
      return 0.0;
    }
    return bottomBarHeight;
  }

  void setBottomBarHeight(double height) {
    bottomBarHeight = height;
  }

  int getHighlightedIndex() {
    return highlightedIndex;
  }

  void setHighlightedIndex(int index) {
    highlightedIndex = index;
  }

  int getSelectedLayout() {
    return selectedLayout;
  }

  void setSelectedLayout(int layout) {
    selectedLayout = layout;
  }

  Future<void> saveQuizLayout() async {
    String uuid = generateUuid();
    final directory = await getApplicationDocumentsDirectory();
    List<Future> futures = [];

    if (backgroundImage != null && backgroundImage!.isColor() == false) {
      futures.add(copyImage(backgroundImage!.imagePath!,
              '${directory.path}/$uuid-backgroundImage.png')
          .then((newPath) => backgroundImage!.setImage(newPath)));
    }
    if (topBarImage != null && topBarImage!.isColor() == false) {
      futures.add(copyImage(topBarImage!.imagePath!,
              '${directory.path}/$uuid-topBarImage.png')
          .then((newPath) => topBarImage!.setImage(newPath)));
    }
    if (bottomBarImage != null && bottomBarImage!.isColor() == false) {
      futures.add(copyImage(bottomBarImage!.imagePath!,
              '${directory.path}/$uuid-bottomBarImage.png')
          .then((newPath) => bottomBarImage!.setImage(newPath)));
    }
    if (titleImageSet == true) {
      futures.add(
          copyImage(titleImagePath, '${directory.path}/$uuid-titleImage.png')
              .then((newPath) => titleImagePath = newPath));
    }

    // 모든 이미지 복사 작업이 완료될 때까지 기다립니다.
    await Future.wait(futures);

    //toJSON() 메서드를 사용하여 QuizLayout 객체를 JSON 형식으로 변환합니다.
    Map<String, dynamic> json = toJson();
    // 문서 디렉토리의 경로를 얻습니다.
    // JSON 파일을 저장할 경로를 생성합니다.
    final file = File('${directory.path}/$uuid.json');

    // JSON 데이터를 문자열로 변환하고 파일에 씁니다.
    await file.writeAsString(jsonEncode(json));
    // 이미지들 전부 이름을 바꾸어 저장합니다.
  }

  copyImage(String s, String t) {
    return File(s).copy(t).then((_) => t);
  }
}
