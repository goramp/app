export 'interface.dart';
export 'unsupported.dart'
    if (dart.library.html) 'html.dart'
    if (dart.library.io) 'native.dart';