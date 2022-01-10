import 'dart:html' as html;

import 'package:js/js.dart';

@JS('window.open')
external Window openWindow(String url, String name, [String? options]);

@JS()
@anonymous
class Window {
  external void postMessage(var message, String targetOrigin,
      [List<html.MessagePort>? messagePorts]);
  external bool closed;
  external void close();
  external void focus();
  external String name;
}
