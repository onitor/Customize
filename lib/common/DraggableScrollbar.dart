import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Draggable Scrollbar')),
        body: DraggableScrollbar(
          itemCount:100,
        ),
      ),
    );
  }
}
class DraggableScrollbar extends StatefulWidget {
  final int itemCount;
  DraggableScrollbar({required this.itemCount});

  @override
  State<DraggableScrollbar> createState() => _DraggableScrollbarState();
}

class _DraggableScrollbarState extends State<DraggableScrollbar> {
  double _scrollPosition = 0.0;
  double _dragPosition = 0.0;
  double _maxDragExtent = 0.0;
  double _maxScrollExtent = 0.0;
  bool _isDragging = false;

  final ScrollController _scrollController=ScrollController();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _calculateMaxExtents();
      _scrollController.addListener((_updataScrollPosition));
    });

  }
  void _updataScrollPosition(){
    if(!_isDragging){
      setState(() {
        _scrollPosition=_scrollController.offset;
        _dragPosition=(_scrollPosition/_maxScrollExtent)*_maxDragExtent;
      });
    }
  }
  @override
  void dispose(){
    _scrollController.removeListener(_updataScrollPosition );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return ListTile(title: Text('第 $index 行'));
          },
        ),
        Positioned(
          right: 0,
          top: _dragPosition,
          child: GestureDetector(
            onVerticalDragStart: (details) {
              _isDragging = true;
            },
            onVerticalDragUpdate: (details) {
              setState(() {
                _dragPosition += details.delta.dy;
                if (_dragPosition < 0) {
                  _dragPosition = 0;
                } else if (_dragPosition > _maxDragExtent) {
                  _dragPosition = _maxDragExtent;
                }
                _scrollPosition = (_dragPosition / _maxDragExtent) * _maxScrollExtent;
                _scrollController.jumpTo(_scrollPosition);
              });
            },
            onVerticalDragEnd: (details) {
              _isDragging = false;
            },
            child: Container(
              height: 40,
              width: 5,
              color: Colors.grey,

            ),
          ),
        ),
      ],
    );
  }
  void _calculateMaxExtents(){
    setState(() {
      _maxScrollExtent=_scrollController.position.maxScrollExtent;
      _maxDragExtent=MediaQuery.of(context).size.height-40.0;
    });
  }
}


