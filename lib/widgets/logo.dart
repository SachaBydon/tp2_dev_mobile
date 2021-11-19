import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  bool small;
  Logo({Key? key, this.small = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shadows = small
        ? [
            Shadow(
                color: Theme.of(context).colorScheme.primary,
                offset: const Offset(1, 1),
                blurRadius: 0)
          ]
        : [
            const Shadow(
                color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
            const Shadow(
                color: Colors.white, offset: Offset(-1, -1), blurRadius: 2),
          ];
    return Center(
      child: Text('MIAGED',
          style: GoogleFonts.kalam(
            fontSize: small ? 25 : 60,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            shadows: shadows,
          )),
    );
  }
}
