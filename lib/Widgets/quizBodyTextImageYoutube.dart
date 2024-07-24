import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/fileSaveLoad.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ContentWidget extends StatefulWidget {
  final BuildContext context;
  final Function(int value) updateStateCallback;
  final Quiz1 quiz1;
  final QuizLayout quizLayout;
  final Function(String value) updateBodyTextCallback;

  ContentWidget({
    Key? key,
    required this.context,
    required this.updateStateCallback,
    required this.quiz1,
    required this.quizLayout,
    required this.updateBodyTextCallback,
  }) : super(key: key);

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late TextEditingController _bodyTextController;
  late TextEditingController _youtubeController;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _bodyTextController =
        TextEditingController(text: widget.quiz1.getBodyText());
    _youtubeController = TextEditingController();
    if (widget.quiz1.isYoutubeSet()) {
      String videoId = widget.quiz1.getYoutubeId();
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    }
  }

  @override
  void dispose() {
    _bodyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.quiz1.getBodyType()) {
      case 0:
        return ElevatedButton(
          child: Text(Intl.message("Add_Text")),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    Intl.message("Add_Text"),
                    textAlign: TextAlign.center,
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(Intl.message("Text")),
                        onPressed: () {
                          widget.updateStateCallback(1);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for TextField button here
                        },
                      ),
                      ElevatedButton(
                        child: Text(Intl.message("Photo")),
                        onPressed: () {
                          widget.updateStateCallback(2);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for Image button here
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          '유튜브',
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        onPressed: () {
                          widget.updateStateCallback(3);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for Youtube button here
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      case 1:
        Color? bodyTextColor = getTextColor(
            widget.quizLayout.getBodyTextStyle(),
            widget.quizLayout.getColorScheme());
        Color? bodyBackgroundColor = getBackGroundColor(
            widget.quizLayout.getBodyTextStyle(),
            widget.quizLayout.getColorScheme());
        return Stack(
          children: [
            TextField(
              cursorColor: bodyTextColor,
              controller: _bodyTextController,
              decoration: InputDecoration(
                fillColor: bodyBackgroundColor,
                filled: true,
                focusColor: bodyTextColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              minLines: 1, // 최소 줄 수 설정
              maxLines: null, // 최대 줄 수를 무제한으로 설정
              keyboardType: TextInputType.multiline, // 멀티라인 입력 활성화
              style: getTextFieldTextStyle(widget.quizLayout.getBodyTextStyle(),
                  widget.quizLayout.getColorScheme()),
              onChanged: (value) {
                widget.updateBodyTextCallback(value);
              },
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: bodyTextColor),
                onPressed: () {
                  widget.updateStateCallback(0);
                },
              ),
            ),
          ],
        );
      case 2:
        return Stack(
          children: [
            Container(
              height: 400,
              width: 400,
              child: widget.quiz1.isImageSet()
                  ? GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFileTemp =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFileTemp != null) {
                          Uint8List file = await pickedFileTemp.readAsBytes();
                          Uint8List compressedFile =
                              await compressImage(file, 500 * 1024, 400);
                          setState(() {
                            widget.quiz1.setImageByte(compressedFile);
                          });
                        }
                      },
                      child: Image.memory(widget.quiz1.getImageByte()),
                    )
                  : IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFileTemp =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFileTemp != null) {
                          Uint8List file = await pickedFileTemp.readAsBytes();
                          Uint8List compressedFile =
                              await compressImage(file, 500 * 1024, 400);
                          setState(() {
                            widget.quiz1.setImageByte(compressedFile);
                          });
                        }
                      },
                    ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  widget.quiz1.removeImageFile(); // 이미지 파일 초기화
                  widget.updateStateCallback(0); // 상태 업데이트
                },
              ),
            ),
          ],
        );
      case 3:
//  YoutubePlayerController(
//     initialVideoId: extractVideoId(videoUrl),
//     flags: YoutubePlayerFlags(
//       autoPlay: true,
//       mute: false,
//     ),
//   )
        return Stack(
          children: [
            Container(
              width: 400,
              child: widget.quiz1.isYoutubeSet()
                  ? YoutubePlayer(
                      controller: _controller,
                      aspectRatio: 16 / 9,
                    )
                  : TextField(
                      controller: _youtubeController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        // Handle what happens when the "Done" button is pressed
                        // For example, you can close the keyboard
                        Logger.log(value);
                        String videoId = extractVideoId(value) ?? "";
                        if (videoId == "") {
                          return;
                        }
                        _controller = YoutubePlayerController.fromVideoId(
                          videoId: videoId,
                          autoPlay: false,
                          params: const YoutubePlayerParams(
                              showFullscreenButton: true),
                        );
                        widget.quiz1.setYoutubeId(videoId);
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: Intl.message("Enter_Youtube_Link"),
                        // Add other decoration properties as needed
                      ),
                    ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _youtubeController.clear();
                  widget.quiz1.removeYoutube(); // 이미지 파일 초기화
                  widget.updateStateCallback(0); // 상태 업데이트
                },
              ),
            ),
          ],
        );
      default:
        return SizedBox
            .shrink(); // Return an empty widget if input doesn't match any case
    }
  }

  String? extractVideoId(String url) {
    RegExp regExp = RegExp(
      r"^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})",
      caseSensitive: false,
      multiLine: false,
    );
    final matches = regExp.allMatches(url);
    if (matches.isNotEmpty && matches.first.groupCount >= 1) {
      return matches.first
          .group(1); // Returns the first match group, the video ID.
    }
    return null; // Return null if the URL does not contain a valid YouTube video ID.
  }
}
