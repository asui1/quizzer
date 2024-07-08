import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart'; // Import the material.dart package
import 'package:path_provider/path_provider.dart';

import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Functions/colorGenerator.dart';
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
  ImageColor backgroundImage =
      ImageColor(color: Color.fromARGB(255, 255, 235, 244));
  ImageColor topBarImage =
      ImageColor(color: const Color.fromARGB(255, 186, 220, 248));
  ImageColor bottompBarImage =
      ImageColor(color: Color.fromARGB(255, 186, 220, 248));
  Color titleColor = Color.fromARGB(255, 0, 0, 0);
  Color bodyTextColor = Color.fromARGB(255, 0, 0, 0);
  Color textColor = Color.fromARGB(255, 0, 0, 0);
  Color buttonColor = Color.fromARGB(255, 122, 79, 202);
  Color borderColor1 = Color.fromARGB(255, 130, 23, 192);
  Color borderColor2 = Color.fromARGB(255, 192, 156, 224);
  Color selectedColor = Color.fromARGB(255, 211, 175, 214);
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
      color: textColor,
      fontFamily: answerFont,
      fontSize: AppConfig.fontSize,
    );
  }

  Future<void> loadQuizLayout(dynamic inputJson) async {
    print(inputJson);
    Map<String, dynamic> inputData = inputJson as Map<String, dynamic>;
    print(inputData['isTopBarVisible']);
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
    if (inputData['bottompBarImage'] != null) {
      bottompBarImage = ImageColor().fromJson(inputData['bottompBarImage']);
    }
    if (inputData['titleColor'] != null) {
      titleColor = Color(inputData['titleColor'] as int);
      print(titleColor);
    }
    if (inputData['bodyTextColor'] != null) {
      bodyTextColor = Color(inputData['bodyTextColor'] as int);
    }
    if (inputData['textColor'] != null) {
      textColor = Color(inputData['textColor'] as int);
    }
    if (inputData['buttonColor'] != null) {
      buttonColor = Color(inputData['buttonColor'] as int);
    }
    if (inputData['borderColor1'] != null) {
      borderColor1 = Color(inputData['borderColor1'] as int);
    }
    if (inputData['borderColor2'] != null) {
      borderColor2 = Color(inputData['borderColor2'] as int);
    }
    if (inputData['selectedColor'] != null) {
      selectedColor = Color(inputData['selectedColor'] as int);
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
  }

  Color getTitleColor() {
    return titleColor;
  }

  Color getBodyTextColor() {
    return bodyTextColor;
  }

  Color getSelectedColor() {
    return selectedColor;
  }

  String getQuestionFont() {
    return questionFont;
  }

  String getBodyFont() {
    return bodyFont;
  }

  String getAnswerFont() {
    return answerFont;
  }

  Color getBorderColor1() {
    return borderColor1;
  }

  Color getBorderColor2() {
    return borderColor2;
  }

  Color getTextColorByIndex(index) {
    if (index == 0) {
      return titleColor;
    } else if (index == 1) {
      return bodyTextColor;
    } else if (index == 2) {
      return textColor;
    }

    return textColor;
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
      'backgroundImage': backgroundImage.toJson(),
      'topBarImage': topBarImage.toJson(),
      'bottompBarImage': bottompBarImage.toJson(),
      'titleColor': titleColor.value,
      'bodyTextColor': bodyTextColor.value,
      'textColor': textColor.value,
      'buttonColor': buttonColor.value,
      'borderColor1': borderColor1.value,
      'borderColor2': borderColor2.value,
      'selectedColor': selectedColor.value,
      'shuffleQuestions': shuffleQuestions,
      'title': title,
      'titleImageSet': titleImageSet,
      'questionFont': questionFont,
      'bodyFont': bodyFont,
      'answerFont': answerFont,
      'titleImagePath': titleImagePath,
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

  Color getButtonColor() {
    return buttonColor;
  }

  Color getTextColor() {
    return textColor;
  }

  ImageColor getBackgroundImage() {
    return backgroundImage;
  }

  void setBackgroundImage(ImageColor image) {
    backgroundImage = image;
  }

  ImageColor getTopBarImage() {
    return topBarImage;
  }

  void setTopBarImage(ImageColor image) {
    topBarImage = image;
  }

  ImageColor getBottomBarImage() {
    return bottompBarImage;
  }

  void setBottomBarImage(ImageColor image) {
    bottompBarImage = image;
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
    Color backgroundColorMain = await backgroundImage.getMainColor() as Color;
    print(backgroundColorMain);
    ColorSchemeGenerator colorSchemeGenerator =
        ColorSchemeGenerator(backgroundColorMain);
    titleColor = colorSchemeGenerator.getStandingOutColor();
    bodyTextColor = colorSchemeGenerator.getStandingOutColor();
    textColor = colorSchemeGenerator.getStandingOutColor();
    buttonColor = colorSchemeGenerator.getStandingOutColor();
    borderColor1 = colorSchemeGenerator.getSimilarColor();
    selectedColor = colorSchemeGenerator.getStandingOutColor();
    borderColor2 = colorSchemeGenerator.getSimilarColor();
    //TODO: I want to generate color similar to background color for border Colors, contrast colors for button color and selected color.
  }

  ImageColor getImage(int index) {
    if (index == 0) {
      return backgroundImage;
    } else if (index == 1) {
      return topBarImage;
    } else if (index == 2) {
      return bottompBarImage;
    } else if (index == 3) {
      return ImageColor(color: titleColor);
    } else if (index == 4) {
      return ImageColor(color: bodyTextColor);
    } else if (index == 5) {
      return ImageColor(color: textColor);
    } else if (index == 6) {
      return ImageColor(color: buttonColor);
    } else if (index == 7) {
      return ImageColor(color: borderColor1);
    } else if (index == 8) {
      return ImageColor(color: borderColor2);
    } else if (index == 9) {
      return ImageColor(color: selectedColor);
    }

    return topBarImage;
  }

  Color getColor(int index) {
    if (index == 3) {
      return titleColor;
    } else if (index == 4) {
      return bodyTextColor;
    } else if (index == 5) {
      return textColor;
    } else if (index == 6) {
      return buttonColor;
    } else if (index == 7) {
      return borderColor1;
    } else if (index == 8) {
      return borderColor2;
    } else if (index == 9) {
      return selectedColor;
    }
    return titleColor;
  }

  void setColor(int index, Color color) {
    if (index == 3) {
      titleColor = color;
    } else if (index == 4) {
      bodyTextColor = color;
    } else if (index == 5) {
      textColor = color;
    } else if (index == 6) {
      buttonColor = color;
    } else if (index == 7) {
      borderColor1 = color;
    } else if (index == 8) {
      borderColor2 = color;
    } else if (index == 9) {
      selectedColor = color;
    }
  }

  void setImage(int index, ImageColor image) {
    if (index == 0) {
      backgroundImage = image;
    } else if (index == 1) {
      topBarImage = image;
    } else if (index == 2) {
      bottompBarImage = image;
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
    if(isTopBarVisible == false) {
      return 0.0;
    }
    return appBarHeight;
  }

  void setAppBarHeight(double height) {
    appBarHeight = height;
  }

  double getBottomBarHeight() {
    if(isBottomBarVisible == false) {
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

    if (backgroundImage.isColor() == false) {
      futures.add(copyImage(backgroundImage.imagePath!,
              '${directory.path}/$uuid-backgroundImage.png')
          .then((newPath) => backgroundImage.setImage(newPath)));
    }
    if (topBarImage.isColor() == false) {
      futures.add(copyImage(
              topBarImage.imagePath!, '${directory.path}/$uuid-topBarImage.png')
          .then((newPath) => topBarImage.setImage(newPath)));
    }
    if (bottompBarImage.isColor() == false) {
      futures.add(copyImage(bottompBarImage.imagePath!,
              '${directory.path}/$uuid-bottomBarImage.png')
          .then((newPath) => bottompBarImage.setImage(newPath)));
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
    print("saved as : ${json}");
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
