// @dart=2.9
import 'package:flutter/material.dart';

class GroupView<ItemType, HeaderType> extends StatefulWidget {
  final List<ItemType> items;
  final String search;
  final HeaderType Function(ItemType) groupBy;
  final Widget Function(BuildContext, ItemType) itemBuilder;
  final Widget Function(BuildContext, HeaderType) groupTitleBuilder;

  GroupView({
    Key key,
    this.items,
    this.search,
    this.groupBy,
    this.itemBuilder,
    this.groupTitleBuilder,
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
  ScrollController _controller = ScrollController();
  List<ItemType> items = [];
  GlobalKey itemKey = GlobalKey(debugLabel: 'itemKey');
  GlobalKey groupKey = GlobalKey(debugLabel: 'groupKey');
  double itemSize = 0;
  double headerSize = 0;

  @override
  void initState() {
    items = widget.items;
    _groupItems();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    _getSizes();
  }

  _getSizes() {
    final RenderBox itemBox = itemKey.currentContext.findRenderObject();
    itemSize = itemBox.size.height;
    final RenderBox groupBox = groupKey.currentContext.findRenderObject();
    headerSize = groupBox.size.height;
  }

  _goToElement(double position) {
    _controller.animateTo(
      (position),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _groupItems() {
    setState(() {
      for (int i = 0; i < items.length; i++) {
        ItemType object = items[i];

        // groupBy is the value that we'll group using it!
        // it's a function called from parent Widget to allow using of
        // dynamic items and dynamic base grouping value.
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

  _filterItems() {
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

  _findGroup(HeaderType groupItem) {
    int index = groupedItems.keys.toList().indexOf(groupItem);
    double position = 0;
    for (int i = 0; i < index; i++) {
      final key = groupedItems.keys.toList()[i];
      position += groupedItems[key].length * itemSize;
    }
    position += index * headerSize;
    _goToElement(position);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.search != null) {
      _filterItems();
      _groupItems();
    }
    return Column(
      children: [
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: groupedItems.keys.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _findGroup(groupedItems.keys.toList()[index]);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Center(
                    child: Text(
                      groupedItems.keys.toList()[index].toString(),
                    ),
                  ),
                  width: 30,
                  height: 30,
                  color: Colors.transparent,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: groupedItems.keys.length,
            itemBuilder: (context, index) {
              final currentKey = groupedItems.keys.toList()[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    key: index == 0 ? itemKey : Key(currentKey.toString()),
                    child: widget.groupTitleBuilder(
                      context,
                      currentKey,
                    ),
                  ),
                  ...mapIndexed(
                    groupedItems[currentKey],
                    (iterator, item) {
                      return Container(
                        key: index == 0 && iterator == 0
                            ? groupKey
                            : Key('$currentKey-${item.toString()}-$iterator'),
                        child: widget.itemBuilder(context, item),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}
