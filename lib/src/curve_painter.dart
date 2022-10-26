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
          degreesToCoordinates(center!, targetAngle! + 6.5, radius + 22);

      canvas.translate(handler2.dx, handler2.dy);
      canvas.rotate((targetAngle! * math.pi / 180) + (3 * math.pi / 2));
      TargetPainter().paint(canvas, Size(75, 75));
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
class TargetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xfffd646f).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5134375, size.height * 0.5665625),
        size.width * 0.3150000, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.1984375, size.height * 0.5665625);
    path_1.cubicTo(
        size.width * 0.1984375,
        size.height * 0.3925977,
        size.width * 0.3394727,
        size.height * 0.2515625,
        size.width * 0.5134375,
        size.height * 0.2515625);
    path_1.cubicTo(
        size.width * 0.6078320,
        size.height * 0.2515625,
        size.width * 0.6925586,
        size.height * 0.2931055,
        size.width * 0.7502734,
        size.height * 0.3589062);
    path_1.cubicTo(
        size.width * 0.6948242,
        size.height * 0.3102344,
        size.width * 0.6221484,
        size.height * 0.2807422,
        size.width * 0.5425977,
        size.height * 0.2807422);
    path_1.cubicTo(
        size.width * 0.3686328,
        size.height * 0.2807422,
        size.width * 0.2275977,
        size.height * 0.4217773,
        size.width * 0.2275977,
        size.height * 0.5957422);
    path_1.cubicTo(
        size.width * 0.2275977,
        size.height * 0.6752930,
        size.width * 0.2571094,
        size.height * 0.7479687,
        size.width * 0.3057617,
        size.height * 0.8034180);
    path_1.cubicTo(
        size.width * 0.2399609,
        size.height * 0.7457031,
        size.width * 0.1984180,
        size.height * 0.6609766,
        size.width * 0.1984180,
        size.height * 0.5665820);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xfffc4755).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xfff5f5f5).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5134375, size.height * 0.5665625),
        size.width * 0.2377148, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.2757227, size.height * 0.5665625);
    path_3.cubicTo(
        size.width * 0.2757227,
        size.height * 0.4352734,
        size.width * 0.3821484,
        size.height * 0.3288477,
        size.width * 0.5134375,
        size.height * 0.3288477);
    path_3.cubicTo(
        size.width * 0.5865039,
        size.height * 0.3288477,
        size.width * 0.6518555,
        size.height * 0.3618164,
        size.width * 0.6954883,
        size.height * 0.4136719);
    path_3.cubicTo(
        size.width * 0.6541602,
        size.height * 0.3789258,
        size.width * 0.6008203,
        size.height * 0.3580078,
        size.width * 0.5426172,
        size.height * 0.3580078);
    path_3.cubicTo(
        size.width * 0.4113281,
        size.height * 0.3580078,
        size.width * 0.3049023,
        size.height * 0.4644336,
        size.width * 0.3049023,
        size.height * 0.5957227);
    path_3.cubicTo(
        size.width * 0.3049023,
        size.height * 0.6539453,
        size.width * 0.3258203,
        size.height * 0.7072656,
        size.width * 0.3605664,
        size.height * 0.7485937);
    path_3.cubicTo(
        size.width * 0.3087109,
        size.height * 0.7049805,
        size.width * 0.2757422,
        size.height * 0.6396094,
        size.width * 0.2757422,
        size.height * 0.5665430);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffe6e6e6).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xfffd646f).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5134375, size.height * 0.5665625),
        size.width * 0.1604102, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3530078, size.height * 0.5665625);
    path_5.cubicTo(
        size.width * 0.3530078,
        size.height * 0.4779687,
        size.width * 0.4248242,
        size.height * 0.4061523,
        size.width * 0.5134180,
        size.height * 0.4061523);
    path_5.cubicTo(
        size.width * 0.5651367,
        size.height * 0.4061523,
        size.width * 0.6111719,
        size.height * 0.4306445,
        size.width * 0.6405078,
        size.height * 0.4686523);
    path_5.cubicTo(
        size.width * 0.6134180,
        size.height * 0.4477344,
        size.width * 0.5794531,
        size.height * 0.4353125,
        size.width * 0.5425977,
        size.height * 0.4353125);
    path_5.cubicTo(
        size.width * 0.4540039,
        size.height * 0.4353125,
        size.width * 0.3821875,
        size.height * 0.5071289,
        size.width * 0.3821875,
        size.height * 0.5957227);
    path_5.cubicTo(
        size.width * 0.3821875,
        size.height * 0.6325977,
        size.width * 0.3946094,
        size.height * 0.6665625,
        size.width * 0.4155273,
        size.height * 0.6936328);
    path_5.cubicTo(
        size.width * 0.3775000,
        size.height * 0.6642969,
        size.width * 0.3530273,
        size.height * 0.6182813,
        size.width * 0.3530273,
        size.height * 0.5665430);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xfffc4755).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xfff5f5f5).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5134375, size.height * 0.5665625),
        size.width * 0.08166016, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.2153906, size.height * 0.4643555);
    path_7.cubicTo(
        size.width * 0.2216016,
        size.height * 0.4462500,
        size.width * 0.2294141,
        size.height * 0.4288867,
        size.width * 0.2386523,
        size.height * 0.4124609);
    path_7.lineTo(size.width * 0.3089648, size.height * 0.4452539);
    path_7.cubicTo(
        size.width * 0.2993164,
        size.height * 0.4614453,
        size.width * 0.2915625,
        size.height * 0.4788867,
        size.width * 0.2859766,
        size.height * 0.4972656);
    path_7.lineTo(size.width * 0.2153711, size.height * 0.4643555);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xfffc4755).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.2859961, size.height * 0.4972656);
    path_8.cubicTo(
        size.width * 0.2915820,
        size.height * 0.4788672,
        size.width * 0.2993359,
        size.height * 0.4614258,
        size.width * 0.3089844,
        size.height * 0.4452539);
    path_8.lineTo(size.width * 0.3795898, size.height * 0.4781641);
    path_8.cubicTo(
        size.width * 0.3691797,
        size.height * 0.4938672,
        size.width * 0.3614844,
        size.height * 0.5115039,
        size.width * 0.3571289,
        size.height * 0.5304297);
    path_8.lineTo(size.width * 0.2859961, size.height * 0.4972656);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffe6e6e6).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.3571094, size.height * 0.5304297);
    path_9.cubicTo(
        size.width * 0.3614648,
        size.height * 0.5115039,
        size.width * 0.3691602,
        size.height * 0.4938672,
        size.width * 0.3795703,
        size.height * 0.4781641);
    path_9.lineTo(size.width * 0.4525195, size.height * 0.5121680);
    path_9.cubicTo(
        size.width * 0.4398828,
        size.height * 0.5263086,
        size.width * 0.4321094,
        size.height * 0.5448828,
        size.width * 0.4317773,
        size.height * 0.5652539);
    path_9.lineTo(size.width * 0.3571094, size.height * 0.5304297);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xfffc4755).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.4317773, size.height * 0.5652539);
    path_10.cubicTo(
        size.width * 0.4320898,
        size.height * 0.5448828,
        size.width * 0.4398828,
        size.height * 0.5263086,
        size.width * 0.4525195,
        size.height * 0.5121680);
    path_10.lineTo(size.width * 0.5208398, size.height * 0.5440234);
    path_10.cubicTo(
        size.width * 0.5341992,
        size.height * 0.5502344,
        size.width * 0.5404492,
        size.height * 0.5655273,
        size.width * 0.5356641,
        size.height * 0.5791406);
    path_10.cubicTo(
        size.width * 0.5353516,
        size.height * 0.5800391,
        size.width * 0.5350000,
        size.height * 0.5809180,
        size.width * 0.5345898,
        size.height * 0.5818164);
    path_10.cubicTo(
        size.width * 0.5312695,
        size.height * 0.5889258,
        size.width * 0.5253906,
        size.height * 0.5940234,
        size.width * 0.5185352,
        size.height * 0.5965234);
    path_10.cubicTo(
        size.width * 0.5117187,
        size.height * 0.5990039,
        size.width * 0.5039062,
        size.height * 0.5989063,
        size.width * 0.4967969,
        size.height * 0.5955664);
    path_10.lineTo(size.width * 0.4317773, size.height * 0.5652539);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xffe6e6e6).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.1092188, size.height * 0.8416602);
    path_11.cubicTo(
        size.width * 0.1068750,
        size.height * 0.8412695,
        size.width * 0.1059570,
        size.height * 0.8383984,
        size.width * 0.1076367,
        size.height * 0.8367188);
    path_11.lineTo(size.width * 0.1384961, size.height * 0.8057227);
    path_11.lineTo(size.width * 0.1574219, size.height * 0.7866992);
    path_11.lineTo(size.width * 0.2091406, size.height * 0.7347461);
    path_11.cubicTo(
        size.width * 0.2124609,
        size.height * 0.7314063,
        size.width * 0.2171875,
        size.height * 0.7298828,
        size.width * 0.2218555,
        size.height * 0.7306445);
    path_11.lineTo(size.width * 0.2990039, size.height * 0.7433594);
    path_11.lineTo(size.width * 0.2412305, size.height * 0.8006641);
    path_11.lineTo(size.width * 0.2220898, size.height * 0.8196484);
    path_11.lineTo(size.width * 0.1868750, size.height * 0.8545898);
    path_11.lineTo(size.width * 0.1092578, size.height * 0.8416406);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xff50758d).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.1384766, size.height * 0.8057422);
    path_12.lineTo(size.width * 0.1574023, size.height * 0.7867188);
    path_12.lineTo(size.width * 0.2411914, size.height * 0.8006836);
    path_12.lineTo(size.width * 0.2220508, size.height * 0.8196680);
    path_12.lineTo(size.width * 0.1384766, size.height * 0.8057227);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xff2b597f).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.2237695, size.height * 0.8883008);
    path_13.lineTo(size.width * 0.2588086, size.height * 0.8540234);
    path_13.lineTo(size.width * 0.2778711, size.height * 0.8353711);
    path_13.lineTo(size.width * 0.3354492, size.height * 0.7790430);
    path_13.lineTo(size.width * 0.3483008, size.height * 0.8571875);
    path_13.cubicTo(
        size.width * 0.3490625,
        size.height * 0.8618164,
        size.width * 0.3475391,
        size.height * 0.8665430,
        size.width * 0.3442187,
        size.height * 0.8698633);
    path_13.lineTo(size.width * 0.2922852, size.height * 0.9218555);
    path_13.lineTo(size.width * 0.2732812, size.height * 0.9408789);
    path_13.lineTo(size.width * 0.2418359, size.height * 0.9723438);
    path_13.cubicTo(
        size.width * 0.2401562,
        size.height * 0.9740234,
        size.width * 0.2372656,
        size.height * 0.9730859,
        size.width * 0.2368945,
        size.height * 0.9707422);
    path_13.lineTo(size.width * 0.2237500, size.height * 0.8883203);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xff50758d).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.2588086, size.height * 0.8540039);
    path_14.lineTo(size.width * 0.2778711, size.height * 0.8353516);
    path_14.lineTo(size.width * 0.2922852, size.height * 0.9218164);
    path_14.lineTo(size.width * 0.2732812, size.height * 0.9408398);
    path_14.lineTo(size.width * 0.2588086, size.height * 0.8540039);
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Color(0xff2b597f).withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.1570898, size.height * 0.8930078);
    path_15.cubicTo(
        size.width * 0.1570898,
        size.height * 0.8857422,
        size.width * 0.1598633,
        size.height * 0.8784570,
        size.width * 0.1654102,
        size.height * 0.8729102);
    path_15.lineTo(size.width * 0.4887109, size.height * 0.5496094);
    path_15.cubicTo(
        size.width * 0.4991211,
        size.height * 0.5391797,
        size.width * 0.5156250,
        size.height * 0.5385352,
        size.width * 0.5267969,
        size.height * 0.5476758);
    path_15.cubicTo(
        size.width * 0.5275195,
        size.height * 0.5482812,
        size.width * 0.5282422,
        size.height * 0.5489062,
        size.width * 0.5289258,
        size.height * 0.5496094);
    path_15.cubicTo(
        size.width * 0.5344727,
        size.height * 0.5551562,
        size.width * 0.5372461,
        size.height * 0.5624219,
        size.width * 0.5372461,
        size.height * 0.5697266);
    path_15.cubicTo(
        size.width * 0.5372461,
        size.height * 0.5770312,
        size.width * 0.5344727,
        size.height * 0.5842773,
        size.width * 0.5289258,
        size.height * 0.5898242);
    path_15.lineTo(size.width * 0.2056250, size.height * 0.9131250);
    path_15.cubicTo(
        size.width * 0.1945312,
        size.height * 0.9242383,
        size.width * 0.1765234,
        size.height * 0.9242383,
        size.width * 0.1654102,
        size.height * 0.9131250);
    path_15.cubicTo(
        size.width * 0.1647266,
        size.height * 0.9124414,
        size.width * 0.1640820,
        size.height * 0.9117187,
        size.width * 0.1634766,
        size.height * 0.9109961);
    path_15.cubicTo(
        size.width * 0.1591992,
        size.height * 0.9057812,
        size.width * 0.1570703,
        size.height * 0.8993945,
        size.width * 0.1570703,
        size.height * 0.8930078);
    path_15.lineTo(size.width * 0.1570703, size.height * 0.8930078);
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xff918291).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.1570898, size.height * 0.8930078);
    path_16.cubicTo(
        size.width * 0.1570898,
        size.height * 0.8857422,
        size.width * 0.1598633,
        size.height * 0.8784570,
        size.width * 0.1654102,
        size.height * 0.8729102);
    path_16.lineTo(size.width * 0.4887109, size.height * 0.5496094);
    path_16.cubicTo(
        size.width * 0.4991211,
        size.height * 0.5391797,
        size.width * 0.5156250,
        size.height * 0.5385352,
        size.width * 0.5267969,
        size.height * 0.5476758);
    path_16.lineTo(size.width * 0.1634961, size.height * 0.9109961);
    path_16.cubicTo(
        size.width * 0.1592187,
        size.height * 0.9057812,
        size.width * 0.1570898,
        size.height * 0.8993945,
        size.width * 0.1570898,
        size.height * 0.8930078);
    path_16.lineTo(size.width * 0.1570898, size.height * 0.8930078);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xff7a6e79).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.2144336, size.height * 0.7185156);
    path_17.cubicTo(
        size.width * 0.2115430,
        size.height * 0.7185156,
        size.width * 0.2087500,
        size.height * 0.7196484,
        size.width * 0.2066797,
        size.height * 0.7217383);
    path_17.lineTo(size.width * 0.09589844, size.height * 0.8330273);
    path_17.cubicTo(
        size.width * 0.09300781,
        size.height * 0.8359375,
        size.width * 0.09199219,
        size.height * 0.8401953,
        size.width * 0.09324219,
        size.height * 0.8441016);
    path_17.cubicTo(
        size.width * 0.09449219,
        size.height * 0.8479883,
        size.width * 0.09781250,
        size.height * 0.8508594,
        size.width * 0.1018555,
        size.height * 0.8515430);
    path_17.lineTo(size.width * 0.1614063, size.height * 0.8614844);
    path_17.lineTo(size.width * 0.1576953, size.height * 0.8651953);
    path_17.cubicTo(
        size.width * 0.1423437,
        size.height * 0.8805469,
        size.width * 0.1423437,
        size.height * 0.9055273,
        size.width * 0.1576953,
        size.height * 0.9208789);
    path_17.cubicTo(
        size.width * 0.1730469,
        size.height * 0.9362305,
        size.width * 0.1980273,
        size.height * 0.9362305,
        size.width * 0.2133789,
        size.height * 0.9208789);
    path_17.lineTo(size.width * 0.2172656, size.height * 0.9169922);
    path_17.lineTo(size.width * 0.2270117, size.height * 0.9781055);
    path_17.cubicTo(
        size.width * 0.2276562,
        size.height * 0.9821680,
        size.width * 0.2305273,
        size.height * 0.9855273,
        size.width * 0.2344336,
        size.height * 0.9867773);
    path_17.cubicTo(
        size.width * 0.2383398,
        size.height * 0.9880469,
        size.width * 0.2426367,
        size.height * 0.9870117,
        size.width * 0.2455469,
        size.height * 0.9841016);
    path_17.lineTo(size.width * 0.3572656, size.height * 0.8722852);
    path_17.cubicTo(
        size.width * 0.3597461,
        size.height * 0.8697852,
        size.width * 0.3608984,
        size.height * 0.8662500,
        size.width * 0.3603125,
        size.height * 0.8627734);
    path_17.lineTo(size.width * 0.3587891, size.height * 0.8535547);
    path_17.cubicTo(
        size.width * 0.4061133,
        size.height * 0.8791016,
        size.width * 0.4591211,
        size.height * 0.8925195,
        size.width * 0.5134375,
        size.height * 0.8925195);
    path_17.cubicTo(
        size.width * 0.5766797,
        size.height * 0.8925195,
        size.width * 0.6380078,
        size.height * 0.8743945,
        size.width * 0.6908008,
        size.height * 0.8400781);
    path_17.cubicTo(
        size.width * 0.6958594,
        size.height * 0.8367773,
        size.width * 0.6973047,
        size.height * 0.8300195,
        size.width * 0.6940039,
        size.height * 0.8249414);
    path_17.cubicTo(
        size.width * 0.6919141,
        size.height * 0.8217187,
        size.width * 0.6883984,
        size.height * 0.8199609,
        size.width * 0.6848242,
        size.height * 0.8199609);
    path_17.cubicTo(
        size.width * 0.6827734,
        size.height * 0.8199609,
        size.width * 0.6807227,
        size.height * 0.8205273,
        size.width * 0.6788672,
        size.height * 0.8217187);
    path_17.cubicTo(
        size.width * 0.6296289,
        size.height * 0.8537109,
        size.width * 0.5724219,
        size.height * 0.8706250,
        size.width * 0.5134375,
        size.height * 0.8706250);
    path_17.cubicTo(
        size.width * 0.4544531,
        size.height * 0.8706250,
        size.width * 0.4020117,
        size.height * 0.8550781,
        size.width * 0.3541992,
        size.height * 0.8256445);
    path_17.lineTo(size.width * 0.3477539, size.height * 0.7864648);
    path_17.lineTo(size.width * 0.3668164, size.height * 0.7674023);
    path_17.cubicTo(
        size.width * 0.4095508,
        size.height * 0.7987109,
        size.width * 0.4600195,
        size.height * 0.8152148,
        size.width * 0.5134375,
        size.height * 0.8152148);
    path_17.cubicTo(
        size.width * 0.6505469,
        size.height * 0.8152148,
        size.width * 0.7620898,
        size.height * 0.7036719,
        size.width * 0.7620898,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.7620898,
        size.height * 0.4294531,
        size.width * 0.6505469,
        size.height * 0.3179102,
        size.width * 0.5134375,
        size.height * 0.3179102);
    path_17.cubicTo(
        size.width * 0.3763281,
        size.height * 0.3179102,
        size.width * 0.2647852,
        size.height * 0.4294531,
        size.width * 0.2647852,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.2647852,
        size.height * 0.5689062,
        size.width * 0.2648242,
        size.height * 0.5712500,
        size.width * 0.2648828,
        size.height * 0.5735742);
    path_17.cubicTo(
        size.width * 0.2650391,
        size.height * 0.5796094,
        size.width * 0.2700391,
        size.height * 0.5843750,
        size.width * 0.2761133,
        size.height * 0.5841992);
    path_17.cubicTo(
        size.width * 0.2821484,
        size.height * 0.5840430,
        size.width * 0.2869141,
        size.height * 0.5790039,
        size.width * 0.2867383,
        size.height * 0.5729687);
    path_17.cubicTo(
        size.width * 0.2866797,
        size.height * 0.5708398,
        size.width * 0.2866406,
        size.height * 0.5686914,
        size.width * 0.2866406,
        size.height * 0.5665430);
    path_17.cubicTo(
        size.width * 0.2866406,
        size.height * 0.4415039,
        size.width * 0.3883789,
        size.height * 0.3397656,
        size.width * 0.5134180,
        size.height * 0.3397656);
    path_17.cubicTo(
        size.width * 0.6384570,
        size.height * 0.3397656,
        size.width * 0.7401953,
        size.height * 0.4415039,
        size.width * 0.7401953,
        size.height * 0.5665430);
    path_17.cubicTo(
        size.width * 0.7401953,
        size.height * 0.6915820,
        size.width * 0.6384570,
        size.height * 0.7933203,
        size.width * 0.5134180,
        size.height * 0.7933203);
    path_17.cubicTo(
        size.width * 0.4658594,
        size.height * 0.7933203,
        size.width * 0.4208398,
        size.height * 0.7789648,
        size.width * 0.3824805,
        size.height * 0.7517187);
    path_17.lineTo(size.width * 0.4224414, size.height * 0.7117578);
    path_17.cubicTo(
        size.width * 0.4496875,
        size.height * 0.7288867,
        size.width * 0.4809375,
        size.height * 0.7379102,
        size.width * 0.5134180,
        size.height * 0.7379102);
    path_17.cubicTo(
        size.width * 0.6079102,
        size.height * 0.7379102,
        size.width * 0.6847656,
        size.height * 0.6610352,
        size.width * 0.6847656,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.6847656,
        size.height * 0.5552344,
        size.width * 0.6836523,
        size.height * 0.5438867,
        size.width * 0.6814453,
        size.height * 0.5328711);
    path_17.cubicTo(
        size.width * 0.6788086,
        size.height * 0.5188672,
        size.width * 0.6570313,
        size.height * 0.5233203,
        size.width * 0.6600000,
        size.height * 0.5371484);
    path_17.cubicTo(
        size.width * 0.6619141,
        size.height * 0.5467578,
        size.width * 0.6628906,
        size.height * 0.5566602,
        size.width * 0.6628906,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.6628906,
        size.height * 0.6489844,
        size.width * 0.5958398,
        size.height * 0.7160352,
        size.width * 0.5134180,
        size.height * 0.7160352);
    path_17.cubicTo(
        size.width * 0.4867773,
        size.height * 0.7160352,
        size.width * 0.4610938,
        size.height * 0.7090820,
        size.width * 0.4383594,
        size.height * 0.6958398);
    path_17.lineTo(size.width * 0.4809375, size.height * 0.6532617);
    path_17.cubicTo(
        size.width * 0.4912891,
        size.height * 0.6571484,
        size.width * 0.5021875,
        size.height * 0.6591602,
        size.width * 0.5134180,
        size.height * 0.6591602);
    path_17.cubicTo(
        size.width * 0.5644727,
        size.height * 0.6591602,
        size.width * 0.6060156,
        size.height * 0.6176172,
        size.width * 0.6060156,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.6060156,
        size.height * 0.5155078,
        size.width * 0.5644727,
        size.height * 0.4739648,
        size.width * 0.5134180,
        size.height * 0.4739648);
    path_17.cubicTo(
        size.width * 0.4623633,
        size.height * 0.4739648,
        size.width * 0.4208203,
        size.height * 0.5155078,
        size.width * 0.4208203,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.4208203,
        size.height * 0.5770117,
        size.width * 0.4225586,
        size.height * 0.5871875,
        size.width * 0.4259375,
        size.height * 0.5969141);
    path_17.lineTo(size.width * 0.3830859, size.height * 0.6397656);
    path_17.cubicTo(
        size.width * 0.3705469,
        size.height * 0.6175000,
        size.width * 0.3639453,
        size.height * 0.5924219,
        size.width * 0.3639453,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.3639453,
        size.height * 0.4841406,
        size.width * 0.4309961,
        size.height * 0.4170898,
        size.width * 0.5134180,
        size.height * 0.4170898);
    path_17.cubicTo(
        size.width * 0.5676562,
        size.height * 0.4170898,
        size.width * 0.6176563,
        size.height * 0.4462305,
        size.width * 0.6438672,
        size.height * 0.4931641);
    path_17.cubicTo(
        size.width * 0.6468164,
        size.height * 0.4984375,
        size.width * 0.6534766,
        size.height * 0.5003320,
        size.width * 0.6587500,
        size.height * 0.4973828);
    path_17.cubicTo(
        size.width * 0.6640234,
        size.height * 0.4944336,
        size.width * 0.6659180,
        size.height * 0.4877734,
        size.width * 0.6629688,
        size.height * 0.4825000);
    path_17.cubicTo(
        size.width * 0.6328906,
        size.height * 0.4286719,
        size.width * 0.5755859,
        size.height * 0.3952344,
        size.width * 0.5134180,
        size.height * 0.3952344);
    path_17.cubicTo(
        size.width * 0.4189258,
        size.height * 0.3952344,
        size.width * 0.3420703,
        size.height * 0.4721094,
        size.width * 0.3420703,
        size.height * 0.5665820);
    path_17.cubicTo(
        size.width * 0.3420703,
        size.height * 0.5982812,
        size.width * 0.3507227,
        size.height * 0.6289453,
        size.width * 0.3671094,
        size.height * 0.6557617);
    path_17.lineTo(size.width * 0.3270508, size.height * 0.6958203);
    path_17.cubicTo(
        size.width * 0.3110352,
        size.height * 0.6728125,
        size.width * 0.2995898,
        size.height * 0.6473828,
        size.width * 0.2929883,
        size.height * 0.6200586);
    path_17.cubicTo(
        size.width * 0.2917773,
        size.height * 0.6150586,
        size.width * 0.2873047,
        size.height * 0.6116797,
        size.width * 0.2823633,
        size.height * 0.6116797);
    path_17.cubicTo(
        size.width * 0.2815039,
        size.height * 0.6116797,
        size.width * 0.2806445,
        size.height * 0.6117773,
        size.width * 0.2797852,
        size.height * 0.6119922);
    path_17.cubicTo(
        size.width * 0.2739063,
        size.height * 0.6134180,
        size.width * 0.2703125,
        size.height * 0.6193164,
        size.width * 0.2717188,
        size.height * 0.6251953);
    path_17.cubicTo(
        size.width * 0.2792773,
        size.height * 0.6564453,
        size.width * 0.2925977,
        size.height * 0.6854297,
        size.width * 0.3113672,
        size.height * 0.7115039);
    path_17.lineTo(size.width * 0.2917578, size.height * 0.7311133);
    path_17.lineTo(size.width * 0.2537500, size.height * 0.7248633);
    path_17.cubicTo(
        size.width * 0.2246875,
        size.height * 0.6772852,
        size.width * 0.2093555,
        size.height * 0.6226758,
        size.width * 0.2093555,
        size.height * 0.5665820);
    path_17.cubicTo(
        size.width * 0.2093555,
        size.height * 0.3989258,
        size.width * 0.3457617,
        size.height * 0.2625195,
        size.width * 0.5134180,
        size.height * 0.2625195);
    path_17.cubicTo(
        size.width * 0.6810742,
        size.height * 0.2625195,
        size.width * 0.8174805,
        size.height * 0.3989258,
        size.width * 0.8174805,
        size.height * 0.5665820);
    path_17.cubicTo(
        size.width * 0.8174805,
        size.height * 0.6525977,
        size.width * 0.7808008,
        size.height * 0.7349805,
        size.width * 0.7168359,
        size.height * 0.7925977);
    path_17.cubicTo(
        size.width * 0.7123438,
        size.height * 0.7966406,
        size.width * 0.7119922,
        size.height * 0.8035547,
        size.width * 0.7160352,
        size.height * 0.8080469);
    path_17.cubicTo(
        size.width * 0.7200781,
        size.height * 0.8125391,
        size.width * 0.7269922,
        size.height * 0.8128906,
        size.width * 0.7314844,
        size.height * 0.8088477);
    path_17.cubicTo(
        size.width * 0.8000391,
        size.height * 0.7470898,
        size.width * 0.8393750,
        size.height * 0.6587891,
        size.width * 0.8393750,
        size.height * 0.5665820);
    path_17.cubicTo(
        size.width * 0.8393750,
        size.height * 0.4795117,
        size.width * 0.8054688,
        size.height * 0.3976758,
        size.width * 0.7439063,
        size.height * 0.3361133);
    path_17.cubicTo(
        size.width * 0.6823438,
        size.height * 0.2745508,
        size.width * 0.6004883,
        size.height * 0.2406445,
        size.width * 0.5134375,
        size.height * 0.2406445);
    path_17.cubicTo(
        size.width * 0.4263867,
        size.height * 0.2406445,
        size.width * 0.3445313,
        size.height * 0.2745508,
        size.width * 0.2829688,
        size.height * 0.3361133);
    path_17.cubicTo(
        size.width * 0.2214063,
        size.height * 0.3976758,
        size.width * 0.1875000,
        size.height * 0.4795312,
        size.width * 0.1875000,
        size.height * 0.5665820);
    path_17.cubicTo(
        size.width * 0.1875000,
        size.height * 0.6205273,
        size.width * 0.2007422,
        size.height * 0.6731836,
        size.width * 0.2259570,
        size.height * 0.7202734);
    path_17.lineTo(size.width * 0.2162109, size.height * 0.7186719);
    path_17.cubicTo(
        size.width * 0.2156250,
        size.height * 0.7185742,
        size.width * 0.2150195,
        size.height * 0.7185352,
        size.width * 0.2144336,
        size.height * 0.7185352);
    path_17.lineTo(size.width * 0.2144336, size.height * 0.7185352);
    path_17.close();
    path_17.moveTo(size.width * 0.1263477, size.height * 0.8334375);
    path_17.lineTo(size.width * 0.1517187, size.height * 0.8079492);
    path_17.lineTo(size.width * 0.2058789, size.height * 0.8169727);
    path_17.lineTo(size.width * 0.1804102, size.height * 0.8424414);
    path_17.lineTo(size.width * 0.1263477, size.height * 0.8334180);
    path_17.close();
    path_17.moveTo(size.width * 0.1979102, size.height * 0.9053906);
    path_17.cubicTo(
        size.width * 0.1944922,
        size.height * 0.9088086,
        size.width * 0.1900195,
        size.height * 0.9105078,
        size.width * 0.1855469,
        size.height * 0.9105078);
    path_17.cubicTo(
        size.width * 0.1810742,
        size.height * 0.9105078,
        size.width * 0.1765820,
        size.height * 0.9088086,
        size.width * 0.1731641,
        size.height * 0.9053906);
    path_17.cubicTo(
        size.width * 0.1663477,
        size.height * 0.8985742,
        size.width * 0.1663477,
        size.height * 0.8874609,
        size.width * 0.1731641,
        size.height * 0.8806445);
    path_17.lineTo(size.width * 0.4964648, size.height * 0.5573438);
    path_17.cubicTo(
        size.width * 0.5032813,
        size.height * 0.5505273,
        size.width * 0.5143945,
        size.height * 0.5505273,
        size.width * 0.5212109,
        size.height * 0.5573438);
    path_17.cubicTo(
        size.width * 0.5280273,
        size.height * 0.5641602,
        size.width * 0.5280273,
        size.height * 0.5752734,
        size.width * 0.5212109,
        size.height * 0.5820898);
    path_17.lineTo(size.width * 0.1979102, size.height * 0.9053906);
    path_17.close();
    path_17.moveTo(size.width * 0.2452344, size.height * 0.9534570);
    path_17.lineTo(size.width * 0.2363672, size.height * 0.8978711);
    path_17.lineTo(size.width * 0.2618750, size.height * 0.8723633);
    path_17.lineTo(size.width * 0.2710742, size.height * 0.9275781);
    path_17.lineTo(size.width * 0.2452344, size.height * 0.9534570);
    path_17.close();
    path_17.moveTo(size.width * 0.3378125, size.height * 0.8607813);
    path_17.lineTo(size.width * 0.2900781, size.height * 0.9085547);
    path_17.lineTo(size.width * 0.2808789, size.height * 0.8533398);
    path_17.lineTo(size.width * 0.3287109, size.height * 0.8055078);
    path_17.lineTo(size.width * 0.3378125, size.height * 0.8607813);
    path_17.close();
    path_17.moveTo(size.width * 0.4427148, size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.4427148,
        size.height * 0.5275586,
        size.width * 0.4744531,
        size.height * 0.4958398,
        size.width * 0.5134375,
        size.height * 0.4958398);
    path_17.cubicTo(
        size.width * 0.5524219,
        size.height * 0.4958398,
        size.width * 0.5841602,
        size.height * 0.5275781,
        size.width * 0.5841602,
        size.height * 0.5665625);
    path_17.cubicTo(
        size.width * 0.5841602,
        size.height * 0.6055469,
        size.width * 0.5524219,
        size.height * 0.6372852,
        size.width * 0.5134375,
        size.height * 0.6372852);
    path_17.cubicTo(
        size.width * 0.5083594,
        size.height * 0.6372852,
        size.width * 0.5033789,
        size.height * 0.6367383,
        size.width * 0.4985156,
        size.height * 0.6357031);
    path_17.lineTo(size.width * 0.5366797, size.height * 0.5975391);
    path_17.cubicTo(
        size.width * 0.5520313,
        size.height * 0.5821875,
        size.width * 0.5520313,
        size.height * 0.5572070,
        size.width * 0.5366797,
        size.height * 0.5418555);
    path_17.cubicTo(
        size.width * 0.5290039,
        size.height * 0.5341797,
        size.width * 0.5189258,
        size.height * 0.5303320,
        size.width * 0.5088281,
        size.height * 0.5303320);
    path_17.cubicTo(
        size.width * 0.4987305,
        size.height * 0.5303320,
        size.width * 0.4886523,
        size.height * 0.5341797,
        size.width * 0.4809766,
        size.height * 0.5418555);
    path_17.lineTo(size.width * 0.4438086, size.height * 0.5790234);
    path_17.cubicTo(
        size.width * 0.4430859,
        size.height * 0.5749414,
        size.width * 0.4426953,
        size.height * 0.5707813,
        size.width * 0.4426953,
        size.height * 0.5665430);
    path_17.close();
    path_17.moveTo(size.width * 0.2727344, size.height * 0.7501367);
    path_17.lineTo(size.width * 0.2249023, size.height * 0.7979688);
    path_17.lineTo(size.width * 0.1706641, size.height * 0.7889258);
    path_17.lineTo(size.width * 0.2182227, size.height * 0.7411523);
    path_17.lineTo(size.width * 0.2727344, size.height * 0.7501172);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.5134375, size.height * 0.006992188);
    path_18.lineTo(size.width * 0.4193164, size.height * 0.1952148);
    path_18.lineTo(size.width * 0.6075391, size.height * 0.1952148);
    path_18.lineTo(size.width * 0.5134375, size.height * 0.006992188);
    path_18.close();

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Color.fromARGB(255, 57, 209, 55).withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);
    Paint paint_18_stroke = Paint()..style = PaintingStyle.stroke;
    paint_18_stroke.strokeWidth = 2.0;
    paint_18_fill.color = Colors.black;
    canvas.drawPath(path_18, paint_18_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
