import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using WidgetsBinding to show the dialog after the build method.
    WidgetsBinding.instance.addPostFrameCallback((_) => showNoInternetDialog(context));
    
    // Returning a Scaffold as a placeholder.
    return Scaffold(
      body: Center(
        child: Text(Intl.message("Checking Internet Connection...")),
      ),
    );
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Intl.message("No Internet Connection")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(Intl.message('You are not connected to the internet.')),
                Text(Intl.message('Please check your connection and try again.')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Intl.message('OK')),
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