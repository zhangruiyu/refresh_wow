# refresh_wow

A new flutter package project.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
#属性

* itemData: 数据集合 []
* footerItemCount:  底部控件的个数 2
* headerItemCount: 头部控件个数2,
* itemBuilder: (BuildContext context, int index, String itemData) 构建item
* headerBuilder: (BuildContext context, int index) 构建头部控件
* footerBuilder: (BuildContext context, int index) 构建底部控件
* onRefresh: _handleRefresh, 刷新
* onLoadMore: !hasMore ? _handleLoadMore : null,) 加载更多,为null时候标示没有更多数据
