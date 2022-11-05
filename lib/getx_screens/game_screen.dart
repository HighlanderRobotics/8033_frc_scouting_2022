import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:get/get.dart';
import '../services/getx_business_logic.dart';
import '../services/size_utils.dart';
import 'dart:ui' as ui show Image;

class GameScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  void move() {
    Get.to(() => PostGameScreen());
  }

  @override
  Widget build(BuildContext context) {
    // c.startGameScreenTimer();

    var size = Size(0, 0).obs;

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: ((context, orientation) {
            return Expanded(
              child: paintWidget(),
            );
          }),
        ),
      ),
    );
  }

  Container paintWidget() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/gameboard_cropped.png'),
          alignment: Alignment.center,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
            ),
            child: Text("HI"),
          )
        ],
      ),
    );
    // return CustomPaint(
    //   foregroundPainter: GameScreenPainter(),
    //   child: Image.asset('assets/gameboard_cropped.png'),
    // );
  }
}

// class GameScreenPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint.color = Colors.red.withOpacity(0.7);

//     _drawFourShape(canvas,
//         left_top: const Offset(209, 122),
//         right_top: const Offset(165, 230),
//         right_bottom: const Offset(165, 375),
//         left_bottom: const Offset(220, 320),
//         middle_bottom: const Offset(230, 245),
//         size: size,
//         paint: paint);
//   }

//   void _drawFourShape(Canvas canvas,
//       {Offset? left_top,
//       Offset? right_top,
//       Offset? right_bottom,
//       Offset? left_bottom,
//       Offset? middle_bottom,
//       Size? size,
//       paint}) {
//     left_top = _convertLogicSize(left_top, size);
//     right_top = _convertLogicSize(right_top, size);
//     right_bottom = _convertLogicSize(right_bottom, size);
//     left_bottom = _convertLogicSize(left_bottom, size);
//     middle_bottom = _convertLogicSize(middle_bottom, size);

//     var path1 = Path()
//       ..moveTo(left_top.dx, left_top.dy)
//       ..lineTo(right_top.dx, right_top.dy)
//       ..lineTo(right_bottom.dx, right_bottom.dy)
//       ..lineTo(left_bottom.dx, left_bottom.dy)
//       ..lineTo(middle_bottom.dx, middle_bottom.dy);

//     canvas.drawPath(path1, paint);
//   }

//   Offset _convertLogicSize(Offset? off, Size? size) {
//     return Offset(SizeUtil.getAxisX(off!.dx), SizeUtil.getAxisY(off.dy));
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
