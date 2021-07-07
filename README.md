## Grouping View

List widget for grouping dynamic items.

## Explaining the code

The main idea is based on sorting and adding the items to dynamic Map,
and then iterating on the Map for printing convenient Widgets.

#### 1. Grouping process

First, it's important to mention that we're **sorting** the supplied array,
aka, `dynamic items` in the constructor using normal sort or Comparator,
depending on the items.

We're making good use of how Map in Dart works, we can add items  to
dynamic map using `update` function, while instantiating new arrays and
inserting new keys using same line of code `groupedItems[key] = [];`.

```
if (!groupedItems.containsKey(key)) {
    groupedItems[key] = [];
}

groupedItems.update(
    key,
    (value) => value..add(object),
);
```

#### 2. Building the ListView

Since our dynamic list is sorted and inserted in the map, aka, `groupedItems`,
we can easily build it in normal ListView.

It's recommended to keep any functionality out of building Widget, that's why
we used a dynamic map and inserted all items within it, so we can easily
iterate over the map and display convenient widget (header or item widget)

We'll use a simple `Column` to display group header widget and then all
items that contained in that group.

Since our work is all dynamically built, we'll be using WidgetBuilder to
provide Title or Item Widgets from parent Widget.

```
Container(
    key: index == 0 ? itemKey : Key(currentKey.toString()),
    child: widget.groupTitleBuilder(context,currentKey),
  ),
```

I'll explain `Key` usage later 😎


#### 3. Find an item

Finding