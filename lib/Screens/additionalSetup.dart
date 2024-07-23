
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/Strings.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';

class quizLayoutAdditionalSetup extends StatefulWidget {
  final QuizLayout quizLayout;
  quizLayoutAdditionalSetup({required this.quizLayout});
  @override
  _quizLayoutAdditionalSetup createState() => _quizLayoutAdditionalSetup();
}

class _quizLayoutAdditionalSetup extends State<quizLayoutAdditionalSetup> {
  int itemCount = 4;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Intl.message("Additional_Setup")),
          backgroundColor: widget.quizLayout.getColorScheme().inversePrimary,
        ),
        body: Container(
          decoration: backgroundDecoration(quizLayout: widget.quizLayout),
          child: Column(
            children: [
              SizedBox(
                  height: AppConfig.screenHeight * 0.05), // 여기에 원하는 높이를 설정하세요.
              Expanded(
                child: ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        if (index != 0) Divider(),
                        InkWell(
                          key: ValueKey(
                              'quizLayoutAdditionalSetupInkWell$index'),
                          onTap: () {
                            index != itemCount - 1
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
// 초기 선택값 설정
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text(Intl.message(
                                                stringResources[
                                                    'quizLayoutSetup${index + 1}']!)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                setValueRow(
                                                    AppConfig.fontFamilys,
                                                    widget.quizLayout
                                                        .getTextStyle(index)[0],
                                                    () => setState(
                                                          () {
                                                            widget.quizLayout
                                                                .decrementTextStyle(
                                                                    index, 0);
                                                          },
                                                        ),
                                                    () => setState(
                                                          () {
                                                            widget.quizLayout
                                                                .incrementTextStyle(
                                                                    index, 0);
                                                          },
                                                        ),
                                                    false,
                                                    widget.quizLayout
                                                        .getTextStyle(index),
                                                    widget
                                                        .quizLayout), //SET BORDER
                                                setValueRow(
                                                    AppConfig.colorStyles,
                                                    widget.quizLayout
                                                        .getTextStyle(index)[1],
                                                    () => setState(
                                                          () {
                                                            widget.quizLayout
                                                                .decrementTextStyle(
                                                                    index, 1);
                                                          },
                                                        ),
                                                    () => setState(
                                                          () {
                                                            widget.quizLayout
                                                                .incrementTextStyle(
                                                                    index, 1);
                                                          },
                                                        ),
                                                    true,
                                                    widget.quizLayout
                                                        .getTextStyle(index),
                                                    widget
                                                        .quizLayout), //SET BORDER
                                                setValueRow(
                                                    AppConfig.borderType,
                                                    widget.quizLayout
                                                        .getTextStyle(index)[2],
                                                    () => setState(
                                                          () {
                                                            widget.quizLayout
                                                                .decrementTextStyle(
                                                                    index, 2);
                                                          },
                                                        ), //SET BORDER
                                                    () => setState(
                                                          () {
                                                            widget.quizLayout
                                                                .incrementTextStyle(
                                                                    index, 2);
                                                          },
                                                        ),
                                                    false,
                                                    widget.quizLayout
                                                        .getTextStyle(index),
                                                    widget
                                                        .quizLayout), //SET BORDER
                                              ],
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: Text('닫기'),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ).then((value) {
                                    setState(() {});
                                  })
                                : null;
                          },
                          child: Container(
                            height: AppConfig.screenHeight * 0.08,
                            width: AppConfig.screenWidth * 0.8,
                            margin: EdgeInsets.symmetric(
                                horizontal: AppConfig.largePadding,
                                vertical: AppConfig.padding),
                            child: TextStyleWidget(
                                textStyle:
                                    widget.quizLayout.getTextStyle(index),
                                text:
                                    Intl.message(stringResources['quizLayoutSetup${index + 1}']!),
                                colorScheme:
                                    widget.quizLayout.getColorScheme()),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
