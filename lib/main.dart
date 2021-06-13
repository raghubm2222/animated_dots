import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier<CustomPainter>(Painter());
    _pause = ValueNotifier<bool?>(false);
    _timer = Timer.periodic(Duration(milliseconds: 1), (_) {
      if (!_pause!.value!) {
        _notifier!.value = Painter();
      }
    });
  }

  Timer? _timer;

  ValueNotifier<CustomPainter?>? _notifier;
  ValueNotifier<bool?>? _pause;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder<bool?>(
          valueListenable: _pause!,
          builder: (context, _isPause, _) {
            return FloatingActionButton.extended(
              onPressed: () {
                _pause!.value = !_pause!.value!;
              },
              label: Row(
                children: [
                  Icon(
                    _isPause! ? Icons.play_arrow : Icons.pause,
                    color: Colors.white,
                  ),
                  Text('${_isPause ? "Play" : "Stop"} Animation'),
                ],
              ),
            );
          }),
      body: Container(
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: ValueListenableBuilder<CustomPainter?>(
            valueListenable: _notifier!,
            builder: (context, _painter, _) {
              return CustomPaint(
                isComplex: true,
                willChange: true,
                painter: _painter,
              );
            },
          ),
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;

    var paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    canvas.drawPoints(
        PointMode.points,
        [
          for (int i = 0; i < width.toInt(); i++)
            Offset(Random().nextInt(width.toInt()).toDouble(),
                Random().nextInt(height.toInt()).toDouble()),
        ],
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
