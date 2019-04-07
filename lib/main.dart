import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _buildSurveyList(),
    );
  }

  Widget _buildItem(context, DocumentSnapshot document) {
    return GestureDetector(
      onTap: () =>
          document.reference.updateData({'total': document['total'] + 1}),
      child: Container(
        child: Center(
          child: Text(
            document['total'].toString(),
            style: (document['total'].toString().length > 6
                ? (document['total'].toString().length > 9
                    ? Theme.of(context).textTheme.display2
                    : Theme.of(context).textTheme.display3)
                : Theme.of(context).textTheme.display4),
          ),
        ),
      ),
    );

    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFddddff),
            ),
            padding: EdgeInsets.all(10.0),
            child: Text(
              document['votes'].toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
      ),
      onTap: () =>
          document.reference.updateData({'votes': document['votes'] + 1}),
    );
  }

  Widget _buildSurveyList() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lekker tellen'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('count').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading...');
            return _buildItem(context, snapshot.data.documents[0]);
          }),
    );
  }
}

class Survey {
  final String name;
  final List<Choice> choices;

  Survey({this.name, this.choices});
}

class Choice {
  final String name;
  final int votes;

  Choice({this.name, this.votes});
}
