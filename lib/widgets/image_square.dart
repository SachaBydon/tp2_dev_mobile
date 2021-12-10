import 'package:flutter/material.dart';
import 'dart:io';

class ImageSquare extends StatefulWidget {
  final List<String> images;
  const ImageSquare({Key? key, required this.images}) : super(key: key);

  @override
  _ImageSquareState createState() => _ImageSquareState();
}

class _ImageSquareState extends State<ImageSquare> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 100,
        child: Column(children: [
          Row(children: [
            img(widget.images[0]),
            img(widget.images.length > 1 ? widget.images[1] : null),
          ]),
          Row(children: [
            img(widget.images.length > 2 ? widget.images[2] : null),
            img(widget.images.length > 3 ? widget.images[3] : null),
          ]),
        ]));
  }

  img(image) {
    if (image == null) {
      return const SizedBox(
        width: 50,
        height: 50,
      );
    }
    return Image.file(
      File(image),
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    );
  }
}
