import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: quizLayout.getColorScheme().onSurface, // 밑줄 색상 설정
            width: 2.0, // 밑줄 두께 설정
          ),
        ),
      ),
      child: Text(
        question,
        textAlign: TextAlign.left,
        style: quizLayout.getTitleStyle(),
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
