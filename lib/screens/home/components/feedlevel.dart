import 'package:flutter/material.dart';

class FeedLevelContainer extends StatelessWidget {
  final double feedLevel; // 0 to 100 (e.g., percentage of feed)

  FeedLevelContainer({required this.feedLevel});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 300), // Set the size of the container
      painter: FeedLevelContainerPainter(feedLevel: feedLevel),
    );
  }
}

class FeedLevelContainerPainter extends CustomPainter {
  final double feedLevel;

  FeedLevelContainerPainter({required this.feedLevel});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [Colors.red, Colors.orange, Colors.yellow.withOpacity(0.5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    // Draw the container (a funnel-like shape)
    Path path = Path()
      ..moveTo(size.width / 2, 0) // Top middle point
      ..lineTo(size.width * 0.8, size.height * 0.8) // Right side
      ..lineTo(size.width * 0.2, size.height * 0.8) // Left side
      ..close();

    // Draw the funnel shape
    canvas.drawPath(path, paint);

    // Draw the feed level inside the container
    Paint levelPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.6);

    // Define the height of the feed fill based on the feedLevel (percentage)
    double fillHeight = (size.height * 0.8) * (feedLevel / 100);

    // Adjust the shape to fill the feed level
    Path levelPath = Path()
      ..moveTo(size.width / 2, size.height * 0.2) // Starting point (bottom part of the container)
      ..lineTo(size.width * 0.8, size.height * 0.8 - fillHeight)
      ..lineTo(size.width * 0.2, size.height * 0.8 - fillHeight)
      ..close();

    // Draw the fill inside the funnel
    canvas.drawPath(levelPath, levelPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint unless feed level changes
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("Feed Level Container")),
      body: Center(
        child: FeedLevelContainer(feedLevel: 60), // Example with 60% feed level
      ),
    ),
  ));
}
