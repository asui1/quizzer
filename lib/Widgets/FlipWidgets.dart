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
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            child: FloatingActionButton(
              heroTag: 'prevButtonBody',
              backgroundColor: imageColor, // 하이라이트 여부에 따라 색상 변경
              child: Icon(Icons.arrow_back),
              onPressed: onPressedBack,
            ),
          ),
        ),
        Align(
          alignment:
              flipStyle == 2 ? Alignment.bottomRight : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            child: FloatingActionButton(
              heroTag: 'nextButtonBody',
              backgroundColor: imageColor, // 하이라이트 여부에 따라 색상 변경
              child: Icon(Icons.arrow_forward),
              onPressed: onPressedForward,
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
              padding: EdgeInsets.all(8.0), // Adjust the padding as needed
              child: FloatingActionButton(
                heroTag: 'prevButtonBottomBar',
                backgroundColor:
                    quizLayout.getButtonColor(), // 하이라이트 여부에 따라 색상 변경
                child: Icon(Icons.arrow_back),
                onPressed: onPressedBack,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(8.0), // Adjust the padding as needed
              child: FloatingActionButton(
                heroTag: 'nextButtonBottomBar',
                backgroundColor:
                    quizLayout.getButtonColor(), // 하이라이트 여부에 따라 색상 변경
                child: Icon(Icons.arrow_forward),
                onPressed: onPressedForward,
              ),
            ),
          ),
        },
      ],
    );
  }
}
