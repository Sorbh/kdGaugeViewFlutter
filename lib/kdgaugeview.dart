import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

class KdGaugeView extends StatefulWidget {
  const KdGaugeView(
      {GlobalKey? key,
      this.speed = 0,
      this.speedTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 60,
        fontWeight: FontWeight.bold,
      ),
      this.unitOfMeasurement = 'Km/Hr',
      this.unitOfMeasurementTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
      required this.minSpeed,
      required this.maxSpeed,
      this.minMaxTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      this.alertSpeedArray = const [],
      this.alertColorArray = const [],
      this.gaugeWidth = 10,
      this.baseGaugeColor = Colors.transparent,
      this.inactiveGaugeColor = Colors.black87,
      this.activeGaugeColor = Colors.green,
      this.innerCirclePadding = 30,
      this.divisionCircleColors = Colors.blue,
      this.subDivisionCircleColors = Colors.blue,
      this.animate = false,
      this.duration = const Duration(milliseconds: 400),
      this.fractionDigits = 0,
      this.child,
      this.activeGaugeGradientColor})
      : assert(alertSpeedArray.length == alertColorArray.length, 'Alert speed array length should be equal to Alert Speed Color Array length'),
        super(key: key);

  final double speed;
  final TextStyle speedTextStyle;

  final String unitOfMeasurement;
  final TextStyle unitOfMeasurementTextStyle;

  final double minSpeed;
  final double maxSpeed;
  final TextStyle minMaxTextStyle;

  final List<double> alertSpeedArray;
  final List<Color> alertColorArray;

  final double gaugeWidth;
  final Color baseGaugeColor;
  final Color inactiveGaugeColor;
  final Color activeGaugeColor;
  final ui.Gradient? activeGaugeGradientColor;

  final double innerCirclePadding;

  final Color subDivisionCircleColors;
  final Color divisionCircleColors;

  final bool animate;
  final Duration duration;
  final int fractionDigits;

  final Widget? child;

  @override
  KdGaugeViewState createState() => KdGaugeViewState();
}

class KdGaugeViewState extends State<KdGaugeView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _speed = 0;
  bool _animate = false;

  double lastMarkSpeed = 0;
  double _gaugeMarkSpeed = 0;

  @override
  void initState() {
    _speed = widget.speed;
    _animate = widget.animate;

    if (_animate) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        updateSpeed(_speed, animate: _animate);
      });
    } else {
      lastMarkSpeed = _speed;
      _gaugeMarkSpeed = _speed;
    }

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _gaugeMarkSpeed = lastMarkSpeed + (_speed - lastMarkSpeed) * _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          lastMarkSpeed = _gaugeMarkSpeed;
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _KdGaugeCustomPainter(
          _gaugeMarkSpeed,
          widget.speedTextStyle,
          widget.unitOfMeasurement,
          widget.unitOfMeasurementTextStyle,
          widget.minSpeed,
          widget.maxSpeed,
          widget.minMaxTextStyle,
          widget.alertSpeedArray,
          widget.alertColorArray,
          widget.gaugeWidth,
          widget.baseGaugeColor,
          widget.inactiveGaugeColor,
          widget.activeGaugeColor,
          widget.innerCirclePadding,
          widget.divisionCircleColors,
          widget.subDivisionCircleColors,
          widget.fractionDigits,
          widget.activeGaugeGradientColor),
      child: widget.child ?? Container(),
    );
  }

  void updateSpeed(double speed, {bool animate = false, Duration? duration}) {
    if (animate) {
      _speed = speed;
      _controller.reset();
      if (duration != null) _controller.duration = duration;
      _controller.forward();
    } else {
      setState(() {
        lastMarkSpeed = speed;
      });
    }
  }
}

class _KdGaugeCustomPainter extends CustomPainter {
  _KdGaugeCustomPainter(
      this.speed,
      this.speedTextStyle,
      this.unitOfMeasurement,
      this.unitOfMeasurementTextStyle,
      this.minSpeed,
      this.maxSpeed,
      this.minMaxTextStyle,
      this.alertSpeedArray,
      this.alertColorArray,
      this.gaugeWidth,
      this.baseGaugeColor,
      this.inactiveGaugeColor,
      this.activeGaugeColor,
      this.innerCirclePadding,
      this.subDivisionCircleColors,
      this.divisionCircleColors,
      this.fractionDigits,
      this.activeGaugeGradientColor);

  //We are considering this start angle starting point for gauge view
  final double arcStartAngle = 135;
  final double arcSweepAngle = 270;

  final double speed;
  final TextStyle speedTextStyle;

  final String unitOfMeasurement;
  final TextStyle unitOfMeasurementTextStyle;

  final double minSpeed;
  final double maxSpeed;
  final TextStyle minMaxTextStyle;

  final List<double> alertSpeedArray;
  final List<Color> alertColorArray;

  final double gaugeWidth;
  final Color baseGaugeColor;
  final Color inactiveGaugeColor;
  final Color activeGaugeColor;
  final ui.Gradient? activeGaugeGradientColor;

  final double innerCirclePadding;

  final Color subDivisionCircleColors;
  final Color divisionCircleColors;

  Offset? center;
  double mRadius = 200;
  double mDottedCircleRadius = 0;

  final int fractionDigits;

  @override
  void paint(Canvas canvas, Size size) {
    //get the center of the view
    center = size.center(const Offset(0, 0));

    double minDimension = size.width > size.height ? size.height : size.width;
    mRadius = minDimension / 2;

    mDottedCircleRadius = mRadius - innerCirclePadding;

    Paint paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = gaugeWidth;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    //Draw base gauge
    canvas.drawCircle(center!, mRadius, paint..color = baseGaugeColor);

    //Draw inactive gauge view
    canvas.drawArc(Rect.fromCircle(center: center!, radius: mRadius), degToRad(arcStartAngle) as double, degToRad(arcSweepAngle) as double, false,
        paint..color = Colors.grey.withOpacity(.4));

    if (activeGaugeGradientColor == null) {
      //Draw active gauge view
      if (alertSpeedArray.isNotEmpty) {
        for (int i = 0; alertSpeedArray.length > i; i++) {
          if (i == 0 && speed <= alertSpeedArray[i]) {
            paint.color = activeGaugeColor;
          } else if (i == alertSpeedArray.length - 1 && speed >= alertSpeedArray[i]) {
            paint.color = alertColorArray[i];
          } else if (alertSpeedArray[i] <= speed && speed <= alertSpeedArray[i + 1]) {
            paint.color = alertColorArray[i];
            break;
          } else {
            paint.color = activeGaugeColor;
          }
        }
      } else {
        paint.color = activeGaugeColor;
      }
    } else {
      //if gradient is available, use the gradient color
      paint.shader = activeGaugeGradientColor;
    }

    canvas.drawArc(Rect.fromCircle(center: center!, radius: mRadius), degToRad(arcStartAngle) as double, degToRad(_getAngleOfSpeed(speed)) as double,
        false, paint);

    //Going to draw division, Subdivision and Alert Circle
    paint.style = PaintingStyle.fill;

    //draw division dots circle(big one)
    paint.color = divisionCircleColors;
    for (double i = 0; 270 >= i; i = i + 45) {
      canvas.drawCircle(_getDegreeOffsetOnCircle(mDottedCircleRadius, i + arcStartAngle), minDimension * .012, paint);
    }

    //draw subDivision dots circle(small one)
    paint.color = subDivisionCircleColors;

    for (double i = 0; 270 >= i; i = i + 5) {
      canvas.drawCircle(_getDegreeOffsetOnCircle(mDottedCircleRadius, i + arcStartAngle), minDimension * .005, paint);
    }

    //Draw alert indicator
    for (int i = 0; alertSpeedArray.length > i; i++) {
      paint.color = alertColorArray[i];
      canvas.drawCircle(
          _getDegreeOffsetOnCircle(mDottedCircleRadius, _getAngleOfSpeed(alertSpeedArray[i]) + arcStartAngle), minDimension * .015, paint);
    }

    //Draw Min Text
    _drawMinText(canvas, size);
    //Draw Max Text
    _drawMaxText(canvas, size);

    //Draw Unit of Measurement
    _drawUnitOfMeasurementText(canvas, size);

    //Draw Speed Text
    _drawSpeedText(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }

  Offset _getDegreeOffsetOnCircle(double radius, double angle) {
    double radian = degToRad(angle) as double;
    double dx = (center!.dx + radius * math.cos(radian));
    double dy = (center!.dy + radius * math.sin(radian));
    return Offset(dx, dy);
  }

  double _getAngleOfSpeed(double speed) {
    //limit speed to max speed
    return ((speed < maxSpeed ? speed : maxSpeed) - minSpeed) / ((maxSpeed - minSpeed) / arcSweepAngle);
  }

  void _drawMinText(Canvas canvas, Size size) {
    TextSpan span = TextSpan(style: minMaxTextStyle, text: minSpeed.toStringAsFixed(fractionDigits));
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    //Get the start point of Gauge
    Offset offset = _getDegreeOffsetOnCircle(mDottedCircleRadius, arcStartAngle);
    //translate textPainter offset to bottom anchor the start point of the gauge
    offset = offset.translate(0, -textPainter.height);
    textPainter.paint(canvas, offset);
  }

  void _drawMaxText(Canvas canvas, Size size) {
    TextSpan span = TextSpan(style: minMaxTextStyle, text: maxSpeed.toStringAsFixed(fractionDigits));
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    //Get the end point of Gauge
    Offset offset = _getDegreeOffsetOnCircle(mDottedCircleRadius, arcStartAngle + arcSweepAngle);
    //translate textPainter offset to bottom anchor the start point of the gauge
    offset = offset.translate(-textPainter.width, -textPainter.height);
    textPainter.paint(canvas, offset);
  }

  void _drawUnitOfMeasurementText(Canvas canvas, Size size) {
    //Get the center point of the minSpeed and maxSpeed label
    //that would be center of the unit of measurement text
    Offset minTextOffset = _getDegreeOffsetOnCircle(mDottedCircleRadius, arcStartAngle);

    Offset unitOfMeasurementOffset = Offset(size.width / 2, minTextOffset.dy);

    TextSpan span = TextSpan(style: unitOfMeasurementTextStyle, text: unitOfMeasurement);
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    unitOfMeasurementOffset = unitOfMeasurementOffset.translate(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, unitOfMeasurementOffset);
  }

  void _drawSpeedText(Canvas canvas, Size size) {
    //We are going to draw this text in the center of the widget

    Offset? unitOfMeasurementOffset = center;

    TextSpan span = TextSpan(style: speedTextStyle, text: speed.toStringAsFixed(fractionDigits));
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    unitOfMeasurementOffset = center!.translate(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, unitOfMeasurementOffset);
  }

  static num degToRad(num deg) => deg * (math.pi / 180.0);
}
