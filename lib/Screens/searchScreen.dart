import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Widgets/quizCard.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  List<QuizCard> _searchResults = [];
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  String _screeenText = Intl.message("Is_Searching");

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
            hintText: Intl.message("Search"),
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
      _screeenText = Intl.message("Is_Searching");
      _searchResults = []; // 검색 결과를 비웁니다.
    });

    Future<List<QuizCard>> result = searchRequest(searchText);
    result.then((value) {
      setState(() {
        _screeenText = Intl.message("No_Results");
        _searchResults = value;
      });
    });
  }

  Widget _buildSearchBody() {
    // Build your search body here
    return Center(
      child: Text(Intl.message("Searching")),
    );
  }

  Widget _buildNormalBody() {
    // Build your normal body here
    return Center(
      child: _searchResults.length == 0
          ? Text(_screeenText)
          : Column(
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
