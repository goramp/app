import 'package:flutter/material.dart';

abstract class AbstractModel extends ChangeNotifier {
  void notify() => notifyListeners();
}
