import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ClubePharmaLogo extends StatelessWidget {
  final double size;

  const ClubePharmaLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _LogoPainter());
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Desenha o retângulo arredondado (caixa de remédio)
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.2,
        size.width * 0.7,
        size.height * 0.6,
      ),
      Radius.circular(size.width * 0.15),
    );
    canvas.drawRRect(rect, paint);

    // Desenha a cruz branca
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Linha vertical da cruz
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.48,
        size.height * 0.2,
        size.width * 0.04,
        size.height * 0.6,
      ),
      whitePaint,
    );

    // Cruz (símbolo de mais/farmácia) - parte superior
    final path = Path();
    path.moveTo(size.width * 0.35, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.35,
      size.width * 0.38,
      size.height * 0.35,
    );
    path.quadraticBezierTo(
      size.width * 0.40,
      size.height * 0.35,
      size.width * 0.40,
      size.height * 0.37,
    );
    path.quadraticBezierTo(
      size.width * 0.40,
      size.height * 0.35,
      size.width * 0.42,
      size.height * 0.35,
    );
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.35,
      size.width * 0.45,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.5,
      size.width * 0.40,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.5,
      size.width * 0.35,
      size.height * 0.4,
    );
    path.close();

    canvas.drawPath(path, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
