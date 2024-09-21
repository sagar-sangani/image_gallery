part of 'collection.dart';

class Collection {
  String id;
  String title;
  String? description;
  bool private;
  int mediaCount;
  int photosCount;
  int videosCount;

  Collection({
    required this.id,
    required this.title,
    this.description,
    required this.private,
    required this.mediaCount,
    required this.photosCount,
    required this.videosCount,
  });

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'].toString(),
      title: map['title'].toString(),
      description: map['description']?.toString(),
      private: map['private'],
      mediaCount: map['media_count'],
      photosCount: map['photos_count'],
      videosCount: map['videos_count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'private': private,
      'media_count': mediaCount,
      'photos_count': photosCount,
      'videos_count': videosCount,
    };
  }

  @override
  String toString() {
    return toMap.toString();
  }
}
