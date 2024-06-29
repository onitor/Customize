import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('图片轮播')),
        body: ImageCarousel(),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _images = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );

      setState(() {}); // 确保 UI 在状态变化时更新
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return Image.asset(
              _images[index],
              fit: BoxFit.cover,
              width: double.infinity,
            );
          },
        ),
        Positioned(
          bottom: 10.0,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _images.map((image) {
              int index = _images.indexOf(image);
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.blueAccent
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
