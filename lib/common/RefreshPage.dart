import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('下拉刷新')),
        body: RefreshPage(),
      ),
    );
  }
}

class RefreshPage extends StatefulWidget {
  @override
  State<RefreshPage> createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _isRefreshing = false;
  List<String> _items = List.generate(30, (index) => 'Item $index');

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _items = List.generate(30, (index) => 'New Item $index');
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('刷新成功'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _handleRefresh,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
          );
        },
      ),
    );
  }
}
