import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/fileSaveLoad.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Screens/additionalSetup.dart';
import 'package:quizzer/Screens/makingQuiz.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Setup/Strings.dart';
import 'package:quizzer/Widgets/GeneratorCommon.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Screens/loadTemp.dart';
import 'package:quizzer/Widgets/myColorPicker.dart';

import '../Widgets/FlipWidgets.dart';

class MakingQuizscreen extends StatefulWidget {
  MakingQuizscreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MakingQuizState();
}

class _MakingQuizState extends State<MakingQuizscreen> {
  double tempAppBarHeight = 30.0;
  double tempBottomBarHeight = 30.0;
  late TextEditingController _titleController;
  ColorScheme colorScheme;
  bool isDialogAlreadyPopped = false;
  bool inCheckDialog = true;

  _MakingQuizState() : colorScheme = MyLightColorScheme;

  @override
  void initState() {
    super.initState();
    isDialogAlreadyPopped = false;
    inCheckDialog = true;
    // Initialize the TextEditingController with the current title
    _titleController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // context.read를 사용하여 상태 관리 객체에 접근
      String title = Provider.of<QuizLayout>(context, listen: false).getTitle();
      _titleController.text = title; // String을 직접 할당
      String creator = await UserPreferences.getUserName() ?? "GUEST";
      Provider.of<QuizLayout>(context, listen: false).setCreator(creator);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAlert());
  }

  void _showAlert() {
    if (!UserPreferences.agreed) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          bool isConfirm = false;
          bool singleRun = true;
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (!isConfirm && singleRun && inCheckDialog) {
                singleRun = false;
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  inCheckDialog = false;
                });
              }
            },
            child: AlertDialog(
              title: Text(Intl.message("Terms_of_Use")),
              content: Text(
                Intl.message("User_Agreement_text"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Intl.message("OK")),
                  onPressed: () {
                    isConfirm = true;
                    inCheckDialog = false;
                    updateUserAgreed();
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pop(); // 알림 창 닫기
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      inCheckDialog = false;
    }
  }

  void changeColorScheme(ColorScheme newScheme) {
    setState(() {
      colorScheme = newScheme; // Step 3: Update the ColorScheme
    });
  }

  void updateLoad() {
    _titleController.text =
        Provider.of<QuizLayout>(context, listen: false).getTitle();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);
    int highlightedIndex = quizLayout.getNextHighlightedIndex();
    if (quizLayout.getSelectedLayout() == 0) {
      highlightedIndex = 0;
    }
    if (quizLayout.getSelectedLayout() == 0) {}
    if (quizLayout.getSelectedLayout() == 3) {
      quizLayout.setBottomBarVisibility(true);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!isDialogAlreadyPopped && !inCheckDialog && !didPop) {
          popDialog(context, quizLayout);
        }
      },
      child: Theme(
        data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
        child: Scaffold(
          extendBodyBehindAppBar: false,
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
                            AppConfig.screenHeight * 0.075,
                            AppConfig.screenHeight / 4); // 화면 높이의 1/4로 제한
                        quizLayout.setAppBarHeight(tempAppBarHeight);
                      });
                    },
                    child: viewerAppBar(
                        quizLayout: quizLayout, showDragHandle: true),
                  ),
                )
              : null,
          body: SafeArea(
            child: Container(
              decoration: backgroundDecoration(quizLayout: quizLayout),
              child: Stack(
                children: [
                  FilpStyle12(
                    quizLayout: quizLayout,
                    onPressedBack: () {},
                    onPressedForward: () {},
                  ),
                  Positioned(
                    top: 30.0,
                    left: AppConfig.screenWidth / 2 -
                        28, // Subtract half the width of the button to center it
                    child: FloatingActionButton(
                      key: const ValueKey('MakingQuizLayoutTopBarToggle'),
                      foregroundColor: quizLayout.getColorScheme().primary,
                      heroTag: 'topBarToggle',
                      child: Icon(
                        quizLayout.getIsTopBarVisible()
                            ? Icons.remove
                            : Icons.add,
                        color: quizLayout.getColorScheme().onPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          quizLayout.toggleTopBarVisibility();
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: 10.0, // Set to 0.0 to align at the top
                    left: 10.0, // Set to 0.0 to align at the left
                    child: IconButton(
                      iconSize: AppConfig.fontSize * 1.5,
                      icon: Icon(Icons.arrow_back_ios,
                          color: quizLayout.getColorScheme().primary),
                      onPressed: () {
                        popDialog(context, quizLayout);
                      },
                    ),
                  ),
                  Positioned(
                    right: 10.0, // Align to the right
                    bottom: quizLayout.getSelectedLayout() == 2
                        ? 50
                        : 10, // 하단에서의 거리
                    child: IconButton(
                      iconSize: AppConfig.fontSize * 1.5,
                      icon: Icon(Icons.arrow_forward,
                          color: quizLayout.getColorScheme().primary),
                      onPressed: () => navigateToMakingQuizPage(context),
                    ),
                  ),
                  Positioned(
                    key: const ValueKey('loadQuizLayoutButton'),
                    right: 10.0, // Align to the right
                    top: 10.0, // Align to the top
                    child: IconButton(
                      iconSize: AppConfig.fontSize * 1.5,
                      icon: Icon(Icons.download_sharp,
                          color: quizLayout.getColorScheme().primary),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoadTemp(quizLayout: quizLayout),
                          ),
                        ).then((_) {
                          updateLoad();
                          setState(() {});
                        });
                      },
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: quizLayout.getSelectedLayout() == 2
                        ? 50
                        : 10, // 하단에서의 거리
                    child: tempSaveButton(context, quizLayout),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomContainer(
                          text: Intl.message("First_Quiz_Title"),
                          quizLayout: quizLayout,
                          index: 0,
                          onPressed: () async {
                            final layoutSelected = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return buildTitleAlertDialog(
                                    context, quizLayout);
                              },
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    quizLayout.setIsTitleSet(true);
                                    highlightedIndex =
                                        quizLayout.getNextHighlightedIndex();
                                  });
                                }
                              },
                            );
                          },
                        ),
                        CustomContainer(
                          text: Intl.message("Second_Flip_Style"),
                          quizLayout: quizLayout,
                          index: 1,
                          onPressed: () async {
                            final layoutSelected = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(// Add this
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    backgroundColor:
                                        quizLayout.getColorScheme().surface,
                                    title: Center(
                                        child: Text(
                                            Intl.message("Flip_Style_Setup"))),
                                    content: Container(
                                      // Set a fixed height to avoid layout issues in AlertDialog
                                      width: double
                                          .maxFinite, // Use maximum width available
                                      child: GridView.builder(
                                        shrinkWrap: true,
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
                                            quizLayout: quizLayout,
                                            onSelected: (layoutNumber) {
                                              setState(() {
                                                quizLayout.setSelectedLayout(
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
                                          Navigator.of(context).pop(
                                              quizLayout.getSelectedLayout());
                                        },
                                        selection:
                                            quizLayout.getSelectedLayout(),
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
                          text: Intl.message("Thired_Color_Setup"),
                          quizLayout: quizLayout,
                          index: 2,
                          onPressed: () async {
                            final layoutSelected = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(// Add this
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    backgroundColor:
                                        quizLayout.getColorScheme().surface,
                                    title: Center(
                                        child: Text(
                                      Intl.message("Color_Setup"),
                                    )),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Column(
                                            children:
                                                List.generate(10, (index) {
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return ColorPickerField(
                                                          quizLayout:
                                                              quizLayout,
                                                          index: index,
                                                        );
                                                      },
                                                    );

                                                    if (selectedColor != null) {
                                                      setState(() {});
                                                    }
                                                  },
                                                  isActive: quizLayout
                                                      .getVisibility(index),
                                                  quizLayout: quizLayout,
                                                  buttonText: Intl.message(
                                                      stringResources[
                                                          'imageSet$index']!),
                                                  image: quizLayout
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
                                            key: const ValueKey(
                                                "MakingQuizLayoutColorSchemeRefreshButton"),
                                            onPressed: () {
                                              quizLayout
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
                                changeColorScheme(quizLayout.getColorScheme());
                              });
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
                          text: '4. ' + Intl.message("Additional_Setup"),
                          quizLayout: quizLayout,
                          index: 3,
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => quizLayoutAdditionalSetup(
                                    quizLayout: quizLayout),
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
                      key: const ValueKey('MakingQuizLayoutBottomBarToggle'),
                      foregroundColor: quizLayout.getColorScheme().primary,
                      heroTag: 'bottomBarToggle',
                      child: Icon(
                        quizLayout.getIsBottomBarVisible()
                            ? Icons.remove
                            : Icons.add,
                        color: quizLayout.getColorScheme().onPrimary,
                      ),
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
          ),
          bottomNavigationBar: quizLayout.getIsBottomBarVisible()
              ? PreferredSize(
                  // 하단 바 추가
                  preferredSize:
                      Size.fromHeight(quizLayout.getBottomBarHeight()),
                  child: GestureDetector(
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      setState(() {
                        tempBottomBarHeight -=
                            details.delta.dy; // 드래그 이벤트에 따라 하단 바의 높이를 변경
                        tempBottomBarHeight = tempBottomBarHeight.clamp(
                            AppConfig.screenHeight / 40,
                            AppConfig.screenHeight / 4); // 화면 높이의 1/4로 제한
                        quizLayout.setBottomBarHeight(tempBottomBarHeight);
                      });
                    },
                    child: viewerBottomBar(
                      quizLayout: quizLayout,
                      onPressedBack: () {},
                      onPressedForward: () {},
                      showDragHandle: true,
                      showSwitchButton: true,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  StatefulBuilder buildTitleAlertDialog(
          BuildContext context, QuizLayout quizLayout) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Center(
            child: Text(
              Intl.message("Quiz_Title_Setup"),
            ),
          ),
          backgroundColor: quizLayout.getColorScheme().surface,
          content: SizedBox(
            width: AppConfig.screenWidth * 0.6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: AppConfig.screenHeight * 0.02,
                  ),
                  TextField(
                    key: const ValueKey("MakingQuizLayoutTitleTextField"),
                    controller:
                        _titleController, // Bind the controller to the TextField
                    decoration: InputDecoration(
                      labelText: Intl.message("Enter_Quiz_Title"),
                    ),
                    onChanged: (value) {
                      // Optionally update the title in real-time
                      quizLayout.setTitle(value);
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: AppConfig.screenHeight * 0.02,
                  ),
                  Text(
                    Intl.message("Set_Title_Image"),
                  ),
                  SizedBox(
                    height: AppConfig.screenHeight * 0.02,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? tempImageFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (tempImageFile != null) {
                        Uint8List file = await tempImageFile.readAsBytes();
                        Uint8List compressedFile = await compressImage(file, 500 * 1024, 50);
                        setState(() {
                          quizLayout.setImageBytes(compressedFile);
                        });
                      }
                      // Handle user upload with image picker
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: quizLayout.getColorScheme().primaryContainer,
                      ),
                      width: 50,
                      height:
                          50, // 가로 크기를 기준으로 정사각형 크기 설정
                      child: quizLayout.isTitleImageSet()
                          ? Image.memory(
                              quizLayout.getTitleImageString(),
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.add_a_photo,
                              color: quizLayout
                                  .getColorScheme()
                                  .onPrimaryContainer,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.screenHeight * 0.02,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0, // 태그 사이의 가로 간격
                    runSpacing: 4.0, // 태그 사이의 세로 간격
                    children: quizLayout.getTags().map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor:
                            quizLayout.getColorScheme().primaryContainer,
                        onDeleted: () {
                          // 태그 삭제 로직
                          setState(() {
                            quizLayout.removeTags(
                                tag); // quizLayout에서 태그를 삭제하는 메서드를 호출해야 합니다.
                          });
                        },
                        deleteIcon: Icon(
                          Icons.cancel,
                          size: 18.0,
                          color: quizLayout.getColorScheme().onPrimaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    TextEditingController tagController =
                        TextEditingController();
                    void addTagAndCloseDialog() {
                      String tag = tagController.text;
                      if (tag.isNotEmpty) {
                        quizLayout.addTag(tag);
                      }
                      Navigator.of(context).pop();
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(Intl.message("Add_Tags")),
                          content: TextField(
                            controller: tagController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: Intl.message("Enter_Tags"),
                            ),
                            onSubmitted: (value) => addTagAndCloseDialog(),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                Intl.message("Cancel"),
                                style: TextStyle(
                                    color: quizLayout.getColorScheme().error),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(Intl.message("Add")),
                              onPressed: () => addTagAndCloseDialog(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    Intl.message("Add_Tags"),
                    style: TextStyle(
                      color:
                          quizLayout.getColorScheme().primary, // 버튼 텍스트 색상 설정
                    ),
                  ),
                ),
                Spacer(),
                ConfirmButton(
                  onPressed: () {
                    Navigator.of(context).pop(quizLayout.getSelectedLayout());
                  },
                  selection: quizLayout.getTitle() == '' ? 0 : 1,
                ),
              ],
            ),
          ],
        );
      });

  void popDialog(BuildContext context1, QuizLayout quizLayout) {
    if (!isDialogAlreadyPopped) {
      // 여기에 popDialog 로직 구현
      isDialogAlreadyPopped = true;
      showDialog<bool>(
        context: context1,
        builder: (context) => AlertDialog(
          title: Text(Intl.message("Warning")),
          content: Text(Intl.message("Leaving_warning")),
          actions: <Widget>[
            TextButton(
              child: Text(
                Intl.message("Exit"),
                style: TextStyle(
                  color: quizLayout.getColorScheme().error,
                ),
              ),
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            TextButton(
                child: Text(Intl.message("Cancel")),
                onPressed: () {
                  isDialogAlreadyPopped = false;
                  Navigator.of(context).pop(false); // Do not pop the screen.
                }),
          ],
        ),
      ).then((_) {
        isDialogAlreadyPopped = false;
      });
    }
  }
}

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int selection;

  ConfirmButton({required this.onPressed, required this.selection});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(Intl.message("OK")),
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
        key: ValueKey("MakingQuizLayoutLayoutOption$layoutNumber"),
        child: layoutNumber < 4
            ? Image(
                image: AssetImage(imagePath),
                width: AppConfig.screenWidth / 5,
                fit: BoxFit.fitHeight,
              )
            : Center(
                child: Text(Intl.message("No_buttons_Only_Flip")),
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
        key: ValueKey("MakingQuizLayoutImageSetButton$buttonText"),
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
        key: ValueKey("MakingQuizLayoutCustomContainer$index"),
        style: TextButton.styleFrom(
          foregroundColor: quizLayout.getNextHighlightedIndex() == index
              ? quizLayout.getColorScheme().primary
              : quizLayout.getColorScheme().primaryContainer,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0, fontFamily: MyFonts.notoSans),
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

void navigateToMakingQuizPage(BuildContext context) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        MakingQuiz(), // 여기서 NewPage()는 새로운 페이지 위젯입니다.
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0); // 오른쪽에서 시작
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  ));
}
