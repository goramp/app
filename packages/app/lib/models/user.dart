import 'package:collection/collection.dart' show IterableExtension;
import 'package:goramp/utils/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'photo.dart';

class UserWithProfile extends Equatable {
  const UserWithProfile({
    required this.user,
    required this.profile,
  });

  List<Object?> get props => [
        user,
        profile,
      ];

  final User user;
  final UserProfile profile;

  bool get  profileComplete => !user.isPendingSignup && profile.hasUsername;

}

class UserSession extends Equatable {
  final String? lastCountry;
  final String? lastIpAddress;
  final DateTime? lastLoggedInAt;
  final String? lastSessionId;

  const UserSession({
    this.lastCountry,
    this.lastIpAddress,
    this.lastLoggedInAt,
    this.lastSessionId,
  });

  List<Object?> get props => [
        lastCountry,
        lastIpAddress,
        lastLoggedInAt,
        lastSessionId,
      ];

  factory UserSession.fromMap(Map<String, dynamic> map) {
    return UserSession(
      lastCountry: map['lastCountry'],
      lastIpAddress: map['lastIpAddress'],
      lastSessionId: map['lastSessionId'],
      lastLoggedInAt: parseDate(map['lastLoggedInAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastCountry': lastCountry,
      'lastIpAddress': lastIpAddress,
      'lastSessionId': lastSessionId,
      'lastLoggedInAt': lastLoggedInAt?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class UserKYC extends Equatable {
  final String? country;
  final bool? verified;

  const UserKYC({
    required this.country,
    required this.verified,
  });

  List<Object?> get props => [
        country,
        verified,
      ];

  factory UserKYC.fromMap(Map<String, dynamic> map) {
    return UserKYC(
      country: map['country'],
      verified: map['verified'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'verified': verified,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class UserProfileUpdate extends Equatable {
  final String? name;
  final String? username;
  final bool? hideLikes;
  final String? bio;
  final XFile? image;
  final bool? removePhoto;

  const UserProfileUpdate({
    this.name,
    this.username,
    this.bio,
    this.image,
    this.removePhoto,
    this.hideLikes,
  });

  List<Object?> get props => [
        name,
        username,
        bio,
        image,
        removePhoto,
        hideLikes,
      ];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'bio': bio,
      'removePhoto': removePhoto,
      'hideLikes': hideLikes,
    };
  }
}

class UserProfile extends Equatable {
  final String? name;
  final String? username;
  final String? uid;
  final String? bio;
  final Photo? banner;
  final String? photoUrl;
  final String? photoDisplayUrl;
  final String? photoId;
  final String? photoBlurHash;
  final String? stripeId;
  final bool? photoEnabled;
  final bool kycVerified;
  final bool hideLikes;

  const UserProfile({
    required this.uid,
    this.bio,
    this.username,
    this.banner,
    this.name,
    this.photoUrl,
    this.photoEnabled,
    this.photoId,
    this.photoDisplayUrl,
    this.photoBlurHash,
    this.stripeId,
    this.hideLikes = true,
    this.kycVerified = false,
  });

  List<Object?> get props => [
        uid,
        bio,
        name,
        username,
        photoUrl,
        photoBlurHash,
        banner,
        photoEnabled,
        photoId,
        photoDisplayUrl,
        stripeId,
        hideLikes,
        kycVerified,
      ];

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      bio: map['bio'],
      name: map['name'],
      username: map['username'],
      photoUrl: map['photoUrl'],
      photoDisplayUrl: map['photoDisplayUrl'],
      photoEnabled: map['photoEnabled'],
      photoBlurHash: map['photoBlurHash'],
      photoId: map['photoId'],
      stripeId: map['stripeId'],
      hideLikes: map['hideLikes'] ?? true,
      kycVerified: map['kycVerified'] ?? false,
      banner: map['banner'] != null
          ? Photo.fromMap(map['banner'].cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'bio': bio,
      'username': username,
      'name': name,
      'photoUrl': photoUrl,
      'photoDisplayUrl': photoDisplayUrl,
      'photoEnabled': photoEnabled,
      'photoId': photoId,
      'photoBlurHash': photoBlurHash,
      'banner': banner?.toMap(),
      'hideLikes': hideLikes,
      'kycVerified': kycVerified,
    };
  }

  bool get hasUsername => username != null && username!.isNotEmpty;

  @override
  String toString() {
    return '${toMap()}';
  }
}

class User extends Equatable {
  User(
      {required this.id,
      this.name,
      this.image,
      this.token,
      this.phoneNumber,
      this.email,
      this.isAnonymous = false,
      this.emailVerified});

  User.fromFirebaseUser(auth.User fbUser)
      : isAnonymous = fbUser.isAnonymous,
        id = fbUser.uid,
        phoneNumber = fbUser.phoneNumber,
        email = fbUser.email ??
            (fbUser.providerData
                .firstWhereOrNull((info) => info.email != null)
                ?.email),
        image = fbUser.photoURL != null
            ? Photo(
                original: ImageItem(url: fbUser.photoURL),
                thumbnail: ImageItem(url: fbUser.photoURL))
            : null,
        name = fbUser.displayName,
        token = null,
        emailVerified = fbUser.emailVerified;

  User.fromFirebaseMap(Map<String, dynamic> map)
      : isAnonymous = map['isAnonymous'] ?? false,
        id = map['uid'],
        phoneNumber = map['phoneNumber'],
        email = map['email'] ??
            ((map['providerData'] as List?)?.map<String?>((info) {
              final mapInfo = asStringKeyedMap(info);
              return mapInfo?['email'] as String?;
            }).firstWhereOrNull((email) => email != null)),
        image = map['photoURL'] != null
            ? Photo(
                original: ImageItem(url: map['photoURL']),
                thumbnail: ImageItem(url: map['photoURL']))
            : null,
        name = map['displayName'],
        token = null,
        emailVerified = map['emailVerified'];

  final bool isAnonymous;
  final String? id;
  final String? token;
  final String? phoneNumber;
  final String? email;
  final bool? emailVerified;
  final Photo? image;
  final String? name;

  List<Object?> get props => [
        id,
        name,
        image,
        token,
        phoneNumber,
        email,
        isAnonymous,
        emailVerified,
      ];

  User public() {
    return User(
      id: this.id,
      name: this.name,
      image: this.image,
    );
  }

  String? get displayName => name;

  bool get isPendingSignup =>
      (!isAnonymous && (displayName == null || displayName!.isEmpty));

  User copyFromMap(Map<String, dynamic> map) {
    User u = User.fromMap(map);
    return this.copyFromUser(u);
  }

  User copyFromUser(User u) {
    return User(
      id: u.id ?? this.id,
      token: u.token ?? this.token,
      phoneNumber: u.phoneNumber ?? this.phoneNumber,
      email: u.email ?? this.email,
      name: u.name ?? this.name,
      image: u.image ?? this.image,
      isAnonymous: u.isAnonymous,
      emailVerified: u.emailVerified,
    );
  }

  User copyWith({
    String? id,
    String? token,
    String? phoneNumber,
    String? email,
    String? username,
    Photo? image,
    String? name,
    String? publicAddress,
    String? privateKey,
    bool? emailVerified,
  }) {
    return User(
      id: id ?? this.id,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      isAnonymous: isAnonymous,
      emailVerified: emailVerified,
    );
  }

  User copy(User u) {
    return User(
      id: u.id ?? this.id,
      token: u.token ?? this.token,
      phoneNumber: u.phoneNumber ?? this.phoneNumber,
      email: u.email ?? this.email,
      name: u.name ?? this.name,
      image: u.image ?? this.image,
      isAnonymous: u.isAnonymous,
      emailVerified: u.emailVerified,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      token: map['token'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      name: map['name'],
      isAnonymous: map['isAnonymous'] ?? false,
      emailVerified: map['emailVerified'] ?? false,
      image: map['image'] != null
          ? Photo.fromMap(map['image'].cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'token': token,
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'isAnonymous': isAnonymous,
      'emailVerified': emailVerified,
      'image': image?.toMap(),
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class UserPaymentProvider extends Equatable {
  final String? providerId;
  final String? providerName;
  final String? apiKey;
  final String? address;
  final String? webhookSecret;
  final String? email;
  final String? stripeAccountId;
  final Map<String, dynamic>? customData;
  final bool? connected;
  final DateTime? connectedAt;
  final DateTime? disconnectedAt;
  final String? defaultCurrency;
  final String? businessName;
  final String? supportEmail;

  const UserPaymentProvider({
    required this.providerId,
    this.providerName,
    this.customData,
    this.apiKey,
    this.webhookSecret,
    this.stripeAccountId,
    this.email,
    this.connected,
    this.connectedAt,
    this.disconnectedAt,
    this.defaultCurrency,
    this.businessName,
    this.supportEmail,
    this.address,
  });

  List<Object?> get props => [
        providerId,
        providerName,
        customData,
        email,
        apiKey,
        webhookSecret,
        stripeAccountId,
        connected,
        connectedAt,
        disconnectedAt,
        defaultCurrency,
        businessName,
        supportEmail,
        address
      ];

  factory UserPaymentProvider.fromMap(Map<String, dynamic> map) {
    return UserPaymentProvider(
      providerId: map['providerId'],
      providerName: map['providerName'],
      apiKey: map['apiKey'],
      webhookSecret: map['webhookSecret'],
      stripeAccountId: map['stripeAccountId'],
      email: map['email'],
      customData: map['customData'],
      connected: map['connected'],
      connectedAt: parseDate(map['connectedAt']),
      disconnectedAt: parseDate(map['disconnectedAt']),
      defaultCurrency: map['defaultCurrency'],
      businessName: map['businessName'],
      supportEmail: map['supportEmail'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'providerName': providerName,
      'customData': customData,
      'apiKey': apiKey,
      'webhookSecret': webhookSecret,
      'stripeAccountId': stripeAccountId,
      'email': email,
      'connected': connected,
      'connectedAt': connectedAt?.millisecondsSinceEpoch,
      'disconnectedAt': disconnectedAt?.millisecondsSinceEpoch,
      'defaultCurrency': defaultCurrency,
      'businessName': businessName,
      'supportEmail': supportEmail,
      'address': address
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
