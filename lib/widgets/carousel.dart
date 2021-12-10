import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'dart:convert';

class Carousel extends StatefulWidget {
  List<String> items;
  double height;

  Carousel({Key? key, required this.items, required this.height})
      : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List images = [];

  @override
  void initState() {
    super.initState();
    for (var item in widget.items) {
      if (RegExp(r'^base64.*').hasMatch(item)) {
        images.add({
          'image': base64Decode(item.substring(6, item.length)),
          'type': 'base64',
        });
      } else {
        images.add({'image': item, 'type': 'url'});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.white,
      child: CarouselSlider.builder(
          slideBuilder: (index) {
            return renderItem(images[index]);
          },
          slideIndicator: CircularSlideIndicator(
            padding: const EdgeInsets.only(bottom: 64),
            indicatorBackgroundColor:
                Colors.white.withOpacity((images.length > 1) ? .5 : 0),
            currentIndicatorColor:
                Colors.white.withOpacity((images.length > 1) ? 1 : 0),
          ),
          itemCount: images.length),
    );
  }

  Widget renderItem(item) {
    return Stack(children: <Widget>[
      image(item),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  print('tapped');
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return fullScreenImage(item);
                      });
                },
              )))
    ]);
  }

  Widget image(img) {
    return (img['type'] == 'base64')
        ? Image.memory(img['image'],
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: widget.height)
        : Image.network(img['image'],
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: widget.height);
  }

  Widget fullScreenImage(img) {
    return InteractiveViewer(
        panEnabled: false,
        minScale: 1,
        maxScale: 4,
        child: Container(
            color: Colors.black.withOpacity(.5),
            child: Center(
                child: (img['type'] == 'base64')
                    ? Image.memory(
                        img['image'],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Image.network(img['image'],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height))));
  }
}
