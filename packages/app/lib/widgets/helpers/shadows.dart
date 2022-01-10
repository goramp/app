import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

const TEXT_SHADOW = <Shadow>[
  Shadow(
    offset: Offset(1.0, 1.0),
    blurRadius: 3.0,
    color: Color.fromARGB(255, 0, 0, 0),
  )
];

const ICON_SHADOW = <Shadow>[
  Shadow(
    offset: Offset(1.0, 1.0),
    blurRadius: 2.0,
    color: Color.fromRGBO(0, 0, 0, 0.45),
  )
];

const ICON_SHADOW2 = <Shadow>[
  Shadow(
    offset: Offset(2.0, 8.0),
    blurRadius: 8.0,
    color: Color.fromRGBO(0, 0, 0, 0.3),
  )
];