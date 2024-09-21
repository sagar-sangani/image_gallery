part of 'photo.dart';

class Photo {
  int id;
  int width;
  int height;
  String url;
  String photographer;
  String photographerUrl;
  String photographerId;
  String avgColor;
  PhotoSrc src;
  bool liked;
  String alt;

  Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      width: map['width'],
      height: map['height'],
      url: map['url'].toString(),
      photographer: map['photographer'].toString(),
      photographerUrl: map['photographer_url'].toString(),
      photographerId: map['photographer_id'].toString(),
      avgColor: map['avg_color'].toString(),
      src: PhotoSrc.fromMap(map['src']),
      liked: map['liked'],
      alt: map['alt'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
      'photographer': photographer,
      'photographer_url': photographerUrl,
      'photographer_id': photographerId,
      'avg_color': avgColor,
      'src': src.toMap(),
      'liked': liked,
      'alt': alt,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PhotoSrc {
  String original;
  String large2x;
  String large;
  String medium;
  String small;
  String portrait;
  String landscape;
  String tiny;

  PhotoSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PhotoSrc.fromMap(Map<String, dynamic> map) {
    return PhotoSrc(
      original: map['original'].toString(),
      large2x: map['large2x'].toString(),
      large: map['large'].toString(),
      medium: map['medium'].toString(),
      small: map['small'].toString(),
      portrait: map['portrait'].toString(),
      landscape: map['landscape'].toString(),
      tiny: map['tiny'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'original': original,
      'large2x': large2x,
      'large': large,
      'medium': medium,
      'small': small,
      'portrait': portrait,
      'landscape': landscape,
      'tiny': tiny,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
