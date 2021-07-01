// @dart=2.9
import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  final List<String> items;

  GroupView({
    Key key,
    this.items,
  }) : super(key: key) {
    items.sort();
  }

  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  Map<String, List<String>> groupedItems = {};

  @override
  void initState() {
    groupItems();
    super.initState();
  }

  groupItems() {
    for (int i = 0; i < widget.items.length; i++) {
      var object = widget.items[i];

      if (!groupedItems.containsKey(object[0])) {
        groupedItems[object[0]] = [];
      }

      groupedItems.update(
        object[0],
        (value) => value..add(object),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List keys = groupedItems.keys.toList();
    return ListView.builder(
      itemCount: groupedItems.keys.length,
      itemBuilder: (context, index) {
        final currentKey = keys[index];
        return _ValuesRow(
          text: currentKey,
          items: groupedItems[currentKey],
        );
      },
    );
  }
}

class _KeyRow extends StatelessWidget {
  final String text;

  const _KeyRow({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[400],
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(text),
    );
  }
}

class _ValuesRow extends StatelessWidget {
  final List<String> items;
  final String text;

  const _ValuesRow({Key key, this.items, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _KeyRow(text: text),
        ...items
            .map(
              (e) => Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(e),
              ),
            )
            .toList(),
      ],
    );
  }
}
