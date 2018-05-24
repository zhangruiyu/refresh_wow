import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refresh_wow/load_more_widget.dart';

enum ItemType {
  header,
  item,
  footer,
  more
}

typedef Widget IndexedWithDataWidgetBuilder<D>(BuildContext context, int index,
    D itemData);

class RefreshListView<T> extends StatefulWidget {
  final List<T> itemData;
  final int headerItemCount;
  final int footerItemCount;
  final _loadMoreCount = 1;
  final IndexedWithDataWidgetBuilder<T> itemBuilder;
  final IndexedWidgetBuilder headerBuilder;
  final IndexedWidgetBuilder footerBuilder;
  final RefreshCallback onLoadMore;

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double itemExtent;
  final Key listViewKey;
  final Key refreshListViewKey;

  @override
  State createState() {
    return new RefreshListViewState<T>();
  }

  RefreshListView({
    this.refreshListViewKey,
    this.listViewKey,
    //
    this.itemExtent,
    this.addAutomaticKeepAlives: true,
    this.addRepaintBoundaries: true,
    this.scrollDirection: Axis.vertical, this.reverse: false, this.controller,
    this.primary, this.physics, this.shrinkWrap, this.padding,
    //
    @required this.itemData, @required this.itemBuilder, this.headerItemCount = 0,
    this.headerBuilder, this.footerItemCount = 0, this.footerBuilder, this.onLoadMore})
      :super(key: refreshListViewKey);


}

class RefreshListViewState<T> extends State<RefreshListView> {
  List<T> itemData;
  RefreshCallback onLoadMore;
  @override
  void initState() {
    itemData = widget.itemData;
    onLoadMore = widget.onLoadMore;
    super.initState();
  }
  setData(newAllData,onLoadMore){
    setState(() {
      itemData = newAllData;
      onLoadMore = onLoadMore;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: itemData.length + widget.headerItemCount +  widget.footerItemCount +
          (itemData.length == 0 ? 0 :  widget._loadMoreCount),
      itemBuilder: (BuildContext context, int index) {
//            print(getTypeByIndex(index).index);
        var itemType = getTypeByIndex(index);
        var realIndex = getRealIndex(itemType, index);
        if (itemType == ItemType.item) {
          return widget.itemBuilder(context, realIndex, itemData[realIndex]);
        } else if (itemType == ItemType.header) {
          assert(widget.headerBuilder != null);
          return widget.headerBuilder(context, realIndex);
        } else if (itemType == ItemType.footer) {
          assert(widget.footerBuilder != null);
          return widget.footerBuilder(context, realIndex);
        } else if (itemType == ItemType.more) {
          return new LoadMoreWidget(onLoadMore);
        } else {
          throw new Exception('wow!What a ghost');
        }
      },
      key: widget.listViewKey,
      itemExtent: widget.itemExtent,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,);
  }

  int getRealIndex(ItemType itemType, int index) {
    if (itemType == ItemType.item) {
      return index - widget.headerItemCount;
    }
    else if (itemType == ItemType.header) {
      return index;
    }
    else if (itemType == ItemType.footer) {
      return index - widget.headerItemCount - itemData.length;
    } else {
      //loadmore
      return 0;
    }
  }

  ItemType getTypeByIndex(int index) {
//    print("$index hhhh ${headerItemCount + this.itemData.length}");
    if (index < widget.headerItemCount) {
      return ItemType.header;
    } else if (index < (widget.headerItemCount + itemData.length)) {
      return ItemType.item;
    } else if (index <
        widget.headerItemCount + itemData.length +
            widget.footerItemCount) {
      return ItemType.footer;
    } else {
      return ItemType.more;
    }
  }
}
