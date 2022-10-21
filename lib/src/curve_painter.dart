part of circular_slider;

class _CurvePainter extends CustomPainter {
  final double angle;
  final CircularSliderAppearance appearance;
  final double startAngle;
  final double angleRange;
  final double? targetAngle;

  Offset? handler;
  Offset? center;
  late double radius;

  _CurvePainter({
    required this.appearance,
    this.angle = 30,
    required this.startAngle,
    required this.angleRange,
    this.targetAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    radius = math.min(size.width / 2, size.height / 2) -
        appearance.progressBarWidth * 0.5;
    center = Offset(size.width / 2, size.height / 2);

    final progressBarRect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);

    Paint trackPaint;
    if (appearance.trackColors != null) {
      final trackGradient = SweepGradient(
        startAngle: degreeToRadians(appearance.trackGradientStartAngle),
        endAngle: degreeToRadians(appearance.trackGradientStopAngle),
        tileMode: TileMode.mirror,
        colors: appearance.trackColors!,
      );
      trackPaint = Paint()
        ..shader = trackGradient.createShader(progressBarRect)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = appearance.trackWidth;
    } else {
      trackPaint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = appearance.trackWidth
        ..color = appearance.trackColor;
    }
    drawCircularArc(
        canvas: canvas,
        size: size,
        paint: trackPaint,
        ignoreAngle: true,
        spinnerMode: appearance.spinnerMode);

    if (!appearance.hideShadow) {
      drawShadow(canvas: canvas, size: size);
    }

    final currentAngle = appearance.counterClockwise ? -angle : angle;
    final dynamicGradient = appearance.dynamicGradient;
    final gradientRotationAngle = dynamicGradient
        ? appearance.counterClockwise
            ? startAngle + 10.0
            : startAngle - 10.0
        : 0.0;
    final GradientRotation rotation =
        GradientRotation(degreeToRadians(gradientRotationAngle));

    final gradientStartAngle = dynamicGradient
        ? appearance.counterClockwise
            ? 360.0 - currentAngle.abs()
            : 0.0
        : appearance.gradientStartAngle;
    final gradientEndAngle = dynamicGradient
        ? appearance.counterClockwise
            ? 360.0
            : currentAngle.abs()
        : appearance.gradientStopAngle;
    final colors = dynamicGradient && appearance.counterClockwise
        ? appearance.progressBarColors.reversed.toList()
        : appearance.progressBarColors;

    final progressBarGradient = kIsWeb
        ? LinearGradient(
            tileMode: TileMode.mirror,
            colors: colors,
          )
        : SweepGradient(
            transform: rotation,
            startAngle: degreeToRadians(gradientStartAngle),
            endAngle: degreeToRadians(gradientEndAngle),
            tileMode: TileMode.mirror,
            colors: colors,
          );

    final progressBarPaint = Paint()
      ..shader = progressBarGradient.createShader(progressBarRect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = appearance.progressBarWidth;
    drawCircularArc(canvas: canvas, size: size, paint: progressBarPaint);

    var dotPaint = Paint()..color = appearance.dotColor;

    Offset handler = degreesToCoordinates(
        center!, -math.pi / 2 + startAngle + currentAngle + 1.5, radius);
    canvas.drawCircle(handler, appearance.handlerSize, dotPaint);

    if (targetAngle != null) {
      Offset handler2 =
          degreesToCoordinates(center!, targetAngle! - 6.5, radius + 30);

      canvas.translate(handler2.dx, handler2.dy);
      canvas.rotate((targetAngle! * math.pi / 180) + math.pi / 2);
      RPSCustomPainter().paint(canvas, Size(50, 50));
    }
  }

  drawCircularArc(
      {required Canvas canvas,
      required Size size,
      required Paint paint,
      bool ignoreAngle = false,
      bool spinnerMode = false}) {
    final double angleValue = ignoreAngle ? 0 : (angleRange - angle);
    final range = appearance.counterClockwise ? -angleRange : angleRange;
    final currentAngle = appearance.counterClockwise ? angleValue : -angleValue;
    canvas.drawArc(
        Rect.fromCircle(center: center!, radius: radius),
        degreeToRadians(spinnerMode ? 0 : startAngle),
        degreeToRadians(spinnerMode ? 360 : range + currentAngle),
        false,
        paint);
  }

  drawShadow({required Canvas canvas, required Size size}) {
    final shadowStep = appearance.shadowStep != null
        ? appearance.shadowStep!
        : math.max(
            1, (appearance.shadowWidth - appearance.progressBarWidth) ~/ 10);
    final maxOpacity = math.min(1.0, appearance.shadowMaxOpacity);
    final repetitions = math.max(1,
        ((appearance.shadowWidth - appearance.progressBarWidth) ~/ shadowStep));
    final opacityStep = maxOpacity / repetitions;
    final shadowPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (int i = 1; i <= repetitions; i++) {
      shadowPaint.strokeWidth = appearance.progressBarWidth + i * shadowStep;
      shadowPaint.color = appearance.shadowColor
          .withOpacity(maxOpacity - (opacityStep * (i - 1)));
      drawCircularArc(canvas: canvas, size: size, paint: shadowPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5301035, size.height * 0.6014492);
    path_0.lineTo(size.width * 0.5301035, size.height * 0.1425781);
    path_0.cubicTo(
        size.width * 0.5301035,
        size.height * 0.07191406,
        size.width * 0.4728184,
        size.height * 0.01462891,
        size.width * 0.4021543,
        size.height * 0.01462891);
    path_0.cubicTo(
        size.width * 0.3314902,
        size.height * 0.01462891,
        size.width * 0.2742051,
        size.height * 0.07191406,
        size.width * 0.2742051,
        size.height * 0.1425781);
    path_0.lineTo(size.width * 0.2742051, size.height * 0.6014492);
    path_0.cubicTo(
        size.width * 0.2224023,
        size.height * 0.6403555,
        size.width * 0.1888867,
        size.height * 0.7022910,
        size.width * 0.1888867,
        size.height * 0.7720645);
    path_0.cubicTo(
        size.width * 0.1888867,
        size.height * 0.8898496,
        size.width * 0.2843691,
        size.height * 0.9853320,
        size.width * 0.4021543,
        size.height * 0.9853320);
    path_0.cubicTo(
        size.width * 0.5199375,
        size.height * 0.9853320,
        size.width * 0.6154219,
        size.height * 0.8898496,
        size.width * 0.6154219,
        size.height * 0.7720645);
    path_0.cubicTo(
        size.width * 0.6154219,
        size.height * 0.7022910,
        size.width * 0.5819062,
        size.height * 0.6403574,
        size.width * 0.5301035,
        size.height * 0.6014492);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xfff1faff).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5301035, size.height * 0.6014492);
    path_1.lineTo(size.width * 0.5301035, size.height * 0.1425781);
    path_1.cubicTo(
        size.width * 0.5301035,
        size.height * 0.07191406,
        size.width * 0.4728184,
        size.height * 0.01462891,
        size.width * 0.4021543,
        size.height * 0.01462891);
    path_1.cubicTo(
        size.width * 0.3897480,
        size.height * 0.01462891,
        size.width * 0.3777539,
        size.height * 0.01639453,
        size.width * 0.3664102,
        size.height * 0.01968750);
    path_1.cubicTo(
        size.width * 0.4196797,
        size.height * 0.03515625,
        size.width * 0.4586152,
        size.height * 0.08432031,
        size.width * 0.4586152,
        size.height * 0.1425781);
    path_1.lineTo(size.width * 0.4586152, size.height * 0.6014492);
    path_1.cubicTo(
        size.width * 0.5104180,
        size.height * 0.6403555,
        size.width * 0.5439336,
        size.height * 0.7022910,
        size.width * 0.5439336,
        size.height * 0.7720645);
    path_1.cubicTo(
        size.width * 0.5439336,
        size.height * 0.8776680,
        size.width * 0.4671777,
        size.height * 0.9653438,
        size.width * 0.3664102,
        size.height * 0.9823477);
    path_1.cubicTo(
        size.width * 0.3780332,
        size.height * 0.9843086,
        size.width * 0.3899746,
        size.height * 0.9853301,
        size.width * 0.4021543,
        size.height * 0.9853301);
    path_1.cubicTo(
        size.width * 0.5199375,
        size.height * 0.9853301,
        size.width * 0.6154219,
        size.height * 0.8898477,
        size.width * 0.6154219,
        size.height * 0.7720625);
    path_1.cubicTo(
        size.width * 0.6154219,
        size.height * 0.7022910,
        size.width * 0.5819062,
        size.height * 0.6403574,
        size.width * 0.5301035,
        size.height * 0.6014492);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffdcf5ff).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.4411621, size.height * 0.6471504);
    path_2.lineTo(size.width * 0.4411621, size.height * 0.1459551);
    path_2.cubicTo(
        size.width * 0.4411621,
        size.height * 0.1244121,
        size.width * 0.4236992,
        size.height * 0.1069492,
        size.width * 0.4021562,
        size.height * 0.1069492);
    path_2.cubicTo(
        size.width * 0.3806133,
        size.height * 0.1069492,
        size.width * 0.3631504,
        size.height * 0.1244121,
        size.width * 0.3631504,
        size.height * 0.1459551);
    path_2.lineTo(size.width * 0.3631504, size.height * 0.6471543);
    path_2.cubicTo(
        size.width * 0.3095488,
        size.height * 0.6643008,
        size.width * 0.2713008,
        size.height * 0.7157754,
        size.width * 0.2743809,
        size.height * 0.7757441);
    path_2.cubicTo(
        size.width * 0.2777324,
        size.height * 0.8409922,
        size.width * 0.3307871,
        size.height * 0.8937695,
        size.width * 0.3960508,
        size.height * 0.8968027);
    path_2.cubicTo(
        size.width * 0.4694922,
        size.height * 0.9002168,
        size.width * 0.5301055,
        size.height * 0.8416855,
        size.width * 0.5301055,
        size.height * 0.7689961);
    path_2.cubicTo(
        size.width * 0.5301035,
        size.height * 0.7119395,
        size.width * 0.4927422,
        size.height * 0.6636484,
        size.width * 0.4411621,
        size.height * 0.6471504);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff7ba0b0).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.4411621, size.height * 0.6283691);
    path_3.lineTo(size.width * 0.4411621, size.height * 0.3313184);
    path_3.lineTo(size.width * 0.3631484, size.height * 0.3313184);
    path_3.lineTo(size.width * 0.3631484, size.height * 0.6283770);
    path_3.cubicTo(
        size.width * 0.3631484,
        size.height * 0.6390645,
        size.width * 0.3570117,
        size.height * 0.6488125,
        size.width * 0.3473574,
        size.height * 0.6533945);
    path_3.cubicTo(
        size.width * 0.3029297,
        size.height * 0.6744805,
        size.width * 0.2725742,
        size.height * 0.7203809,
        size.width * 0.2742734,
        size.height * 0.7732109);
    path_3.cubicTo(
        size.width * 0.2764043,
        size.height * 0.8394707,
        size.width * 0.3298281,
        size.height * 0.8937227,
        size.width * 0.3960488,
        size.height * 0.8967988);
    path_3.cubicTo(
        size.width * 0.4694902,
        size.height * 0.9002129,
        size.width * 0.5301035,
        size.height * 0.8416797,
        size.width * 0.5301035,
        size.height * 0.7689922);
    path_3.cubicTo(
        size.width * 0.5301035,
        size.height * 0.7178770,
        size.width * 0.5001152,
        size.height * 0.6737969,
        size.width * 0.4567832,
        size.height * 0.6533105);
    path_3.cubicTo(
        size.width * 0.4471816,
        size.height * 0.6487715,
        size.width * 0.4411621,
        size.height * 0.6389902,
        size.width * 0.4411621,
        size.height * 0.6283691);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xfffa4954).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.4567832, size.height * 0.6533105);
    path_4.cubicTo(
        size.width * 0.4471816,
        size.height * 0.6487715,
        size.width * 0.4411602,
        size.height * 0.6389902,
        size.width * 0.4411602,
        size.height * 0.6283691);
    path_4.lineTo(size.width * 0.4411602, size.height * 0.3313184);
    path_4.lineTo(size.width * 0.3631465, size.height * 0.3313184);
    path_4.lineTo(size.width * 0.3631465, size.height * 0.6186387);
    path_4.cubicTo(
        size.width * 0.3631465,
        size.height * 0.6211230,
        size.width * 0.3649961,
        size.height * 0.6470391,
        size.width * 0.3768496,
        size.height * 0.6533105);
    path_4.cubicTo(
        size.width * 0.4192148,
        size.height * 0.6757305,
        size.width * 0.4501699,
        size.height * 0.7178789,
        size.width * 0.4501699,
        size.height * 0.7689922);
    path_4.cubicTo(
        size.width * 0.4501699,
        size.height * 0.8256777,
        size.width * 0.4133086,
        size.height * 0.8737520,
        size.width * 0.3622480,
        size.height * 0.8905566);
    path_4.cubicTo(
        size.width * 0.3729687,
        size.height * 0.8941016,
        size.width * 0.3843066,
        size.height * 0.8962559,
        size.width * 0.3960469,
        size.height * 0.8968008);
    path_4.cubicTo(
        size.width * 0.4694883,
        size.height * 0.9002148,
        size.width * 0.5301016,
        size.height * 0.8416816,
        size.width * 0.5301016,
        size.height * 0.7689922);
    path_4.cubicTo(
        size.width * 0.5301035,
        size.height * 0.7178789,
        size.width * 0.5001172,
        size.height * 0.6737988,
        size.width * 0.4567832,
        size.height * 0.6533105);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xfffa2a3b).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.6850156, size.height * 0.1079297);
    path_5.lineTo(size.width * 0.8083535, size.height * 0.1079297);
    path_5.cubicTo(
        size.width * 0.8164434,
        size.height * 0.1079297,
        size.width * 0.8230020,
        size.height * 0.1013730,
        size.width * 0.8230020,
        size.height * 0.09328125);
    path_5.cubicTo(
        size.width * 0.8230020,
        size.height * 0.08518945,
        size.width * 0.8164453,
        size.height * 0.07863281,
        size.width * 0.8083535,
        size.height * 0.07863281);
    path_5.lineTo(size.width * 0.6850156, size.height * 0.07863281);
    path_5.cubicTo(
        size.width * 0.6769258,
        size.height * 0.07863281,
        size.width * 0.6703672,
        size.height * 0.08518945,
        size.width * 0.6703672,
        size.height * 0.09328125);
    path_5.cubicTo(
        size.width * 0.6703672,
        size.height * 0.1013730,
        size.width * 0.6769238,
        size.height * 0.1079297,
        size.width * 0.6850156,
        size.height * 0.1079297);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.6850156, size.height * 0.2269531);
    path_6.lineTo(size.width * 0.7698184, size.height * 0.2269531);
    path_6.cubicTo(
        size.width * 0.7779082,
        size.height * 0.2269531,
        size.width * 0.7844668,
        size.height * 0.2203965,
        size.width * 0.7844668,
        size.height * 0.2123047);
    path_6.cubicTo(
        size.width * 0.7844668,
        size.height * 0.2042148,
        size.width * 0.7779102,
        size.height * 0.1976563,
        size.width * 0.7698184,
        size.height * 0.1976563);
    path_6.lineTo(size.width * 0.6850156, size.height * 0.1976563);
    path_6.cubicTo(
        size.width * 0.6769258,
        size.height * 0.1976563,
        size.width * 0.6703672,
        size.height * 0.2042129,
        size.width * 0.6703672,
        size.height * 0.2123047);
    path_6.cubicTo(
        size.width * 0.6703672,
        size.height * 0.2203945,
        size.width * 0.6769238,
        size.height * 0.2269531,
        size.width * 0.6850156,
        size.height * 0.2269531);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.8083535, size.height * 0.3166777);
    path_7.lineTo(size.width * 0.6850156, size.height * 0.3166777);
    path_7.cubicTo(
        size.width * 0.6769258,
        size.height * 0.3166777,
        size.width * 0.6703672,
        size.height * 0.3232344,
        size.width * 0.6703672,
        size.height * 0.3313262);
    path_7.cubicTo(
        size.width * 0.6703672,
        size.height * 0.3394180,
        size.width * 0.6769238,
        size.height * 0.3459746,
        size.width * 0.6850156,
        size.height * 0.3459746);
    path_7.lineTo(size.width * 0.8083535, size.height * 0.3459746);
    path_7.cubicTo(
        size.width * 0.8164434,
        size.height * 0.3459746,
        size.width * 0.8230020,
        size.height * 0.3394180,
        size.width * 0.8230020,
        size.height * 0.3313262);
    path_7.cubicTo(
        size.width * 0.8230020,
        size.height * 0.3232344,
        size.width * 0.8164434,
        size.height * 0.3166777,
        size.width * 0.8083535,
        size.height * 0.3166777);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.6850156, size.height * 0.4649961);
    path_8.lineTo(size.width * 0.7698184, size.height * 0.4649961);
    path_8.cubicTo(
        size.width * 0.7779082,
        size.height * 0.4649961,
        size.width * 0.7844668,
        size.height * 0.4584395,
        size.width * 0.7844668,
        size.height * 0.4503477);
    path_8.cubicTo(
        size.width * 0.7844668,
        size.height * 0.4422578,
        size.width * 0.7779102,
        size.height * 0.4356992,
        size.width * 0.7698184,
        size.height * 0.4356992);
    path_8.lineTo(size.width * 0.6850156, size.height * 0.4356992);
    path_8.cubicTo(
        size.width * 0.6769258,
        size.height * 0.4356992,
        size.width * 0.6703672,
        size.height * 0.4422559,
        size.width * 0.6703672,
        size.height * 0.4503477);
    path_8.cubicTo(
        size.width * 0.6703672,
        size.height * 0.4584375,
        size.width * 0.6769238,
        size.height * 0.4649961,
        size.width * 0.6850156,
        size.height * 0.4649961);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.8083535, size.height * 0.5547207);
    path_9.lineTo(size.width * 0.6850156, size.height * 0.5547207);
    path_9.cubicTo(
        size.width * 0.6769258,
        size.height * 0.5547207,
        size.width * 0.6703672,
        size.height * 0.5612773,
        size.width * 0.6703672,
        size.height * 0.5693691);
    path_9.cubicTo(
        size.width * 0.6703672,
        size.height * 0.5774590,
        size.width * 0.6769238,
        size.height * 0.5840176,
        size.width * 0.6850156,
        size.height * 0.5840176);
    path_9.lineTo(size.width * 0.8083535, size.height * 0.5840176);
    path_9.cubicTo(
        size.width * 0.8164434,
        size.height * 0.5840176,
        size.width * 0.8230020,
        size.height * 0.5774609,
        size.width * 0.8230020,
        size.height * 0.5693691);
    path_9.cubicTo(
        size.width * 0.8230000,
        size.height * 0.5612773,
        size.width * 0.8164434,
        size.height * 0.5547207,
        size.width * 0.8083535,
        size.height * 0.5547207);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5447500, size.height * 0.5942715);
    path_10.lineTo(size.width * 0.5447500, size.height * 0.1425918);
    path_10.cubicTo(size.width * 0.5447500, size.height * 0.06396680,
        size.width * 0.4807832, 0, size.width * 0.4021582, 0);
    path_10.cubicTo(
        size.width * 0.3235332,
        0,
        size.width * 0.2595664,
        size.height * 0.06396680,
        size.width * 0.2595664,
        size.height * 0.1425918);
    path_10.lineTo(size.width * 0.2595664, size.height * 0.5942734);
    path_10.cubicTo(
        size.width * 0.2153828,
        size.height * 0.6297051,
        size.width * 0.1862305,
        size.height * 0.6795352,
        size.width * 0.1771895,
        size.height * 0.7353809);
    path_10.cubicTo(
        size.width * 0.1758965,
        size.height * 0.7433672,
        size.width * 0.1813223,
        size.height * 0.7508887,
        size.width * 0.1893086,
        size.height * 0.7521797);
    path_10.cubicTo(
        size.width * 0.1972754,
        size.height * 0.7534805,
        size.width * 0.2048164,
        size.height * 0.7480488,
        size.width * 0.2061094,
        size.height * 0.7400605);
    path_10.cubicTo(
        size.width * 0.2143262,
        size.height * 0.6893008,
        size.width * 0.2416367,
        size.height * 0.6442324,
        size.width * 0.2830098,
        size.height * 0.6131563);
    path_10.cubicTo(
        size.width * 0.2866934,
        size.height * 0.6103887,
        size.width * 0.2888594,
        size.height * 0.6060488,
        size.width * 0.2888594,
        size.height * 0.6014434);
    path_10.lineTo(size.width * 0.2888594, size.height * 0.1425918);
    path_10.cubicTo(
        size.width * 0.2888594,
        size.height * 0.08012109,
        size.width * 0.3396836,
        size.height * 0.02929688,
        size.width * 0.4021562,
        size.height * 0.02929688);
    path_10.cubicTo(
        size.width * 0.4646289,
        size.height * 0.02929688,
        size.width * 0.5154512,
        size.height * 0.08012109,
        size.width * 0.5154512,
        size.height * 0.1425918);
    path_10.lineTo(size.width * 0.5154512, size.height * 0.6014453);
    path_10.cubicTo(
        size.width * 0.5154512,
        size.height * 0.6060508,
        size.width * 0.5176172,
        size.height * 0.6103906,
        size.width * 0.5213027,
        size.height * 0.6131582);
    path_10.cubicTo(
        size.width * 0.5718008,
        size.height * 0.6510859,
        size.width * 0.6007656,
        size.height * 0.7090020,
        size.width * 0.6007656,
        size.height * 0.7720547);
    path_10.cubicTo(
        size.width * 0.6007656,
        size.height * 0.9420332,
        size.width * 0.4004512,
        size.height * 1.032408,
        size.width * 0.2728203,
        size.height * 0.9227871);
    path_10.cubicTo(
        size.width * 0.2372480,
        size.height * 0.8922344,
        size.width * 0.2135547,
        size.height * 0.8500664,
        size.width * 0.2061074,
        size.height * 0.8040527);
    path_10.cubicTo(
        size.width * 0.2048145,
        size.height * 0.7960645,
        size.width * 0.1972891,
        size.height * 0.7906230,
        size.width * 0.1893066,
        size.height * 0.7919336);
    path_10.cubicTo(
        size.width * 0.1813203,
        size.height * 0.7932246,
        size.width * 0.1758945,
        size.height * 0.8007480,
        size.width * 0.1771875,
        size.height * 0.8087324);
    path_10.cubicTo(
        size.width * 0.1857383,
        size.height * 0.8615605,
        size.width * 0.2129238,
        size.height * 0.9099570,
        size.width * 0.2537324,
        size.height * 0.9450098);
    path_10.cubicTo(
        size.width * 0.4002734,
        size.height * 1.070873,
        size.width * 0.6300605,
        size.height * 0.9669844,
        size.width * 0.6300605,
        size.height * 0.7720547);
    path_10.cubicTo(
        size.width * 0.6300645,
        size.height * 0.7021738,
        size.width * 0.5990664,
        size.height * 0.6377949,
        size.width * 0.5447500,
        size.height * 0.5942715);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.4411641, size.height * 0.2143262);
    path_11.cubicTo(
        size.width * 0.4492539,
        size.height * 0.2143262,
        size.width * 0.4558125,
        size.height * 0.2077695,
        size.width * 0.4558125,
        size.height * 0.1996777);
    path_11.lineTo(size.width * 0.4558125, size.height * 0.1459668);
    path_11.cubicTo(
        size.width * 0.4558125,
        size.height * 0.1163828,
        size.width * 0.4317441,
        size.height * 0.09231445,
        size.width * 0.4021602,
        size.height * 0.09231445);
    path_11.cubicTo(
        size.width * 0.3725762,
        size.height * 0.09231445,
        size.width * 0.3485078,
        size.height * 0.1163828,
        size.width * 0.3485078,
        size.height * 0.1459668);
    path_11.lineTo(size.width * 0.3485078, size.height * 0.6368848);
    path_11.cubicTo(
        size.width * 0.2926836,
        size.height * 0.6595371,
        size.width * 0.2566250,
        size.height * 0.7154492,
        size.width * 0.2597598,
        size.height * 0.7764844);
    path_11.cubicTo(
        size.width * 0.2615684,
        size.height * 0.8116797,
        size.width * 0.2764551,
        size.height * 0.8448809,
        size.width * 0.3016758,
        size.height * 0.8699727);
    path_11.cubicTo(
        size.width * 0.3564082,
        size.height * 0.9244277,
        size.width * 0.4444551,
        size.height * 0.9257422,
        size.width * 0.5006055,
        size.height * 0.8721387);
    path_11.cubicTo(
        size.width * 0.5290742,
        size.height * 0.8449629,
        size.width * 0.5447520,
        size.height * 0.8083281,
        size.width * 0.5447520,
        size.height * 0.7689844);
    path_11.cubicTo(
        size.width * 0.5447520,
        size.height * 0.7103652,
        size.width * 0.5094336,
        size.height * 0.6585586,
        size.width * 0.4558125,
        size.height * 0.6368750);
    path_11.lineTo(size.width * 0.4558125, size.height * 0.2683496);
    path_11.cubicTo(
        size.width * 0.4558125,
        size.height * 0.2602598,
        size.width * 0.4492539,
        size.height * 0.2537012,
        size.width * 0.4411641,
        size.height * 0.2537012);
    path_11.cubicTo(
        size.width * 0.4330742,
        size.height * 0.2537012,
        size.width * 0.4265156,
        size.height * 0.2602578,
        size.width * 0.4265156,
        size.height * 0.2683496);
    path_11.lineTo(size.width * 0.4265156, size.height * 0.3166777);
    path_11.lineTo(size.width * 0.3778027, size.height * 0.3166777);
    path_11.lineTo(size.width * 0.3778027, size.height * 0.1459668);
    path_11.cubicTo(
        size.width * 0.3778027,
        size.height * 0.1325371,
        size.width * 0.3887285,
        size.height * 0.1216113,
        size.width * 0.4021602,
        size.height * 0.1216113);
    path_11.cubicTo(
        size.width * 0.4155898,
        size.height * 0.1216113,
        size.width * 0.4265176,
        size.height * 0.1325391,
        size.width * 0.4265176,
        size.height * 0.1459668);
    path_11.lineTo(size.width * 0.4265176, size.height * 0.1996777);
    path_11.cubicTo(
        size.width * 0.4265156,
        size.height * 0.2077695,
        size.width * 0.4330742,
        size.height * 0.2143262,
        size.width * 0.4411641,
        size.height * 0.2143262);
    path_11.close();
    path_11.moveTo(size.width * 0.4265156, size.height * 0.3459746);
    path_11.lineTo(size.width * 0.4265156, size.height * 0.6471465);
    path_11.cubicTo(
        size.width * 0.4265156,
        size.height * 0.6535176,
        size.width * 0.4306328,
        size.height * 0.6591562,
        size.width * 0.4367012,
        size.height * 0.6610977);
    path_11.cubicTo(
        size.width * 0.4838066,
        size.height * 0.6761660,
        size.width * 0.5154551,
        size.height * 0.7195215,
        size.width * 0.5154551,
        size.height * 0.7689844);
    path_11.cubicTo(
        size.width * 0.5154551,
        size.height * 0.8002461,
        size.width * 0.5029961,
        size.height * 0.8293555,
        size.width * 0.4803770,
        size.height * 0.8509473);
    path_11.cubicTo(
        size.width * 0.4099668,
        size.height * 0.9181582,
        size.width * 0.2939102,
        size.height * 0.8702227,
        size.width * 0.2890176,
        size.height * 0.7749805);
    path_11.cubicTo(
        size.width * 0.2863770,
        size.height * 0.7235781,
        size.width * 0.3186992,
        size.height * 0.6767480,
        size.width * 0.3676191,
        size.height * 0.6610996);
    path_11.cubicTo(
        size.width * 0.3736855,
        size.height * 0.6591582,
        size.width * 0.3778047,
        size.height * 0.6535176,
        size.width * 0.3778047,
        size.height * 0.6471484);
    path_11.lineTo(size.width * 0.3778047, size.height * 0.3459746);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
