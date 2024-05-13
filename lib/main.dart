import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TemperatureHumidityMonitor(),
    );
  }
}

class TemperatureHumidityMonitor extends StatefulWidget {
  @override
  _TemperatureHumidityMonitorState createState() =>
      _TemperatureHumidityMonitorState();
}

class _TemperatureHumidityMonitorState extends State<TemperatureHumidityMonitor> with TickerProviderStateMixin {
  late AnimationController temperatureController;
  late AnimationController humidityController;

  final double currentTemperature = 25; // Replace with actual temperature value
  final double currentHumidity = 50; // Replace with actual humidity value

  @override
  void initState() {
    super.initState();
    temperatureController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    humidityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    temperatureController.forward(from: 0.0);
    humidityController.forward(from: 0.0);
  }

  @override
  void dispose() {
    temperatureController.dispose();
    humidityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature & Humidity Monitor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Temperature:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularIndicator(
              controller: temperatureController,
              value: currentTemperature / 100,
              label: '${currentTemperature.toInt()}°C',
            ),
            SizedBox(height: 20),
            Text(
              'Current Humidity:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularIndicator(
              controller: humidityController,
              value: currentHumidity / 100,
              label: '${currentHumidity.toInt()}%',
            ),
          ],
        ),
      ),
    );
  }
}

class CircularIndicator extends StatelessWidget {
  final AnimationController controller;
  final double value;
  final String label;

  CircularIndicator({
    required this.controller,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: _CircularIndicatorPainter(
              value: value * controller.value,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircularIndicatorPainter extends CustomPainter {
  final double value;

  _CircularIndicatorPainter({
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 12;
    final double radius = size.width / 2 - strokeWidth;

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, backgroundPaint);

    final double startAngle = -pi / 2;
    final double endAngle = 2 * pi * value;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularIndicatorPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
