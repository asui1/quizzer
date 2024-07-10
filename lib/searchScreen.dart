import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Widgets/quizCard.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  List<QuizCard> _searchResults = [
    QuizCard(
      title: "loadQuizLayoutMaker",
      uuid: "c2ce5a9b-bfcf-5699-9c02-bbf19bde2a5f",
      titleImagePath: "assets/images/question2.png",
      additionalData: "로드 후 QuizLayoutMaker로 이동.",
    ),
    QuizCard(
      title: "loadQuizLayoutSolver",
      uuid: "c2ce5a9b-bfcf-5699-9c02-bbf19bde2a5f",
      titleImagePath: "assets/images/question2.png",
      additionalData: "로드 후 QuizLayoutSolver로 이동.",
    ),
    QuizCard(
      title: "emptyTest",
      uuid: "11111",
      titleImagePath: "assets/images/question2.png",
    )
  ];

  // Needs UUID, title, and titleImage.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          autofocus: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            _searchText = value;
            if (_searchText.startsWith('#')) {
              // This is a hashtag, handle it accordingly
            }
          },
          onSubmitted: (value) {
            // Add your search logic here
          },
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: IconButton(
              onPressed: () {
                // Add your search logic here
              },
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return _searchResults[index];
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
