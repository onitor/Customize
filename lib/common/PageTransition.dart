
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageTransition(),
    );
  }
}

class PageTransition extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('页面转换'),),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.of(context).push(_createRoute(secondPage(), FadeTransitionAnimation()));
          },
          child: Text('Go to the second page')
        ),
      ),
    );
  }

  Route _createRoute(Widget page, PageTransitionAnimation animation) {
    return PageRouteBuilder(
      pageBuilder: (context, anim, secondaryAnimation) => page,
      transitionsBuilder: (context, anim, secondaryAnimation, child) {
        return animation.buildTransition(anim, secondaryAnimation, child);
      },
    );
  }
}
//定义抽象类接口
  abstract class PageTransitionAnimation{
    Widget buildTransition(Animation<double> animation, Animation<double> secondaryAnimation, Widget child);
}

  //滑动过度动画
  class SlideTransitionAnimation extends PageTransitionAnimation{
    @override
    Widget buildTransition(Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
        const begin=Offset(1.0, 0.0);
        const end=Offset.zero;
        const curve = Curves.ease;

        var tween=Tween(begin: begin,end:end).chain(CurveTween(curve: curve));
        var offsetAnimation= animation.drive(tween);
        
        return SlideTransition(position: offsetAnimation,child: child,);
    }


}
// 淡入淡出过渡动画
class FadeTransitionAnimation extends PageTransitionAnimation {
  @override
  Widget buildTransition(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// 缩放过渡动画
class ScaleTransitionAnimation extends PageTransitionAnimation {
  @override
  Widget buildTransition(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease));
    var scaleAnimation = animation.drive(tween);

    return ScaleTransition(
      scale: scaleAnimation,
      child: child,
    );
  }
}
  class secondPage extends StatelessWidget {


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('second page'),),
        body: Center(
          child: Text('This is the second page'),
        ),
      );
    }
  }


