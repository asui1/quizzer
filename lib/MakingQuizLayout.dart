import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Strings.dart';

import 'Widgets/FlipWidgets.dart';
import 'makingQuiz.dart';
import 'myColorPicker.dart';

class MakingQuizscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MakingQuizState();
}

class _MakingQuizState extends State<MakingQuizscreen> {
  QuizLayout quizLayout = QuizLayout();
  double tempAppBarHeight = 30.0;
  double tempBottomBarHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    TextScaler scaleFactor = MediaQuery.of(context).textScaler;
    int highlightedIndex = quizLayout.getNextHighlightedIndex();
    if (quizLayout.getSelectedLayout() == 0) {
      highlightedIndex = 0;
    }
    if (quizLayout.getSelectedLayout() == 3) {
      quizLayout.setBottomBarVisibility(true);
    }
    return Scaffold(
      appBar: quizLayout.getIsTopBarVisible()
          ? PreferredSize(
              // 상단 바 추가
              preferredSize: Size.fromHeight(quizLayout.getAppBarHeight()),
              child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    tempAppBarHeight +=
                        details.delta.dy; // 드래그 이벤트에 따라 하단 바의 높이를 변경
                    tempAppBarHeight = tempAppBarHeight.clamp(
                        MediaQuery.of(context).size.height / 40,
                        MediaQuery.of(context).size.height /
                            4); // 화면 높이의 1/4로 제한
                    quizLayout.setAppBarHeight(tempAppBarHeight);
                  });
                },
                child: quizLayout.getImage(1).isColor()
                    ? Container(
                        color: quizLayout.getImage(1).getColor(),
                        height: quizLayout.getAppBarHeight(),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Icon(Icons.drag_handle,
                                color: Colors.white), // Add this line
                          ],
                        ),
                      )
                    : Container(
                        height: quizLayout.getAppBarHeight(),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                quizLayout.getImage(1).getImagePath()),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Icon(Icons.drag_handle,
                                color: Colors.white), // Add this line
                          ],
                        ),
                      ),
              ),
            )
          : null,
      body: Container(
        decoration: quizLayout.getBackgroundImage().isColor()
            ? BoxDecoration(
                color: quizLayout.getBackgroundImage().getColor(),
              )
            : BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      quizLayout.getBackgroundImage().getImagePath()),
                  fit: BoxFit.cover,
                ),
              ),
        child: Stack(
          children: [
            FilpStyle12(
                quizLayout: quizLayout,
                onPressedBack: () {},
                onPressedForward: () => navigateToMakingQuizPage(context, quizLayout),
            ),
            Positioned(
              top: 30.0,
              left: MediaQuery.of(context).size.width / 2 -
                  28, // Subtract half the width of the button to center it
              child: FloatingActionButton(
                heroTag: 'topBarToggle',
                backgroundColor: Colors.blue.withOpacity(0.5),
                child: Icon(
                    quizLayout.getIsTopBarVisible() ? Icons.remove : Icons.add),
                onPressed: () {
                  setState(() {
                    quizLayout.toggleTopBarVisibility();
                  });
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomContainer(
                    text: '1. 넘기기 스타일 설정.',
                    quizLayout: quizLayout,
                    index: 0,
                    onPressed: () async {
                      final layoutSelected = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(// Add this
                              builder:
                                  (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Center(child: Text('넘기기 스타일 설정')),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(3, (index) {
                                        return LayoutOption(
                                          layoutNumber: index + 1,
                                          quizLayout: quizLayout,
                                          onSelected: (layoutNumber) {
                                            setState(() {
                                              quizLayout.setSelectedLayout(
                                                  layoutNumber);
                                            });
                                          },
                                          imagePath:
                                              'images/layoutOption${index + 1}.jpg',
                                        );
                                      }),
                                    ),
                                    // 필요한 만큼 더 많은 이미지를 추가할 수 있습니다.
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                ConfirmButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(quizLayout
                                        .getSelectedLayout());
                                  },
                                  selection: quizLayout.getSelectedLayout(),
                                ),
                              ],
                            );
                          });
                        },
                      );
                      if (quizLayout.getSelectedLayout() != 0) {
                        {
                          setState(() {
                            quizLayout.setIsFlipStyleSet(true);
                            highlightedIndex =
                                quizLayout.getNextHighlightedIndex();
                          });
                        }
                      }
                    },
                  ),
                  CustomContainer(
                    text: '2. 베경/색상 설정.',
                    quizLayout: quizLayout,
                    index: 1,
                    onPressed: () async {
                      final layoutSelected = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(// Add this
                              builder:
                                  (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Center(child: Text('베경/색상 설정')),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Column(
                                      children: List.generate(6, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  8.0), // Adjust the value as needed
                                          child: CustomRow(
                                            onPressed: () async {
                                              // Show color picker
                                              final selectedColor =
                                                  await showDialog<Color>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ColorPickerField(
                                                    quizLayout: quizLayout,
                                                    index: index,
                                                  );
                                                },
                                              );

                                              if (selectedColor != null) {
                                                setState(() {});
                                              }
                                            },
                                            isActive:
                                                quizLayout.getVisibility(index),
                                            quizLayout: quizLayout,
                                            buttonText: stringResources[
                                                    'imageSet$index'] ??
                                                '',
                                            image: quizLayout.getImage(index),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                ConfirmButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(1);
                                  },
                                  selection: 1,
                                ),
                              ],
                            );
                          });
                        },
                      ).then((_) {
                        setState(() {});
                      });
                      if (quizLayout.getSelectedLayout() != 0) {
                        {
                          setState(() {
                            quizLayout.setIsBackgroundImageSet(true);
                            highlightedIndex =
                                quizLayout.getNextHighlightedIndex();
                          });
                        }
                      }
                    },
                  ),
                  CustomContainer(
                    text: '3. 위젯 크기 설정.',
                    quizLayout: quizLayout,
                    index: 2,
                    onPressed: () async {
                      // 버튼 3의 동작을 여기에 구현합니다.
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30.0,
              left: MediaQuery.of(context).size.width / 2 -
                  28, // Subtract half the width of the button to center it
              child: FloatingActionButton(
                heroTag: 'bottomBarToggle',
                backgroundColor: Colors.blue.withOpacity(0.5),
                child: Icon(quizLayout.getIsBottomBarVisible()
                    ? Icons.remove
                    : Icons.add),
                onPressed: () {
                  setState(() {
                    quizLayout.toggleBottomBarVisibility();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: quizLayout.getIsBottomBarVisible()
          ? PreferredSize(
              // 하단 바 추가
              preferredSize: Size.fromHeight(quizLayout.getBottomBarHeight()),
              child: GestureDetector(
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    setState(() {
                      tempBottomBarHeight -=
                          details.delta.dy; // 드래그 이벤트에 따라 하단 바의 높이를 변경
                      tempBottomBarHeight = tempBottomBarHeight.clamp(
                          MediaQuery.of(context).size.height / 40,
                          MediaQuery.of(context).size.height /
                              4); // 화면 높이의 1/4로 제한
                      quizLayout.setBottomBarHeight(tempBottomBarHeight);
                    });
                  },
                  child: quizLayout.getImage(2).isColor()
                      ? Container(
                          color: quizLayout.getImage(2).getColor(),
                          height: quizLayout.getBottomBarHeight(),
                          child: BottomBarStack(quizLayout: quizLayout,
                onPressedBack: () {},
                onPressedForward: () => navigateToMakingQuizPage(context, quizLayout),
                          ),
                        )
                      : Container(
                          height: quizLayout.getBottomBarHeight(),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  quizLayout.getImage(2).getImagePath()),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: BottomBarStack(quizLayout: quizLayout,
                                          onPressedBack: () {},
                onPressedForward: () => navigateToMakingQuizPage(context, quizLayout),
),
                        )),
            )
          : null,
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int selection;

  ConfirmButton({required this.onPressed, required this.selection});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('확인'),
      onPressed: selection == 0 ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: selection == 0 ? Colors.grey : Colors.blue,
      ),
    );
  }
}

class LayoutOption extends StatelessWidget {
  final int layoutNumber;
  final QuizLayout quizLayout;
  final ValueChanged<int> onSelected;
  final String imagePath;

  LayoutOption({
    required this.layoutNumber,
    required this.quizLayout,
    required this.onSelected,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: quizLayout.getSelectedLayout() == layoutNumber
            ? Colors.blue
            : Colors.transparent,
      ),
      child: GestureDetector(
        child: Image(
          image: AssetImage(imagePath),
          width: 200,
          height: 320,
          fit: BoxFit.fitHeight,
        ),
        onTap: () {
          onSelected(layoutNumber);
        },
      ),
    );
  }
}

class ImageSetButton extends StatelessWidget {
  final String buttonText;
  final ImageColor imageAsset;
  final VoidCallback onPressed;

  ImageSetButton({
    required this.buttonText,
    required this.imageAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              buttonText,
              textAlign: TextAlign.left,
            ),
            imageAsset.getImage(50, 50),
          ],
        ),
      ),
    );
  }
}

class WidgetStateColor extends Color {
  final Color activeColor;
  final Color inactiveColor;

  WidgetStateColor({required this.activeColor, required this.inactiveColor})
      : super(0);

  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return activeColor;
    }
    return inactiveColor;
  }
}

class CustomContainer extends StatelessWidget {
  final String text;
  final QuizLayout quizLayout;
  final Function onPressed;
  final int index;

  CustomContainer(
      {required this.text,
      required this.quizLayout,
      required this.onPressed,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      width: MediaQuery.of(context).size.width / 3,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: quizLayout.getNextHighlightedIndex() == index
              ? Colors.blue
              : Colors.black,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final VoidCallback onPressed;
  final QuizLayout quizLayout;
  final bool isActive;
  final String buttonText;
  final ImageColor image;

  CustomRow(
      {required this.onPressed,
      required this.isActive,
      required this.quizLayout,
      required this.buttonText,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ImageSetButton(
                buttonText: buttonText,
                imageAsset: image,
                onPressed: onPressed,
              ),
            ],
          )
        : Container();
  }
}

void navigateToMakingQuizPage(BuildContext context, QuizLayout quizLayout) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MakingQuiz(quizLayout: quizLayout),
    ),
  );
}
