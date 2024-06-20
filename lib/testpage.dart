import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _uiState = 0;

  void _toggleUIState() {
    setState(() {
      _uiState = (_uiState + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleUIState,
      child: _uiState == 0 ? CustomUI1() : _uiState == 1 ? CustomUI2() : CustomUI3(),
    );
  }
}

class CustomUI1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              child: Text('<', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36.0)),
              onPressed: () {
                // Handle '<' button press
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: Text('>', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36.0)),
              onPressed: () {
                // Handle '>' button press
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomUI2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(bottom: 8.0), // Adjust the padding as needed
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                child: Text('<', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36.0)),
                onPressed: () {
                  // Handle '<' button press
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text('>', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36.0)),
                onPressed: () {
                  // Handle '>' button press
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomUI3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        // Other widgets...
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              child: Text('<', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36.0)),
              onPressed: () {
                // Handle '<' button press
              },
            ),
            TextButton(
              child: Text('>', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36.0)),
              onPressed: () {
                // Handle '>' button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
