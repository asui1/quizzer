import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Class/ImageColor.dart';
import '../Class/quizLayout.dart';

class FilpStyle12 extends StatelessWidget {
  final QuizLayout quizLayout;
  final VoidCallback onPressedBack;
  final VoidCallback onPressedForward;

  FilpStyle12(
      {required this.quizLayout,
      required this.onPressedBack,
      required this.onPressedForward});

  @override
  Widget build(BuildContext context) {
    Color imageColor = quizLayout.getButtonColor();
    int flipStyle = quizLayout.getSelectedLayout();
    Color textColor = quizLayout.getTextColor();
    if (flipStyle != 1 && flipStyle != 2) {
      return SizedBox.shrink(); // or Container()
    }
    Widget child = Stack(
      children: <Widget>[
        Align(
          alignment:
              flipStyle == 2 ? Alignment.bottomLeft : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(5.0), // Adjust the padding as needed
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.transparent, // Container의 배경색을 투명하게 설정
                borderRadius: BorderRadius.circular(10.0), // 둥근 모서리 반경 설정
                border: Border.all(
                  color: quizLayout.getButtonColor(), // 테두리 색상 설정
                  width: 2.0, // 테두리 두께 설정
                ),
              ),
              child: Align(
                // IconButton을 중앙에 위치시키기 위해 Align 위젯 사용
                alignment: Alignment.center, // 중앙 정렬
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, size: 15.0),
                  onPressed: onPressedBack,
                  color: quizLayout.getButtonColor(),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment:
              flipStyle == 2 ? Alignment.bottomRight : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(5.0), // Adjust the padding as needed
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.transparent, // Container의 배경색을 투명하게 설정
                borderRadius: BorderRadius.circular(10.0), // 둥근 모서리 반경 설정
                border: Border.all(
                  color: quizLayout.getButtonColor(), // 테두리 색상 설정
                  width: 2.0, // 테두리 두께 설정
                ),
              ),
              child: Align(
                // IconButton을 중앙에 위치시키기 위해 Align 위젯 사용
                alignment: Alignment.center, // 중앙 정렬
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios_rounded, size: 15.0),
                  onPressed: onPressedForward,
                  color: quizLayout.getButtonColor(),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return flipStyle == 2
        ? Padding(padding: EdgeInsets.only(bottom: 8.0), child: child)
        : child;
  }
}

class BottomBarStack extends StatelessWidget {
  final QuizLayout quizLayout;
  final VoidCallback onPressedBack;
  final VoidCallback onPressedForward;
  final bool showDragHandle;

  BottomBarStack(
      {required this.quizLayout,
      required this.onPressedBack,
      required this.onPressedForward,
      this.showDragHandle = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        if (showDragHandle) Icon(Icons.drag_handle, color: Colors.white),
        if (quizLayout.getSelectedLayout() == 3) ...{
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(5.0), // Adjust the padding as needed
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 15.0),
                onPressed: onPressedBack,
                color: quizLayout.getButtonColor(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(5.0), // Adjust the padding as needed
              child: IconButton(
                icon: Icon(Icons.arrow_forward, size: 15.0),
                onPressed: onPressedForward,
                color: quizLayout.getButtonColor(),
              ),
            ),
          ),
        },
      ],
    );
  }
}
