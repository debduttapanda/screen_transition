import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "page1",
      onGenerateRoute: RouteGenerator.getRoute,
    );
  }
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    Widget page;
    switch (routeSettings.name) {
      case "page1":
        page = const Page1();
        break;
      case "page2":
        page = const Page2();
        break;
      default:
        page = Text("Undefined route");
        break;
    }
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration(milliseconds: 1000),
    reverseTransitionDuration: Duration(milliseconds: 1000),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var event = TransitionEventDetector.detect(animation, secondaryAnimation);
      print("4444 ${routeSettings.name} ${event.name}");
      switch(event){
        case TransitionEvent.NONE:
          return child;
          break;
        case TransitionEvent.ENTER:
          const begin = Offset(1, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
          break;
        case TransitionEvent.EXIT:
          const begin = Offset.zero;
          const end = Offset(-1, 0.0);
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = secondaryAnimation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
          break;
        case TransitionEvent.POP_ENTER:
          const begin = Offset.zero;
          const end = Offset(-1, 0.0);
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = secondaryAnimation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
          break;
        case TransitionEvent.POP_EXIT:
          const begin = Offset(1, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
          break;
      }
    }
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Page1"),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed("page2");
                },
                child: Text("Go")
            )
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Page2"),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Back")
            )
          ],
        ),
      ),
    );
  }
}

enum TransitionEvent{
  NONE,
  ENTER,
  EXIT,
  POP_ENTER,
  POP_EXIT
}

class TransitionEventDetector{
  static TransitionEvent detect(Animation<double> animation, Animation<double> secondaryAnimation){
    TransitionEvent event = TransitionEvent.NONE;
    var self = animation.status;
    var other = secondaryAnimation.status;
    if(other==AnimationStatus.forward){
      event = TransitionEvent.EXIT;
    }
    else if(self==AnimationStatus.completed && other==AnimationStatus.reverse){
      event = TransitionEvent.POP_ENTER;
    }
    else if(self==AnimationStatus.forward && other==AnimationStatus.dismissed){
      event = TransitionEvent.ENTER;
    }
    else if(self==AnimationStatus.reverse && other==AnimationStatus.dismissed){
      event = TransitionEvent.POP_EXIT;
    }
    return event;
  }
}

