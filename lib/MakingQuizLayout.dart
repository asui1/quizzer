import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/fileSaveLoad.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Setup/Strings.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/additionalSetup.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/loadTemp.dart';

import 'Widgets/FlipWidgets.dart';
import 'makingQuiz.dart';
import 'Widgets/myColorPicker.dart';

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
  ColorScheme colorScheme;

  _MakingQuizState() : colorScheme = MyLightColorScheme;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the current title
    _titleController =
        TextEditingController(text: widget.quizLayout.getTitle());
  }

  void changeColorScheme(ColorScheme newScheme) {
    setState(() {
      colorScheme = newScheme; // Step 3: Update the ColorScheme
    });
  }

  void updateLoad() {
    _titleController.text = widget.quizLayout.getTitle();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int highlightedIndex = widget.quizLayout.getNextHighlightedIndex();
    if (widget.quizLayout.getSelectedLayout() == 0) {
      highlightedIndex = 0;
    }
    if (widget.quizLayout.getSelectedLayout() == 3) {
      widget.quizLayout.setBottomBarVisibility(true);
    }
    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: Scaffold(
        extendBodyBehindAppBar: false,
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
                          AppConfig.screenHeight * 0.075,
                          AppConfig.screenHeight / 4); // 화면 높이의 1/4로 제한
                      widget.quizLayout.setAppBarHeight(tempAppBarHeight);
                    });
                  },
                  child: viewerAppBar(
                      quizLayout: widget.quizLayout, showDragHandle: true),
                ),
              )
            : null,
        body: SafeArea(
          child: Container(
            decoration: backgroundDecoration(quizLayout: widget.quizLayout),
            child: Stack(
              children: [
                FilpStyle12(
                  quizLayout: widget.quizLayout,
                  onPressedBack: () {},
                  onPressedForward: () {},
                ),
                Positioned(
                  top: 30.0,
                  left: AppConfig.screenWidth / 2 -
                      28, // Subtract half the width of the button to center it
                  child: FloatingActionButton(
                    foregroundColor: widget.quizLayout.getColorScheme().primary,
                    heroTag: 'topBarToggle',
                    child: Icon(
                      widget.quizLayout.getIsTopBarVisible()
                          ? Icons.remove
                          : Icons.add,
                      color: widget.quizLayout.getColorScheme().onPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.quizLayout.toggleTopBarVisibility();
                      });
                    },
                  ),
                ),
                Positioned(
                  top: 0.0, // Set to 0.0 to align at the top
                  left: 0.0, // Set to 0.0 to align at the left
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: widget.quizLayout.getColorScheme().primary),
                    onPressed: () {
                      Navigator.pop(
                          context); // Pops the current route from the navigator to get out of the page
                    },
                  ),
                ),
                Positioned(
                  right: 0.0, // Align to the right
                  bottom: 0.0, // Align to the bottom
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward,
                        color: widget.quizLayout.getColorScheme().primary),
                    onPressed: () =>
                        navigateToMakingQuizPage(context, widget.quizLayout),
                  ),
                ),
                Positioned(
                  right: 0.0, // Align to the right
                  top: 0.0, // Align to the top
                  child: IconButton(
                    icon: Icon(Icons.download_sharp,
                        color: widget.quizLayout.getColorScheme().primary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoadTemp(quizLayout: widget.quizLayout),
                        ),
                      ).then((_) {
                        updateLoad();
                        setState(() {});
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
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      '퀴즈 제목 설정',
                                      style: widget.quizLayout.getTitleStyle(),
                                    ),
                                  ),
                                  backgroundColor: widget.quizLayout
                                      .getColorScheme()
                                      .surface,
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
                                      Text(
                                        '표지 이미지를 선택하세요:',
                                        style: widget.quizLayout
                                            .getAnswerTextStyle(),
                                      ),
                                      SizedBox(
                                        height: AppConfig.screenHeight * 0.02,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final ImagePicker _picker =
                                              ImagePicker();
                                          final XFile? tempImageFile =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (tempImageFile != null) {
                                            // 이미지 파일 처리
                                            final File? compressedFile =
                                                await checkCompressImage(
                                                    tempImageFile, 50, 50);

                                            if (compressedFile != null) {
                                              setState(() {
                                                widget.quizLayout.setTitleImage(
                                                    compressedFile.path);
                                              });
                                            }
                                            setState(() {});
                                          }
                                          // Handle user upload with image picker
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: widget.quizLayout
                                                .getColorScheme()
                                                .primaryContainer,
                                          ),
                                          width: AppConfig.screenWidth / 4,
                                          height: AppConfig.screenWidth /
                                              4, // 가로 크기를 기준으로 정사각형 크기 설정
                                          child: widget.quizLayout
                                                  .isTitleImageSet()
                                              ? widget.quizLayout
                                                  .getTitleImage()
                                              : Icon(
                                                  Icons.add_a_photo,
                                                  size:
                                                      AppConfig.screenWidth / 4,
                                                  color: widget.quizLayout
                                                      .getColorScheme()
                                                      .onPrimaryContainer,
                                                ),
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
                                        Navigator.of(context).pop(widget
                                            .quizLayout
                                            .getSelectedLayout());
                                      },
                                      selection:
                                          widget.quizLayout.getTitle() == ''
                                              ? 0
                                              : 1,
                                    ),
                                  ],
                                );
                              });
                            },
                          ).then(
                            (value) {
                              if (value != null) {
                                setState(() {
                                  widget.quizLayout.setIsTitleSet(true);
                                  highlightedIndex = widget.quizLayout
                                      .getNextHighlightedIndex();
                                });
                              }
                            },
                          );
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
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                return AlertDialog(
                                  backgroundColor: widget.quizLayout
                                      .getColorScheme()
                                      .surface,
                                  title: Center(
                                      child: Text(
                                    '넘기기 스타일 설정',
                                    style: widget.quizLayout.getTitleStyle(),
                                  )),
                                  content: Container(
                                    // Set a fixed height to avoid layout issues in AlertDialog
                                    height: AppConfig.screenHeight *
                                        0.4, // Adjust the height according to your needs
                                    width: double
                                        .maxFinite, // Use maximum width available
                                    child: GridView.builder(
                                      itemCount:
                                          4, // Adjust the item count as needed
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // 2 items per row
                                        crossAxisSpacing:
                                            10, // Spacing between items horizontally
                                        mainAxisSpacing:
                                            10, // Spacing between items vertically
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                              'assets/images/layoutOption${index + 1}.jpg',
                                        );
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ConfirmButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(widget
                                            .quizLayout
                                            .getSelectedLayout());
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
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                return AlertDialog(
                                  backgroundColor: widget.quizLayout
                                      .getColorScheme()
                                      .surface,
                                  title: Center(
                                      child: Text(
                                    '배경/색상 설정',
                                    style: widget.quizLayout.getTitleStyle(),
                                  )),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Column(
                                          children: List.generate(10, (index) {
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
                                                    .getImageColorNotNull(
                                                        index),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // 좌우 정렬
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {
                                            widget.quizLayout
                                                .generateAdequateColors();
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.autorenew),
                                        ),
                                        Expanded(
                                            child:
                                                SizedBox()), // IconButton과 ConfirmButton 사이의 공간을 채움
                                        ConfirmButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(1);
                                          },
                                          selection: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                            },
                          ).then((_) {
                            setState(() {
                              changeColorScheme(
                                  widget.quizLayout.getColorScheme());
                            });
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
                              builder: (context) => quizLayoutAdditionalSetup(
                                  quizLayout: widget.quizLayout),
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
                  left: AppConfig.screenWidth / 2 -
                      28, // Subtract half the width of the button to center it
                  child: FloatingActionButton(
                    foregroundColor: widget.quizLayout.getColorScheme().primary,
                    heroTag: 'bottomBarToggle',
                    child: Icon(
                      widget.quizLayout.getIsBottomBarVisible()
                          ? Icons.remove
                          : Icons.add,
                      color: widget.quizLayout.getColorScheme().onPrimary,
                    ),
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
                          AppConfig.screenHeight / 40,
                          AppConfig.screenHeight / 4); // 화면 높이의 1/4로 제한
                      widget.quizLayout.setBottomBarHeight(tempBottomBarHeight);
                    });
                  },
                  child: viewerBottomBar(
                    quizLayout: widget.quizLayout,
                    onPressedBack: () {},
                    onPressedForward: () {},
                    showDragHandle: true,
                    showSwitchButton: true,
                  ),
                ),
              )
            : null,
      ),
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
            ? quizLayout.getColorScheme().secondaryContainer
            : Colors.transparent,
      ),
      child: GestureDetector(
        child: layoutNumber < 4
            ? Image(
                image: AssetImage(imagePath),
                width: AppConfig.screenWidth / 5,
                fit: BoxFit.fitHeight,
              )
            : Center(
                child: Text("버튼 x\n 넘기기만"),
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
      height: AppConfig.screenHeight / 16,
      width: AppConfig.screenWidth * 0.6,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: quizLayout.getNextHighlightedIndex() == index
              ? quizLayout.getColorScheme().primary
              : quizLayout.getColorScheme().primaryContainer,
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
