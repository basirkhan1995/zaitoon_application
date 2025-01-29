import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class Env {
  static Future<Uint8List?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.bytes != null) {
      return result.files.single.bytes; // Return the bytes if available
    } else if (result != null && result.files.single.path != null) {
      return await File(result.files.single.path!)
          .readAsBytes(); // Return the bytes from the file path
    }
    return null;
  }

  static gregorianDateTimeForm(String date) {
    final format = DateTime.parse(date);
    final gregorian = DateFormat('dd/MM/yyyy H:mm:ss aa').format(format);
    return gregorian;
  }

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
