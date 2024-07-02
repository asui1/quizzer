import 'package:flutter/material.dart'; // Import the material.dart package

import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/config.dart';

class QuizLayout {
  bool isTopBarVisible = false;
  bool isBottomBarVisible = false;
  double appBarHeight = 50.0;
  double bottomBarHeight = 50.0;
  int highlightedIndex = 0;
  int selectedLayout = 0;
  List<AbstractQuiz> quizzes = [];
  int curQuizIndex = 0;
  bool isTitleSet = false;
  bool isFlipStyleSet = false;
  bool isBackgroundImageSet = false;
  bool isWidgetSizeSet = false;
  ImageColor backgroundImage = ImageColor(color: Color.fromARGB(255, 245, 197, 219));
  ImageColor topBarImage = ImageColor(color: Colors.blue[200]);
  ImageColor bottompBarImage = ImageColor(color: Colors.blue[200]);
  Color titleColor = Color.fromARGB(255, 236, 207, 207);
  Color bodyTextColor = Color.fromARGB(255, 253, 250, 75);
  Color textColor = Color.fromARGB(255, 131, 238, 104);
  Color buttonColor = Color.fromARGB(255, 207, 194, 231);
  Color borderColor1 = Color.fromARGB(255, 172, 98, 214);
  Color borderColor2 = Color.fromARGB(255, 94, 236, 255);
  Color selectedColor = Color.fromARGB(255, 120, 153, 184);
  bool shuffleQuestions = false;
  String title = '';
  Image titleImage = Image.asset('images/question2.png');
  bool titleImageSet = false;
  String questionFont = MyFonts.gothicA1Bold;
  String bodyFont = MyFonts.gothicA1ExtraBold;
  String answerFont = MyFonts.gothicA1;

  QuizLayout({this.highlightedIndex = 0});

  TextStyle getAnswerTextStyle(){
    return TextStyle(
      color: textColor,
      fontFamily: answerFont,
      fontSize: AppConfig.fontSize,
    );
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

  void setTitleImage(Image image) {
    titleImage = image;
    titleImageSet = true;
  }

  void setIsTitleSet(bool value) {
    isTitleSet = value;
  }

  Image getTitleImage() {
    return titleImage;
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
      'isFlipStyleSet': isFlipStyleSet,
      'isBackgroundImageSet': isBackgroundImageSet,
      'isWidgetSizeSet': isWidgetSizeSet,
      'backgroundImage': backgroundImage.toJson(),
      'topBarImage': topBarImage.toJson(),
      'bottompBarImage': bottompBarImage.toJson(),
      'titleColor': titleColor,
      'textColor': textColor,
      'buttonColor': buttonColor,
      'shuffleQuestions': shuffleQuestions,
      'title': title,
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
    } else if(index ==5){
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
    } else if(index == 4){
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
    return appBarHeight;
  }

  void setAppBarHeight(double height) {
    appBarHeight = height;
  }

  double getBottomBarHeight() {
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
}
