import 'package:dotted_border/dotted_border.dart';
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
    double screenShortestSide = MediaQuery.of(context).size.shortestSide;
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
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            print("Drag update: ${details.delta.dx}");
            // Update the position of the widget here
          },
          child: Stack(
            children: [
              FilpStyle12(
                quizLayout: widget.quizLayout,
                onPressedBack: () {},
                onPressedForward: () {},
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0), // Adjust the value as needed
                  child: Text(
                    '${widget.quizLayout.getCurQuizIndex()} / ${widget.quizLayout.getQuizCount()}',
                    style: TextStyle(
                      fontSize: 36, // Adjust as needed
                      color: Colors.black, // Adjust as needed
                    ),
                  ),
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      0.1 * screenShortestSide), // Adjust as needed
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                width: double.maxFinite,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  children: List.generate(8, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, 'Item $index');
                                      },
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 3,
                                              child: Image.asset(
                                                  'images/one.jpg',
                                                  fit: BoxFit.cover),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text('Item $index'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        ).then((value) {
                          print('User selected: $value');
                          setState(() {
                            
                          });
                        });

                        print("Tap update");
                        // Handle tap event here
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(
                            0.1 * screenShortestSide), // Adjust as needed
                        padding: EdgeInsets.all(
                            0.05 * screenShortestSide), // Adjust as needed
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(12)), // Adjust as needed
                          child: Container(
                            width: 0.7 * screenShortestSide, // Adjust as needed
                            height:
                                0.7 * screenShortestSide, // Adjust as needed
                            color: Colors.transparent, // Adjust as needed
                            child: Icon(
                              Icons.add,
                              size: 0.7 * screenShortestSide,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
