import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('refresh and load more'),),
        body: RefreshToLoadmore(),
      ),
    );
  }
}

class RefreshToLoadmore extends StatefulWidget {
  @override
  State<RefreshToLoadmore> createState() => _RefreshToLoadmoreState();
}

class _RefreshToLoadmoreState extends State<RefreshToLoadmore> {

  final GlobalKey<RefreshIndicatorState> _refreshKey =GlobalKey<RefreshIndicatorState>();
  bool _isLoadingMore =false;
  List<String> _items=List.generate(20, (index) => '列表 $index');


  Future<void> _handleRefresh() async{
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _items=List.generate(20, (index) => '更新列表 $index');

    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('刷新成功'),
          duration: Duration(seconds: 1),
      )
    );
  }
  Future<void> _loadMore() async{
    if(_isLoadingMore) return;

    setState(() {
      _isLoadingMore=true;

    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoadingMore = false;
      _items.addAll(List.generate(10, (index) => '加载了新列表 ${_items.length+index}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo){
        if(!_isLoadingMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
          _loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _handleRefresh,
        child: ListView.builder(
            itemCount: _items.length+(_isLoadingMore ? 1:0),
            itemBuilder: (context,index){
              if(index == _items.length){
                return Center(
                  child: Padding(
                    padding:  const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return ListTile(
                title: Text(_items[index]),
              );
            }
        ),
      ),
    );
  }
}
