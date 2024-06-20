
import 'package:flutter/material.dart'; // Import the material.dart package

import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quiz.dart';

class QuizLayout {
  bool isTopBarVisible = false;
  bool isBottomBarVisible = false;
  double appBarHeight = 50.0;
  double bottomBarHeight = 50.0;
  int highlightedIndex = 0;
  int selectedLayout = 0;
  List<Quiz> quizzes = [];
  bool isFlipStyleSet = false;
  bool isBackgroundImageSet = false;
  bool isWidgetSizeSet = false;
  ImageColor backgroundImage = ImageColor(color: Colors.white);
  ImageColor topBarImage = ImageColor(color: Colors.blue[200]);
  ImageColor bottompBarImage = ImageColor(color: Colors.blue[200]);
  ImageColor titleColor = ImageColor(color: Colors.black);
  ImageColor textColor = ImageColor(color: Colors.black);
  ImageColor buttonColor = ImageColor(color: Color.fromARGB(255, 180, 147, 243));

  QuizLayout({this.highlightedIndex = 0});

  ImageColor getButtonColor() {
    return buttonColor;
  }

  ImageColor getTextColor() {
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
      if(index < 6 && index > 2){
        return true;
      }
    return false;
  }

  ImageColor getImage(int index){
    if(index == 0){
      return backgroundImage;
    } else if(index == 1){
      return topBarImage;
    } else if(index == 2){
      return bottompBarImage;
    }
    else if(index == 3){
      return titleColor;
    }
    else if(index == 4){
      return textColor;
    }
    else if(index == 5){
      return buttonColor;
    }
    return topBarImage;
  }

  void setImage(int index, ImageColor image){
    if(index == 0){
      backgroundImage = image;
    } else if(index == 1){
      topBarImage = image;
    } else if(index == 2){
      bottompBarImage = image;
    } else if(index == 3){
      titleColor = image;
    } else if(index == 4){
      textColor = image;
    } else if(index == 5){
      buttonColor = image;
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
    if(!isFlipStyleSet) {
      highlightedIndex = 0;
      return highlightedIndex;
    }
    if(!isBackgroundImageSet) {
      highlightedIndex = 1;
      return highlightedIndex;
    }
    if(!isWidgetSizeSet) {
      highlightedIndex = 2;
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
