import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Featurebox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String description;
  const Featurebox({super.key, required this.color, required this.headerText, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              headerText,
              style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const HeightBox(3),
          description.text.fontFamily('Cera Pro').semiBold.make().pOnly(right: 20)
        ],
      ).pOnly(top: 18, bottom: 18,left : 15,right: 12)
    );
  }
}
