import 'package:flutter/cupertino.dart';
import 'package:quizzer/Class/quizLayout.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';

class ScoreCard {
  double size;
  Offset position;
  int imageState = 0;
  BoxDecoration? backgroundImage;

  ScoreCard({
    required this.size,
    required this.position,
    required this.backgroundImage,
    this.imageState = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'dx': position.dx,
      'dy': position.dy,
      'imageState': imageState,
    };
  }

  Color getColorByState(QuizLayout quizLayout, int state) {
    if (state == 1) {
      return quizLayout.getColorScheme().primary;
    } else if (state == 2) {
      return quizLayout.getColorScheme().secondary;
    } else if (state == 3) {
      return quizLayout.getColorScheme().tertiary;
    } else if (state == 4) {
      return quizLayout.getColorScheme().primaryContainer;
    } else if (state == 5) {
      return quizLayout.getColorScheme().secondaryContainer;
    } else if (state == 6) {
      return quizLayout.getColorScheme().tertiaryContainer;
    } else {
      return quizLayout.getColorScheme().surface;
    }
  }

  void fromJson(Map<String, dynamic> json) {
    size = json['size'];
    position = Offset(json['dx'], json['dy']);
    imageState = json['imageState'];
  }

  void initbackGroundImage(QuizLayout quizLayout) {
    if (backgroundImage != null) return;
    if (imageState == 0) {
      backgroundImage = backgroundDecorationWithBorder(quizLayout: quizLayout);
    } else {
      backgroundImage = backgroundDecorationWithBorder(
          quizLayout: quizLayout,
          color: getColorByState(quizLayout, imageState));
    }
  }

  void updatePosition(Offset newPosition) {
    position = newPosition;
  }

  Offset getPosition() {
    return position;
  }

  void updateSize(double newSize) {
    size = newSize;
  }

  double getSize() {
    return size;
  }

  void updateBackgroundImage(BoxDecoration newBackgroundImage) {
    backgroundImage = newBackgroundImage;
  }

  BoxDecoration getBackgroundImage() {
    return backgroundImage!;
  }

  void nextBackgroundColor(QuizLayout quizLayout) {
    if (imageState == 0) {
      backgroundImage = backgroundDecorationWithBorder(
          quizLayout: quizLayout, color: quizLayout.getColorScheme().primary);
      imageState = 1;
    } else if (imageState == 1) {
      backgroundImage = backgroundDecorationWithBorder(
          quizLayout: quizLayout, color: quizLayout.getColorScheme().secondary);
      imageState = 2;
    } else if (imageState == 2) {
      backgroundImage = backgroundDecorationWithBorder(
          quizLayout: quizLayout, color: quizLayout.getColorScheme().tertiary);
      imageState = 3;
    } else if (imageState == 3) {
      backgroundImage = backgroundDecorationWithBorder(
          quizLayout: quizLayout,
          color: quizLayout.getColorScheme().primaryContainer);
      imageState = 4;
    } else if (imageState == 4) {
      backgroundImage = backgroundDecorationWithBorder(
          quizLayout: quizLayout,
          color: quizLayout.getColorScheme().secondaryContainer);
      imageState = 5;
    } else if (imageState == 5) {
      backgroundImage = backgroundDecorationWithBorder(
          quizLayout: quizLayout,
          color: quizLayout.getColorScheme().tertiaryContainer);
      imageState = 6;
    } else if (imageState == 6) {
      backgroundImage = backgroundDecorationWithBorder(quizLayout: quizLayout);
      imageState = 0;
    }
  }
}
