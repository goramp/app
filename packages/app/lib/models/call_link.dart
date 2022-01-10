import 'availability.dart';
import 'package:equatable/equatable.dart';
import 'video_thumb.dart';
import 'video.dart';
import '../utils/index.dart';

class CallLinkPayment extends Equatable {
  final BigInt? price;
  final int? decimals;
  final String? currency;
  final String? paymentProviderId;
  final String? paymentTerms;

  const CallLinkPayment(
      {this.price,
      this.decimals,
      this.currency,
      this.paymentProviderId,
      this.paymentTerms});

  List get props =>
      [price, currency, paymentProviderId, paymentTerms, decimals];

  CallLinkPayment copyWith(
      {BigInt? price,
      int? decimals,
      String? currency,
      String? paymentProviderId,
      String? paymentTerms}) {
    return CallLinkPayment(
      decimals: decimals ?? this.decimals,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      paymentProviderId: paymentProviderId ?? this.paymentProviderId,
      paymentTerms: paymentTerms ?? this.paymentTerms,
    );
  }
}

class CallLinkPost extends Equatable {
  final CallLink? callLink;
  final List<Availability> availabilities;
  final String? uploadSessionKey;

  CallLinkPost(this.callLink, this.availabilities, {this.uploadSessionKey});

  List<Object?> get props => [callLink, availabilities, uploadSessionKey];

  @override
  String toString() {
    return '$runtimeType('
        'callLink: $callLink, '
        'availabilities: $availabilities, ';
  }

  factory CallLinkPost.fromMap(Map<String, dynamic> map) {
    final eventID = map['eventId'];
    CallLink? event;
    if (map['event'] != null) {
      final eventMap = asStringKeyedMap(map['event'])!;
      eventMap['id'] = eventID;
      event = CallLink.fromMap(eventMap);
    }
    final availabilities = (map['availabilities'] as List<dynamic>)
        .map((dynamic availability) => Availability.fromMap(
            asStringKeyedMap(availability as Map<String, dynamic>)!))
        .toList();
    return CallLinkPost(event, availabilities);
  }

  Map<String, dynamic> toMap() {
    return {
      'callLinkId': callLink?.id,
      'callLink': callLink!.toMap(),
      'availabilities': availabilities
          .map<Map<String, dynamic>>(
              (Availability availability) => availability.toMap())
          .toList(),
      'uploadSessionKey': uploadSessionKey,
    };
  }
}

enum EventType { group, oneOnOne }

enum PublisherType { individual, team }

class CallLink extends Equatable {
  CallLink({
    this.id,
    this.title,
    this.video,
    this.updatedAt,
    this.createdAt,
    this.hostId,
    this.hostUsername,
    this.hostName,
    this.ownerName,
    this.hostImageUrl,
    this.duration,
    this.localVideoThumbnail,
    this.startDate,
    this.price,
    this.currency,
    this.endDate,
    this.type = EventType.oneOnOne,
    this.ownerType = PublisherType.individual,
    this.active,
    this.subscriptionEnabled = true,
    this.linkId,
    this.timezone,
    this.schedulesCount = 0,
    this.notes,
    this.paymentProviderId,
    this.paymentTerms,
    this.published,
    this.enabled,
    this.likedByUserId,
    this.decimals,
    this.hostVerified,
    this.visible,
  });

  List<Object?> get props => [
        id,
        title,
        video,
        updatedAt,
        createdAt,
        hostId,
        hostUsername,
        ownerName,
        hostImageUrl,
        duration,
        localVideoThumbnail,
        startDate,
        price,
        type,
        ownerType,
        active,
        subscriptionEnabled,
        linkId,
        timezone,
        schedulesCount,
        notes,
        paymentProviderId,
        paymentTerms,
        published,
        enabled,
        likedByUserId,
        decimals,
        hostVerified,
        visible
      ];

  final String? id;
  final String? title;
  final String? notes;
  final String? paymentTerms;
  final bool? published;
  final bool? enabled;
  final Duration? duration;
  final VideoThumb? localVideoThumbnail;
  final String? price;
  final int? decimals;
  final String? currency;
  final int? schedulesCount;
  final Video? video;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final EventType? type;
  final PublisherType? ownerType;
  final String? hostId;
  final String? hostUsername;
  final String? hostName;
  final bool? hostVerified;
  final String? ownerName;
  final String? hostImageUrl;
  final bool? active;
  final bool? visible;
  final bool? subscriptionEnabled;
  final String? linkId;
  final String? timezone;
  final String? paymentProviderId;
  final String? likedByUserId;

  static String stringFromEventType(EventType type) {
    switch (type) {
      case EventType.group:
        return 'group';
      case EventType.oneOnOne:
        return 'one-on-one';
    }
  }

  static EventType stringToEventType(String? type) {
    switch (type) {
      case 'group':
        return EventType.group;
      case 'one-on-one':
        return EventType.oneOnOne;
    }
    throw StateError("Inalid type");
  }

  static String stringFromPublisherType(PublisherType type) {
    switch (type) {
      case PublisherType.individual:
        return 'individual';
      case PublisherType.team:
        return 'team';
    }
  }

  static PublisherType stringToPublisherType(String? type) {
    switch (type) {
      case 'individual':
        return PublisherType.individual;
      case 'team':
        return PublisherType.team;
    }
    throw StateError("Inalid type");
  }

  static DateTime beginOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 59, 59, 999);
  }

  bool get isSingleDay =>
      beginOfDay(startDate!).isAtSameMomentAs(beginOfDay(endDate!));

  bool isInRange(DateTime date) {
    final start = DateTime(startDate!.year, startDate!.month, startDate!.day);
    final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
    final current = DateTime(date.year, date.month, date.day);
    return ((current.isAfter(start) || current.isAtSameMomentAs(start)) &&
        (current.isBefore(end) || current.isAtSameMomentAs(end)));
  }

  bool isPast() {
    final now = DateTime.now();
    return now.isAfter(endDate!);
  }

  bool isAvailable(DateTime date) {
    if (isSingleDay) {
      return date.isBefore(startDate!) || date.isAtSameMomentAs(startDate!);
    }
    return date.isAtSameMomentAs(startDate!) ||
        (date.isAfter(startDate!) && date.isBefore(endDate!)) ||
        (startDate!.isAfter(date) && date.isBefore(endDate!));
  }

  BigInt get priceInt =>
      price != null ? BigInt.tryParse(price!) ?? BigInt.zero : BigInt.zero;
  BigInt get total => priceInt * BigInt.from(duration!.inMinutes);

  bool get isFree => priceInt == BigInt.zero;

  CallLink copyWith({
    String? id,
    String? title,
    VideoThumb? localVideoThumbnail,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? hostId,
    String? hostUsername,
    String? ownerName,
    String? hostImageUrl,
    Duration? duration,
    Video? video,
    DateTime? startDate,
    String? price,
    String? currency,
    DateTime? endDate,
    VideoAsset? localVideo,
    EventType? type,
    PublisherType? ownerType,
    bool? active,
    bool? subscriptionEnabled,
    String? linkId,
    String? timezone,
    int? schedulesCount,
    String? notes,
    String? paymentProviderId,
    String? paymentTerms,
    bool? enabled,
    bool? published,
    String? likedByUserId,
    String? hostName,
    int? decimals,
    bool? hostVerified,
    bool? visible,
  }) {
    return CallLink(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      hostId: hostId ?? this.hostId,
      hostUsername: hostUsername ?? this.hostUsername,
      ownerName: ownerName ?? this.ownerName,
      hostImageUrl: hostImageUrl ?? this.hostImageUrl,
      video: video ?? this.video,
      localVideoThumbnail: localVideoThumbnail ?? this.localVideoThumbnail,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      ownerType: ownerType ?? this.ownerType,
      active: active ?? this.active,
      subscriptionEnabled: subscriptionEnabled ?? this.subscriptionEnabled,
      linkId: linkId ?? this.linkId,
      timezone: timezone ?? this.timezone,
      schedulesCount: schedulesCount ?? this.schedulesCount,
      notes: notes ?? this.notes,
      paymentProviderId: paymentProviderId ?? this.paymentProviderId,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      enabled: enabled ?? this.enabled,
      published: published ?? this.published,
      likedByUserId: likedByUserId ?? this.likedByUserId,
      hostName: hostName ?? this.hostName,
      decimals: decimals ?? this.decimals,
      hostVerified: hostVerified ?? this.hostVerified,
      visible: visible ?? this.visible,
    );
  }

  factory CallLink.fromMap(Map<String, dynamic> map) {
    return CallLink(
      id: map['id'],
      title: map['title'],
      duration:
          map['duration'] != null ? Duration(minutes: map['duration']) : null,
      price: map['price']?.toString(),
      currency: map['currency'],
      hostId: map['hostId'],
      hostUsername: map['hostUsername'],
      hostName: map['hostName'],
      ownerName: map['ownerName'],
      hostImageUrl: map['hostImageUrl'],
      ownerType: map['ownerType'] != null
          ? stringToPublisherType(map['ownerType'])
          : null,
      type: map['type'] != null ? stringToEventType(map['type']) : null,
      video: map['video'] != null
          ? Video.fromMap(map['video'].cast<String, dynamic>())
          : null,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      startDate: parseDate(map['startDate']),
      endDate: parseDate(map['endDate']),
      localVideoThumbnail: null,
      active: map['active'],
      subscriptionEnabled: map['subscriptionEnabled'],
      linkId: map['linkId'],
      timezone: map['timezone'],
      schedulesCount: map['schedulesCount'],
      notes: map['notes'],
      paymentProviderId: map['paymentProviderId'],
      paymentTerms: map['paymentTerms'],
      published: map['published'],
      enabled: map['enabled'],
      likedByUserId: map['likedByUserId'],
      decimals: map['decimals'],
      hostVerified: map['hostVerified'],
      visible: map['visible'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'currency': currency,
      'video': video?.toMap(),
      'duration': duration!.inMinutes,
      'hostId': hostId,
      'hostUsername': hostUsername,
      'hostName': hostName,
      'ownerName': ownerName,
      'hostImageUrl': hostImageUrl,
      //'ownerType': stringFromPublisherType(ownerType),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      //'type': stringFromEventType(type),
      'active': active ?? false,
      'subscriptionEnabled': subscriptionEnabled,
      'linkId': linkId,
      'timezone': timezone,
      'notes': notes,
      'paymentProviderId': paymentProviderId,
      'paymentTerms': paymentTerms,
      'published': published,
      'enabled': enabled,
      'likedByUserId': likedByUserId,
      'decimals': decimals,
      'hostVerified': hostVerified,
      'visible': visible,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'title': title,
      'price': price,
      'duration': duration!.inMinutes,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'subscriptionEnabled': subscriptionEnabled,
      'active': active ?? false,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
