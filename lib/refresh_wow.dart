import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:refresh_wow/LoadMoreWidget.dart';

enum ItemType {
  header,
  item,
  footer,
  more
}

typedef Widget IndexedWithDataWidgetBuilder<T>(BuildContext context, int index,
    T itemData);

class RefreshListView<T> extends StatelessWidget {
  final List<T> itemData;
  final int headerItemCount;
  final int footerItemCount;
  final _loadMoreCount = 1;
  final IndexedWithDataWidgetBuilder<T> itemBuilder;
  final IndexedWidgetBuilder headerBuilder;
  final IndexedWidgetBuilder footerBuilder;
  final RefreshCallback onRefresh;
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
  final Key refreshIndicatorKey;

  RefreshListView({
    this.listViewKey,
    this.refreshIndicatorKey,
    //
    this.itemExtent,
    this.addAutomaticKeepAlives: true,
    this.addRepaintBoundaries: true,
    this.scrollDirection: Axis.vertical, this.reverse: false, this.controller,
    this.primary, this.physics, this.shrinkWrap, this.padding,
    //
    @required this.onRefresh, @required this.itemData, @required this.itemBuilder, this.headerItemCount = 0,
    this.headerBuilder, this.footerItemCount = 0, this.footerBuilder, this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      key: this.refreshIndicatorKey,
      onRefresh: this.onRefresh,
      child: new ListView.builder(
        itemCount: itemData.length + headerItemCount + footerItemCount +
            (this.onLoadMore == null ? 0 : _loadMoreCount),
        itemBuilder: (BuildContext context, int index) {
//            print(getTypeByIndex(index).index);
          var itemType = getTypeByIndex(index);
          var realIndex = getRealIndex(itemType, index);
          if (itemType == ItemType.item) {
            return itemBuilder(context, realIndex, itemData[realIndex]);
          } else if (itemType == ItemType.header) {
            assert(headerBuilder != null);
            return headerBuilder(context, realIndex);
          } else if (itemType == ItemType.footer) {
            assert(footerBuilder != null);
            return footerBuilder(context, realIndex);
          } else if (itemType == ItemType.more) {
            return new LoadMoreWidget(this.onLoadMore);
          } else {
            throw new Exception('wow!What a ghost');
          }
        },
        key: listViewKey,
        itemExtent: itemExtent,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,),
    );
  }

  int getRealIndex(ItemType itemType, int index) {
    if (itemType == ItemType.item) {
      return index - this.headerItemCount;
    }
    else if (itemType == ItemType.header) {
      return index;
    }
    else if (itemType == ItemType.footer) {
      return index - this.headerItemCount - this.itemData.length;
    } else {
      //loadmore
      return 0;
    }
  }

  ItemType getTypeByIndex(int index) {
//    print("$index hhhh ${headerItemCount + this.itemData.length}");
    if (index < headerItemCount) {
      return ItemType.header;
    } else if (index < (headerItemCount + this.itemData.length)) {
      return ItemType.item;
    } else
    if (index < headerItemCount + this.itemData.length + this.footerItemCount) {
      return ItemType.footer;
    } else {
      return ItemType.more;
    }
  }
}
