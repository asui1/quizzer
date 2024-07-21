import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using WidgetsBinding to show the dialog after the build method.
    WidgetsBinding.instance.addPostFrameCallback((_) => showNoInternetDialog(context));
    
    // Returning a Scaffold as a placeholder.
    return Scaffold(
      body: Center(
        child: Text('Checking Internet Connection...'),
      ),
    );
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are not connected to the internet.'),
                Text('Please check your connection and try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                SystemNavigator.pop(); // This exits the app.
              },
            ),
          ],
        );
      },
    ).then((_){
      SystemNavigator.pop(); // This exits the app.
    });
  }
}