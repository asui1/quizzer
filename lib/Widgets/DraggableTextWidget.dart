import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Class/scoreCard.dart';
import 'package:quizzer/Setup/config.dart';
import 'dart:math' as math;

class DraggableTextWidget extends StatefulWidget {
  ScoreCard scoreCard;
  double parentWidth;
  double parentHeight;

  DraggableTextWidget(
      {required this.scoreCard,
      required this.parentWidth,
      required this.parentHeight});

  @override
  _DraggableTextWidgetState createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  @override
  Widget build(BuildContext context) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);
    double relativeSize = widget.scoreCard.getSize();
    double xRatio = widget.scoreCard.getXRatio();
    double yRatio = widget.scoreCard.getYRatio();
    double shortestSide = math.min(widget.parentWidth, widget.parentHeight);

    // 부모 크기에 상대적인 위치와 크기 계산
    double size = shortestSide * relativeSize;
    Offset position =
        Offset(widget.parentWidth * xRatio, widget.parentHeight * yRatio);

    return Container(
      width: size,
      height: size,
      child: ClipRect(
        // ClipRect 추가
        child: Stack(
          children: [
            Positioned(
              left: position.dx - size / 2 + 10,
              top: position.dy - size / 2 + 10,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    widget.scoreCard.updateXRatio(
                        (position.dx + details.delta.dx) / widget.parentWidth);
                    widget.scoreCard.updateYRatio(
                        (position.dy + details.delta.dy) / widget.parentHeight);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Keep the container transparent
                    border: Border.all(
                      color: Colors.black, // Set border color
                      width: 2.0, // Set border width
                    ),
                  ),
                  child: Text(
                    '90',
                    style: TextStyle(
                      fontSize: size / 2,
                      fontWeight: FontWeight.w800,
                      color: quizLayout.getColorScheme().error,
                      fontFamily: MyFonts.ongleYunu,
                    ),
                  ),
                ),
              ),
            ),
            // Top-left corner for resizing
            Positioned(
              left: position.dx - size / 2,
              top: position.dy - size / 2,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    relativeSize =
                        (relativeSize - details.delta.dy / shortestSide);
                    widget.scoreCard.updateSize(relativeSize);
                  });
                },
                child: _buildDragPoint(quizLayout),
              ),
            ),
            Positioned(
              left: position.dx + size / 2,
              top: position.dy - size / 2,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    relativeSize =
                        (relativeSize - details.delta.dy / shortestSide);
                    widget.scoreCard.updateSize(relativeSize);
                  });
                },
                child: _buildDragPoint(quizLayout),
              ),
            ),
            Positioned(
              left: position.dx - size / 2,
              top: position.dy + size / 2,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    relativeSize =
                        (relativeSize + details.delta.dy / shortestSide);
                    widget.scoreCard.updateSize(relativeSize);
                  });
                },
                child: _buildDragPoint(quizLayout),
              ),
            ),
            Positioned(
              left: position.dx + size / 2,
              top: position.dy + size / 2,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    relativeSize =
                        (relativeSize + details.delta.dy / shortestSide);
                    widget.scoreCard.updateSize(relativeSize);
                  });
                },
                child: _buildDragPoint(quizLayout),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragPoint(QuizLayout quizLayout) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: quizLayout.getColorScheme().error,
        shape: BoxShape.circle,
      ),
    );
  }
}
