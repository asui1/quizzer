import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Strings.dart';
import 'package:quizzer/additionalSetup.dart';
import 'package:quizzer/config.dart';

import 'Widgets/FlipWidgets.dart';
import 'makingQuiz.dart';
import 'myColorPicker.dart';

class MakingQuizscreen extends StatefulWidget {
  final QuizLayout quizLayout;

  MakingQuizscreen({required this.quizLayout});

  @override
  State<StatefulWidget> createState() => _MakingQuizState();
}

class _MakingQuizState extends State<MakingQuizscreen> {
  double tempAppBarHeight = 30.0;
  double tempBottomBarHeight = 30.0;

  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the current title
    _titleController =
        TextEditingController(text: widget.quizLayout.getTitle());
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextScaler scaleFactor = MediaQuery.of(context).textScaler;
    int highlightedIndex = widget.quizLayout.getNextHighlightedIndex();
    if (widget.quizLayout.getSelectedLayout() == 0) {
      highlightedIndex = 0;
    }
    if (widget.quizLayout.getSelectedLayout() == 3) {
      widget.quizLayout.setBottomBarVisibility(true);
    }
    return Scaffold(
      appBar: widget.quizLayout.getIsTopBarVisible()
          ? PreferredSize(
              // 상단 바 추가
              preferredSize:
                  Size.fromHeight(widget.quizLayout.getAppBarHeight()),
              child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    tempAppBarHeight +=
                        details.delta.dy; // 드래그 이벤트에 따라 하단 바의 높이를 변경
                    tempAppBarHeight = tempAppBarHeight.clamp(
                        MediaQuery.of(context).size.height / 40,
                        MediaQuery.of(context).size.height /
                            4); // 화면 높이의 1/4로 제한
                    widget.quizLayout.setAppBarHeight(tempAppBarHeight);
                  });
                },
                child: widget.quizLayout.getImage(1).isColor()
                    ? Container(
                        color: widget.quizLayout.getImage(1).getColor(),
                        height: widget.quizLayout.getAppBarHeight(),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Icon(Icons.drag_handle,
                                color: Colors.white), // Add this line
                          ],
                        ),
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
              onPressedForward: () =>
                  navigateToMakingQuizPage(context, widget.quizLayout),
            ),
            Positioned(
              top: 30.0,
              left: MediaQuery.of(context).size.width / 2 -
                  28, // Subtract half the width of the button to center it
              child: FloatingActionButton(
                heroTag: 'topBarToggle',
                backgroundColor: Colors.blue.withOpacity(0.5),
                child: Icon(widget.quizLayout.getIsTopBarVisible()
                    ? Icons.remove
                    : Icons.add),
                onPressed: () {
                  setState(() {
                    widget.quizLayout.toggleTopBarVisibility();
                  });
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomContainer(
                    text: '1. 퀴즈 제목 설정.',
                    quizLayout: widget.quizLayout,
                    index: 0,
                    onPressed: () async {
                      final layoutSelected = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(// Add this
                              builder:
                                  (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Center(child: Text('퀴즈 제목 설정')),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    height: AppConfig.screenHeight * 0.02,
                                  ),
                                  TextField(
                                    controller:
                                        _titleController, // Bind the controller to the TextField
                                    decoration: InputDecoration(
                                      labelText: '퀴즈 제목을 입력하세요.',
                                    ),
                                    onChanged: (value) {
                                      // Optionally update the title in real-time
                                      widget.quizLayout.setTitle(value);
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(
                                    height: AppConfig.screenHeight * 0.02,
                                  ),
                                  Text('표지 이미지를 선택하세요:'),
                                  SizedBox(
                                    height: AppConfig.screenHeight * 0.02,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final ImagePicker _picker = ImagePicker();
                                      final XFile? tempImageFile =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      if (tempImageFile != null) {
                                        // 이미지 파일 처리
                                        setState(() {
                                          widget.quizLayout.setTitleImage(
                                              Image.file(
                                                  File(tempImageFile.path)));
                                        });
                                      }
                                      // Handle user upload with image picker
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .transparent, // Border color
                                          width: 2.0, // Border width
                                        ),
                                      ),
                                      width: AppConfig.screenWidth / 3,
                                      height: AppConfig.screenWidth /
                                          3, // 가로 크기를 기준으로 정사각형 크기 설정
                                      child: widget.quizLayout.isTitleImageSet()
                                          ? widget.quizLayout.getTitleImage()
                                          : Icon(Icons.add_a_photo,
                                              size: AppConfig.screenWidth / 3),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppConfig.screenHeight * 0.02,
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                ConfirmButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        widget.quizLayout.getSelectedLayout());
                                  },
                                  selection: widget.quizLayout.getTitle() == ''
                                      ? 0
                                      : 1,
                                ),
                              ],
                            );
                          });
                        },
                      );
                      setState(() {
                        widget.quizLayout.setIsTitleSet(true);
                        highlightedIndex =
                            widget.quizLayout.getNextHighlightedIndex();
                      });
                    },
                  ),
                  CustomContainer(
                    text: '2. 넘기기 스타일 설정.',
                    quizLayout: widget.quizLayout,
                    index: 1,
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
                                          quizLayout: widget.quizLayout,
                                          onSelected: (layoutNumber) {
                                            setState(() {
                                              widget.quizLayout
                                                  .setSelectedLayout(
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
                                    Navigator.of(context).pop(
                                        widget.quizLayout.getSelectedLayout());
                                  },
                                  selection:
                                      widget.quizLayout.getSelectedLayout(),
                                ),
                              ],
                            );
                          });
                        },
                      );
                      if (widget.quizLayout.getSelectedLayout() != 0) {
                        {
                          setState(() {
                            widget.quizLayout.setIsFlipStyleSet(true);
                            highlightedIndex =
                                widget.quizLayout.getNextHighlightedIndex();
                          });
                        }
                      }
                    },
                  ),
                  CustomContainer(
                    text: '3. 배경/색상 설정.',
                    quizLayout: widget.quizLayout,
                    index: 2,
                    onPressed: () async {
                      final layoutSelected = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(// Add this
                              builder:
                                  (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Center(child: Text('배경/색상 설정')),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Column(
                                      children: List.generate(9, (index) {
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
                                                    quizLayout:
                                                        widget.quizLayout,
                                                    index: index,
                                                  );
                                                },
                                              );

                                              if (selectedColor != null) {
                                                setState(() {});
                                              }
                                            },
                                            isActive: widget.quizLayout
                                                .getVisibility(index),
                                            quizLayout: widget.quizLayout,
                                            buttonText: stringResources[
                                                    'imageSet$index'] ??
                                                '',
                                            image: widget.quizLayout
                                                .getImage(index),
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
                      if (widget.quizLayout.getSelectedLayout() != 0) {
                        {
                          setState(() {
                            widget.quizLayout.setIsBackgroundImageSet(true);
                            highlightedIndex =
                                widget.quizLayout.getNextHighlightedIndex();
                          });
                        }
                      }
                    },
                  ),
                  CustomContainer(
                    text: '4. 기타 추가 설정.',
                    quizLayout: widget.quizLayout,
                    index: 3,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              quizLayoutAdditionalSetup(quizLayout: widget.quizLayout),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
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
                child: Icon(widget.quizLayout.getIsBottomBarVisible()
                    ? Icons.remove
                    : Icons.add),
                onPressed: () {
                  setState(() {
                    widget.quizLayout.toggleBottomBarVisibility();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.quizLayout.getIsBottomBarVisible()
          ? PreferredSize(
              // 하단 바 추가
              preferredSize:
                  Size.fromHeight(widget.quizLayout.getBottomBarHeight()),
              child: GestureDetector(
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    setState(() {
                      tempBottomBarHeight -=
                          details.delta.dy; // 드래그 이벤트에 따라 하단 바의 높이를 변경
                      tempBottomBarHeight = tempBottomBarHeight.clamp(
                          MediaQuery.of(context).size.height / 40,
                          MediaQuery.of(context).size.height /
                              4); // 화면 높이의 1/4로 제한
                      widget.quizLayout.setBottomBarHeight(tempBottomBarHeight);
                    });
                  },
                  child: widget.quizLayout.getImage(2).isColor()
                      ? Container(
                          color: widget.quizLayout.getImage(2).getColor(),
                          height: widget.quizLayout.getBottomBarHeight(),
                          child: BottomBarStack(
                            quizLayout: widget.quizLayout,
                            onPressedBack: () {},
                            onPressedForward: () => navigateToMakingQuizPage(
                                context, widget.quizLayout),
                          ),
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
                            onPressedForward: () => navigateToMakingQuizPage(
                                context, widget.quizLayout),
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
          width: AppConfig.screenWidth / 5,
          fit: BoxFit.fitWidth,
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
      height: MediaQuery.of(context).size.height / 16,
      width: MediaQuery.of(context).size.width * 0.6,
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
