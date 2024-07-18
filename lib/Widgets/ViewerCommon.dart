import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';

class QuestionViewer extends StatelessWidget {
  final String question;
  final double fontSizeModifier;
  final QuizLayout quizLayout;

  QuestionViewer(
      {required this.question,
      this.fontSizeModifier = 1,
      required this.quizLayout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConfig.screenWidth * fontSizeModifier, // 너비를 화면 너비의 80%로 설정
      child: TextStyleWidget(
        textStyle: quizLayout.getTextStyle(0),
        text: question,
        colorScheme: quizLayout.getColorScheme(),
        modifier: fontSizeModifier,
      ),
    );
  }
}

BoxDecoration backgroundDecoration({required QuizLayout quizLayout}) {
  ImageColor? backgroundImage = quizLayout.getImage(0);
  return backgroundImage == null
      ? BoxDecoration(
          color: quizLayout.getColorScheme().surface,
        )
      : backgroundImage.isColor()
          ? BoxDecoration(
              color: backgroundImage.getColor(),
            )
          : BoxDecoration(
              image: DecorationImage(
                image: Image.file(File(backgroundImage.getImagePath())).image,
                fit: BoxFit.cover,
              ),
            );
}

BoxDecoration backgroundDecorationWithBorder(
    {required QuizLayout quizLayout, Color? color = null}) {
  if (color != null) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30), // 모서리 둥글기
      boxShadow: [
        BoxShadow(
          color: quizLayout.getColorScheme().outline.withOpacity(0.5), // 그림자 색상
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3), // 그림자 위치 조정
        ),
      ],
    );
  }
  ImageColor? backgroundImage = quizLayout.getImage(0);
  return backgroundImage == null
      ? BoxDecoration(
          color: quizLayout.getColorScheme().surface,
          borderRadius: BorderRadius.circular(30), // 모서리 둥글기
          boxShadow: [
            BoxShadow(
              color: quizLayout
                  .getColorScheme()
                  .outline
                  .withOpacity(0.5), // 그림자 색상
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // 그림자 위치 조정
            ),
          ],
        )
      : backgroundImage.isColor()
          ? BoxDecoration(
              color: backgroundImage.getColor(),
              borderRadius: BorderRadius.circular(30), // 모서리 둥글기
              boxShadow: [
                BoxShadow(
                  color: quizLayout
                      .getColorScheme()
                      .outline
                      .withOpacity(0.5), // 그림자 색상
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // 그림자 위치 조정
                ),
              ],
            )
          : BoxDecoration(
              image: DecorationImage(
                image: Image.file(File(backgroundImage.getImagePath())).image,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(30), // 모서리 둥글기
              boxShadow: [
                BoxShadow(
                  color: quizLayout
                      .getColorScheme()
                      .outline
                      .withOpacity(0.5), // 그림자 색상
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // 그림자 위치 조정
                ),
              ],
            );
}

Widget setValueRow(List parent, int selectedValue, void Function()? prev,
    void Function()? next, bool isColor, List<int> styleSet, QuizLayout quizLayout) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: AppConfig.padding),
    height: AppConfig.screenHeight * 0.05,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: prev,
        ),
        Container(
          alignment: Alignment.center,
          width: AppConfig.screenWidth * 0.4,
          child: isColor
              ? TextStyleWidget(
                  textStyle: styleSet,
                  text: parent[selectedValue],
                  colorScheme: quizLayout.getColorScheme(),
                )
              : Text(parent[selectedValue]),
        ),
        IconButton(
          key: ValueKey('additionalSetupNext${parent.length}'),
          icon: Icon(Icons.arrow_right),
          onPressed: next,
        ),
      ],
    ),
  );
}

PreferredSizeWidget? viewerAppBar(
    {required QuizLayout quizLayout, required bool showDragHandle}) {
  ImageColor? topBarImage = quizLayout.getImage(1);
  return quizLayout.getIsTopBarVisible()
      ? PreferredSize(
          // 상단 바 추가
          preferredSize: Size.fromHeight(quizLayout.getAppBarHeight()),
          child: topBarImage == null
              ? Container(
                  height: quizLayout.getAppBarHeight(),
                  child: showDragHandle
                      ? Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Icon(Icons.drag_handle), // Add this line
                          ],
                        )
                      : null,
                )
              : topBarImage!.isColor()
                  ? Container(
                      color: topBarImage!.getColor(),
                      height: quizLayout.getAppBarHeight(),
                      child: showDragHandle
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Icon(Icons.drag_handle), // Add this line
                              ],
                            )
                          : null,
                    )
                  : Container(
                      height: quizLayout.getAppBarHeight(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.file(File(
                            topBarImage!.getImagePath(),
                          )).image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: showDragHandle
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Icon(Icons.drag_handle), // Add this line
                              ],
                            )
                          : null,
                    ),
        )
      : null;
}

Widget? viewerBottomBar({
  required QuizLayout quizLayout,
  required void Function() onPressedForward,
  required void Function() onPressedBack,
  required bool showDragHandle,
  required bool showSwitchButton,
}) {
  ImageColor? bottomBarImage = quizLayout.getImage(2);
  return quizLayout.getIsBottomBarVisible()
      ? PreferredSize(
          // 하단 바 추가
          preferredSize: Size.fromHeight(quizLayout.getBottomBarHeight()),
          child: bottomBarImage == null
              ? Container(
                  height: quizLayout.getBottomBarHeight(),
                  child: BottomBarStack(
                    quizLayout: quizLayout,
                    onPressedBack: onPressedBack,
                    onPressedForward: onPressedForward,
                    showDragHandle: showDragHandle,
                    showSwitchButton: showSwitchButton,
                  ),
                )
              : bottomBarImage!.isColor()
                  ? Container(
                      color: bottomBarImage!.getColor(),
                      height: quizLayout.getBottomBarHeight(),
                      child: BottomBarStack(
                        quizLayout: quizLayout,
                        onPressedBack: onPressedBack,
                        onPressedForward: onPressedForward,
                        showDragHandle: showDragHandle,
                        showSwitchButton: showSwitchButton,
                      ),
                    )
                  : Container(
                      height: quizLayout.getBottomBarHeight(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.file(
                            File(bottomBarImage!.getImagePath()),
                          ).image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: BottomBarStack(
                        quizLayout: quizLayout,
                        onPressedBack: onPressedBack,
                        onPressedForward: onPressedForward,
                        showDragHandle: showDragHandle,
                        showSwitchButton: showSwitchButton,
                      ),
                    ),
        )
      : null;
}
