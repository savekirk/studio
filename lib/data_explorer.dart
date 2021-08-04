import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studio/app_state.dart';
import 'package:studio/path_view.dart';

class DataExplorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var app = Provider.of<AppState>(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 900),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: PathView(),
                    ),
                    if (false)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: 'Search the box',
                            contentPadding: EdgeInsets.fromLTRB(20, 8, 12, 8),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                if (app.path.isEmpty)
                  Flexible(
                    child: ListView.builder(
                      itemCount: app.entries.length,
                      // separatorBuilder: (context, id) => Divider(
                      //   thickness: 2,
                      // ),
                      itemBuilder: (context, index) {
                        var mapEntry = app.entries.entries.elementAt(index);
                        return EntryWidget(
                          mapEntry.key.toString(),
                          mapEntry.value,
                        );
                      },
                    ),
                  )
                /*else
                  Expanded(
                    child: ListView.builder(
                      itemCount: app.entries.length,
                      itemBuilder: (context, index) {
                        return EntryWidget(app.entries[index]);
                      },
                    ),
                  ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EntryWidget extends StatelessWidget {
  final String entryKey;
  final dynamic value;

  EntryWidget(this.entryKey, this.value);

  String prettyPrint(dynamic value) {
    final encoder = JsonEncoder.withIndent('    ');
    if (value is Map) {
      value = stringifyKeys(value as Map);
    }
    try {
      return encoder.convert(value as Map);
    } on Error catch (_, e) {
      // print(e);
      return value.toString();
    }
  }

  Map<String, dynamic> stringifyKeys(Map<dynamic, dynamic> map) {
    Map<String, dynamic> converted = {};
    map.forEach((key, value) {
      dynamic v = value;
      if (value is Map) {
        v = stringifyKeys(value);
      }
      converted[key.toString()] = v;
    });

    return converted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          entryKey,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(text: prettyPrint(value)),
        ),
      ),
    );
  }
}
