import 'package:flutter/material.dart';

Future<dynamic> showCustomBottomSheet(BuildContext context, Widget widget) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    )),
    context: context,
    useRootNavigator: true,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPaint(
              size: const Size(30, 5),
              painter: ShapePainter(),
            ),
          ),
          widget,
        ],
      );
    },
  );
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 15;

    Offset start = Offset(0, 0);
    Offset end = Offset(size.width, size.height);
    Rect rect = Rect.fromPoints(start, end);
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(15));

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
