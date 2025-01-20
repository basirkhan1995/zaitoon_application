import 'package:flutter/material.dart';

class Env {
  //Push and remove previous routes
  static gotoReplacement(context, Widget route) {
    Navigator.of(context).popUntil((route) => false);
    Navigator.push(context, _animatedRouting(route));
  }

  static Route _animatedRouting(Widget route) {
    return PageRouteBuilder(
      allowSnapshotting: true,
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from the right
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static goto(context, Widget route) {
    return Navigator.of(context).push(_animatedRouting(route));
  }
}
