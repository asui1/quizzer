import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/config.dart';

class LoadTemp extends StatefulWidget {
  final QuizLayout quizLayout;

  LoadTemp({Key? key, required this.quizLayout}) : super(key: key);

  @override
  _LoadTempState createState() => _LoadTempState();
}

class _LoadTempState extends State<LoadTemp> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  

  Future<void> _loadItems() async {
    final dir = await getApplicationDocumentsDirectory();
    final List<Map<String, dynamic>> loadedItems = [];
    final regex =
        RegExp(r'temp_(.*?)\.json'); // Regular expression to match file names

    final files = dir.listSync(); // List all files in the directory

    for (var file in files) {
      final match = regex.firstMatch(file.path);
      if (match != null) {
        final title = match.group(1); // Extract the title part
        if (title != null) {
          loadedItems.add({
            'title': title, // Use the extracted title
            'jsonPath': file.path,
            'titleImage':
                '${dir.path}/temp_${title}-titleImage.png', // Adjust the image path accordingly
          });
        }
      }
    }

    setState(() {
      _items = loadedItems;
    });
  }
Future<void> deleteTempFiles(String title) async {
  final directory = await getApplicationDocumentsDirectory();
  final dir = Directory(directory.path);
  final files = dir.listSync(); // 디렉토리 내의 모든 파일과 디렉토리를 가져옵니다.

  for (var file in files) {
    // 파일 이름이 'temp_${title}'로 시작하는지 확인합니다.
    String fileName = file.path.split('/').last;
    if (fileName.startsWith('temp_${title}')) {
      try {
        file.deleteSync(); // 조건에 맞는 파일을 삭제합니다.
      } catch (e) {
        Logger.log("Error deleting file: $e");
      }
    }
  }
}
  @override
  Widget build(BuildContext context) {
    // Use widget.quizLayout to access the QuizLayout object passed from the parent
    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(Intl.message("Load")),
        ),
        body: SafeArea(
          child: Center(
            child: ListView.builder(
              padding: EdgeInsets.all(AppConfig.largePadding),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    final content = json.decode(
                        await File(_items[index]['jsonPath']).readAsString());
                    await widget.quizLayout.loadQuizLayout(content);
                    if (widget.quizLayout.isTitleImageSet())
                      widget.quizLayout
                          .setTitleImage(_items[index]['titleImage']);
                    Navigator.pop(context);
                  },
                  leading: Row(
    mainAxisSize: MainAxisSize.min, // Row의 크기를 내부 위젯에 맞춤
    children: [
      IconButton(
        icon: Icon(Icons.delete), // 예시 아이콘, 필요에 따라 변경 가능
        onPressed: () async {
          await deleteTempFiles(_items[index]['title']); // 파일 삭제
          _loadItems(); // 아이템 목록 다시 로드

        },
      ),
      Image.file(
        File(_items[index]['titleImage']),
        width: 50,
        height: 50,
        errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/question2.png'),
      ),
    ],
  ), // Display the image
                  title: Text(
                    _items[index]['title'],
                  ), // Display the title
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
