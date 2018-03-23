# refresh_wow

#####自持自定义头,尾.
#####加载更多.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
![image](https://github.com/zhangruiyu/refresh_wow/blob/master/wow.gif)

#属性
* itemData: 数据集合 []
* footerItemCount:  底部控件的个数 2
* headerItemCount: 头部控件个数2,
* itemBuilder: (BuildContext context, int index, String itemData) 构建item
* headerBuilder: (BuildContext context, int index) 构建头部控件
* footerBuilder: (BuildContext context, int index) 构建底部控件
* onRefresh: _handleRefresh, 刷新
* onLoadMore: !hasMore ? _handleLoadMore : null,) 加载更多,为null时候标示没有更多数据

####refresh_config()里的
* var refreshingShowText = '正在刷新数据';
* var errShowText = '数据刷新失败\n点击重试';
* var doneShowText = '⁽⁽ଘ( ˊᵕˋ )ଓ⁾⁾';
* var loadMoreTextStyle = new TextStyle();
####可以refresh_config().errShowText='自定义错误'修改

##### 有需求的话,后期再加入其他的吧