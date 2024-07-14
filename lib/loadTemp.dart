import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
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

  @override
  Widget build(BuildContext context) {
    // Use widget.quizLayout to access the QuizLayout object passed from the parent
    return Theme(
      data: ThemeData.from(colorScheme: widget.quizLayout.getColorScheme()),
      child: Scaffold(
        extendBodyBehindAppBar: false,
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
                  leading: Image.file(
                    File(_items[index]['titleImage']),
                    width: 50,
                    height: 50,
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
