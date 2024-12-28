import 'dart:ffi';

import 'package:flutter/material.dart';

void navigatePush(BuildContext context, Widget destination, {String direction = 'right'}) {
  Offset begin;
  
  switch(direction) {
    case 'left':
      begin = Offset(-1.0, 0.0);
      break;
    case 'top':
      begin = Offset(0.0, -1.0);
      break;
    case 'bottom':
      begin = Offset(0.0, 1.0);
      break;
    case 'right':
    default:
      begin = Offset(1.0, 0.0);
  }

  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

