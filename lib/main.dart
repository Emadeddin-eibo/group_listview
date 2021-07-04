import 'package:flutter/material.dart';
import 'package:group_listview_example/group_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final items = <String>[
    'Poppie Hart',
    'Aarron Goodman',
    'Mikail Marriott',
    'Bianca Serrano',
    'Adrienne Rigby',
    'Aizah Downes',
    'Lexi Mason',
    'Jaeden Simmons',
    'Gillian Hoover',
    'Alayah Odling',
    'Cieran Chavez',
    'Alaw Buxton',
    'Hallam Horn',
    'Ikrah Bowman',
    'Theodora Dale',
    'Anwar Mcphee',
    'Jason Houghton',
    'Cian Lucas',
    'Samah Reeve',
    'Nile Person',
    'Freja Perez',
    'Homer Robin',
    'Carys Burris',
    'Enzo Witt',
    'Nawal North',
    'Shanae Davey',
    'Kaitlan Yates',
    'Lynden Brown',
    'Emmanuel Harrison',
    'Jac Schneider',
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goupe List Example'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Type to search...'),
            onChanged: (text) => setState(() {
              query = text;
            }),
          ),
          Expanded(
            child: GroupView(
              items: items,
              search: query,
              groupBy: (item) => item[0],
              headerBuilder: (context, headerObject) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[400],
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(headerObject),
                );
              },
              itemBuilder: (context, item) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(item.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  final int id;
  final String name;

  Item(
    this.id,
    this.name,
  );

  @override
  String toString() => '{id: $id, name: $name}';
}
