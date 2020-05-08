import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:open_mail_app/open_mail_app.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open Mail App Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text("Open Mail App"),
              onPressed: () async {
                // Android: Will open mail app or show native picker
                // iOS: Will open mail app if single mail app found
                var result = await OpenMailApp.openMailApp();

                // If no mail apps found, show error
                if (!result.didOpen && !result.canOpen) {
                  showNoMailAppsDialog(context);

                  //iOS: if multiple mail apps found, show dialog to select
                } else if (result.canOpen) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return MailAppPickerDialog(
                        mailApps: result.options,
                      );
                    },
                  );
                }
              },
            ),
            RaisedButton(
              child: Text("Get Mail Apps"),
              onPressed: () async {
                var apps = await OpenMailApp.getMailApps();
                if (apps.length == 0) {
                  showNoMailAppsDialog(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Mail Apps"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (var app in apps) Text(app.name),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
