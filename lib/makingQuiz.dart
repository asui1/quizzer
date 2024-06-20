import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Widgets/FlipWidgets.dart';

import 'Class/quizLayout.dart';

class MakingQuiz extends StatefulWidget {
  final QuizLayout quizLayout;

  MakingQuiz({required this.quizLayout});

  @override
  _MakingQuizState createState() => _MakingQuizState();
}

class _MakingQuizState extends State<MakingQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.quizLayout.getIsTopBarVisible()
          ? PreferredSize(
              // 상단 바 추가
              preferredSize:
                  Size.fromHeight(widget.quizLayout.getAppBarHeight()),
              child: widget.quizLayout.getImage(1).isColor()
                  ? Container(
                      color: widget.quizLayout.getImage(1).getColor(),
                      height: widget.quizLayout.getAppBarHeight(),
                    )
                  : Container(
                      height: widget.quizLayout.getAppBarHeight(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              widget.quizLayout.getImage(1).getImagePath()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            )
          : null,
      body: Container(
        decoration: widget.quizLayout.getBackgroundImage().isColor()
            ? BoxDecoration(
                color: widget.quizLayout.getBackgroundImage().getColor(),
              )
            : BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      widget.quizLayout.getBackgroundImage().getImagePath()),
                  fit: BoxFit.cover,
                ),
              ),
        child: Stack(
          children: [
            FilpStyle12(
              quizLayout: widget.quizLayout,
              onPressedBack: () {},
              onPressedForward: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.quizLayout.getIsBottomBarVisible()
          ? PreferredSize(
              // 하단 바 추가
              preferredSize:
                  Size.fromHeight(widget.quizLayout.getBottomBarHeight()),
              child: widget.quizLayout.getImage(2).isColor()
                  ? Container(
                      color: widget.quizLayout.getImage(2).getColor(),
                      height: widget.quizLayout.getBottomBarHeight(),
                      child: BottomBarStack(
                          quizLayout: widget.quizLayout,
                          onPressedBack: () {},
                          onPressedForward: () {}),
                    )
                  : Container(
                      height: widget.quizLayout.getBottomBarHeight(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              widget.quizLayout.getImage(2).getImagePath()),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BottomBarStack(
                          quizLayout: widget.quizLayout,
                          onPressedBack: () {},
                          onPressedForward: () {}),
                    ),
            )
          : null,
    );
  }
}
