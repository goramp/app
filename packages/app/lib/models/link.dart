import 'package:equatable/equatable.dart';

enum LinkResourceType { event, invite, schedule }

class Link extends Equatable {
  Link({
    this.id,
    this.userId,
    this.resourceId,
    this.resourceType,
  });

  final String? id;
  final String? userId;
  final String? resourceId;
  final LinkResourceType? resourceType;

  List<Object?> get props => [id, userId, resourceId, resourceType];

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
      id: map['id'],
      userId: map['userId'],
      resourceId: map['resourceId'],
      resourceType: stringToLinkResourceType(map['resourceType']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'resourceId': resourceId,
      'resourceType': stringFromLinkResourceType(resourceType),
    };
  }

  static LinkResourceType stringToLinkResourceType(String? resourceType) {
    switch (resourceType) {
      case 'event':
        return LinkResourceType.event;
      case 'invite':
        return LinkResourceType.invite;
      case 'schedule':
        return LinkResourceType.schedule;
    }
    throw StateError("Inalid resourceType");
  }

  static String stringFromLinkResourceType(LinkResourceType? mode) {
    switch (mode) {
      case LinkResourceType.event:
        return 'event';
      case LinkResourceType.invite:
        return 'invite';
      case LinkResourceType.schedule:
        return 'schedule';
    }
    throw StateError("Inalid link resourceType");
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
