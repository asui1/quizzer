import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Widgets/quizCard.dart';

class SearchScreen extends StatefulWidget {
  String? searchText;

  SearchScreen({Key? key, this.searchText}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  List<QuizCard> _searchResults = [];
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  String _screeenText = Intl.message("Is_Searching");
  late TextEditingController _searchController;

  @override
  void initState() {
    Logger.log("SearchScreen initState");
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _searchController = TextEditingController(text: widget.searchText);
    if (widget.searchText != null) {
      _searchText = widget.searchText!;
      searchServer(_searchText);

    }
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
    _searchController.dispose();
    super.dispose();
  }

  // Needs UUID, title, and titleImage.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: widget.searchText == null ? true : false,
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

  void searchServer(String searchText) {
    Future<List<QuizCard>> result = searchRequest(searchText);
    result.then((value) {
      setState(() {
        _screeenText = Intl.message("No_Results");
        _searchResults = value;
      });
    });
  }

  void _handleSearch(String searchText) {
    if(searchText.isEmpty) {
      return;
    }
    setState(() {
      _screeenText = Intl.message("Is_Searching");
      _searchResults = []; // 검색 결과를 비웁니다.
    });
    // URL을 변경합니다.
    final Uri newUri = Uri(
      path: '/searchResult',
      queryParameters: {'searchText': searchText},
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, newUri.toString());
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
