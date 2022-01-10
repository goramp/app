
import 'package:meta/meta.dart';

import '../models/index.dart';

abstract class UserProfileUpdater {

  void compareAndUpdatePublisher(UserProfile oldProfile, UserProfile newProfile) {
    if (oldProfile != newProfile) {
      doUpdateUserProfile(newProfile);
    }
  }

  @protected
  void doUpdateUserProfile(UserProfile profile);
}