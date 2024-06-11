import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

CarouselOptions carouselOptions = CarouselOptions(
    // aspectRatio: 16 / 9,
    height: 240,
    viewportFraction: 0.85,
    enlargeCenterPage: true,
    scrollPhysics: BouncingScrollPhysics(),
    enlargeFactor: 0.15,
    autoPlay: true,
    autoPlayAnimationDuration: Duration(milliseconds: 750));
