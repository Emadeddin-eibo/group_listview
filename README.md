## Grouping View

List widget for grouping dynamic items.

<div class="display:inline-block">
        <img src="https://github.com/Emadeddin-eibo/group_listview/raw/master/sample.gif" class="display:inline-block" height="650"/>
</div>


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

Finding an item is pretty much straight forward, since we already have
a sorted list, the finding process can be easy as:
```
 items = widget.items
    .where(
      (element) => element.toLowerCase().contains(
            widget.search.toLowerCase(),
          ),
    )
    .toList();
```

#### 4. Scroll to specific group

Scrolling to certain group is not that straight forward approach,
in simpler situation, we can use `jumpToIndex`, but the main issue here
is that we don't know the exact location of a group.

To explain further, remember that we have a dynamic items, each few are
being grouped by a header. So if we want to scroll to group 2 for example,
it might contain 100 items and yet it has an index of `1` inside the dynamic map!

So, we need a way to determine the exact index we're going to in the `ListView`,
we'll be using `scrollController` to move to certain index in our `ListView`.

Each key of the dynamic map contains array of values, and we need to scroll to
the key index. In this case, the required index can be simply calculated
using all previous arrays lengths and be added to `totalLength` value.

We're still facing a problem here, the method `ScrollController.animateTo` require
a specific position on canvas, and we can't just calculate that by index!

We have `ItemBuilder` and `groupTitleBuilder` to allow the usage of dynamic
Widgets, that means we need to calculate the height of that widgets and
add that result to the correct index in order to find the corresponding widget
to scroll to.

**And that's why we need keys!**

By using unique keys in every widget "in fact, we only need two keys", we can
get the height of corresponding widget, therefore, calculate the exact
right position of certain group.

As we saw earlier, we're providing the predefined global key for the first item,
and that's all we need!

```
Container(
    key: index == 0 ? itemKey : Key(currentKey.toString()),
  ),
```

Then we can simply calculate the item height inside `addPostFrameCallback`
like the following:

```
final RenderBox itemBox = itemKey.currentContext.findRenderObject();
itemSize = itemBox.size.height;
```

Now, the `ScrollController.animateTo` is pretty much easier, we can calculate
the required group to navigate to using:

 ```
 _findGroup(HeaderType groupItem) {
    int index = groupedItems.keys.toList().indexOf(groupItem);
    double position = 0;
    for (int i = 0; i < index; i++) {
      final key = groupedItems.keys.toList()[i];
      position += groupedItems[key].length * itemSize; // all the fuss is about this line!
    }
    position += index * headerSize;
    _goToElement(position);
  }
 ```

 All we need now is to call it!

 ```
 onTap: () {
    _findGroup(groupedItems.keys.toList()[index]);
    },
 ```

That's it! feel free to ask any question about the code!
Happy coding 🤘