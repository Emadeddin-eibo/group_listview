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

class Home extends StatelessWidget {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goupe List Example'),
      ),
      body: GroupView(
        items: items,
      ),
    );
  }
}

