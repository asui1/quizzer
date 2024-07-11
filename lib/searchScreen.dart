import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Functions/serverRequests.dart';
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
      uuid: "9d6a4831-12f2-4fd7-b5b2-6df9aa3509a0",
      titleImagePath: "assets/images/question2.png",
    )
  ];
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  // Needs UUID, title, and titleImage.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          focusNode: _focusNode,
          autofocus: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            _searchText = value;
          },
          onSubmitted: (value) {
            _handleSearch(_searchText);
          },
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: IconButton(
              onPressed: () {
                _handleSearch(_searchText);
              },
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: _isFocused ? _buildSearchBody() : _buildNormalBody(),
    );
  }

  void _handleSearch(String searchText) {
    setState(() {
      _searchResults = [
        QuizCard(
          title: "loadQuizLayoutMaker",
          uuid: _searchText,
          titleImagePath: "assets/images/question2.png",
          additionalData: "로드 후 QuizLayoutMaker로 이동.",
        ),
        QuizCard(
          title: "loadQuizLayoutSolver",
          uuid: _searchText,
          titleImagePath: "assets/images/question2.png",
          additionalData: "로드 후 QuizLayoutSolver로 이동.",
        ),
      ];
    });
  }

  Widget _buildSearchBody() {
    // Build your search body here
    return Center(
      child: Text("Searching..."),
    );
  }

  Widget _buildNormalBody() {
    // Build your normal body here
    return Center(
      child: Column(
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
    );
  }
}
