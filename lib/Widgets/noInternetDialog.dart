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
        child: Text(Intl.message("Checking_Internet_Connection")),
      ),
    );
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Intl.message("No_Internet_Connection")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(Intl.message("You_are_not_connected_to_Internet")),
                Text(Intl.message("Please_check_your_connection_and_try_again")),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Intl.message("OK")),
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