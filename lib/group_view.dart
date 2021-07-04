// @dart=2.9
import 'package:flutter/material.dart';

class GroupView<ItemType, HeaderType> extends StatefulWidget {
  final List<ItemType> items;
  final String search;
  final HeaderType Function(ItemType) groupBy;
  final Widget Function(BuildContext context, ItemType) itemBuilder;
  final Widget Function(BuildContext context, HeaderType) headerBuilder;

  GroupView({
    Key key,
    this.items,
    this.search,
    this.groupBy,
    this.itemBuilder,
    this.headerBuilder,
  }) : super(key: key) {
    if (items.first is Comparable)
      items.sort();
    else
      items.sort((item1, item2) =>
          ('${groupBy(item1)}').compareTo('${groupBy(item2)}'));
  }

  @override
  _GroupViewState<ItemType, HeaderType> createState() => _GroupViewState();
}

class _GroupViewState<ItemType, HeaderType> extends State<GroupView> {
  Map<HeaderType, List<ItemType>> groupedItems = {};
  List<ItemType> items = [];

  @override
  void initState() {
    items = widget.items;
    groupItems();
    super.initState();
  }

  groupItems() {
    setState(() {
      for (int i = 0; i < items.length; i++) {
        ItemType object = items[i];
        HeaderType key = widget.groupBy(items[i]);

        if (!groupedItems.containsKey(key)) {
          groupedItems[key] = [];
        }

        groupedItems.update(
          key,
          (value) => value..add(object),
        );
      }
    });
  }

  filterItems() {
    setState(
      () {
        groupedItems = {};
        items = widget.items;
        if (widget.search.isEmpty) return;
        items = widget.items
            .where(
              (element) => element.toLowerCase().contains(
                    widget.search.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.search != null) {
      filterItems();
      groupItems();
    }

    return ListView.builder(
      itemCount: groupedItems.keys.length,
      itemBuilder: (context, index) {
        final currentKey = groupedItems.keys.toList()[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.headerBuilder(context, currentKey),
            ...groupedItems[currentKey]
                .map((e) => widget.itemBuilder(context, e))
                .toList(),
          ],
        );
      },
    );
  }
}
