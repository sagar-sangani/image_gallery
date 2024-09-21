part of 'photo.dart';

class ApiCuratedPhotoListV1RequestQuery {
  int page;
  int perPage;

  ApiCuratedPhotoListV1RequestQuery({
    this.page = 1,
    this.perPage = 20,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'per_page': perPage,
    };
  }
}

Future<ApiCuratedPhotoListV1ResponseBody> apiCuratedPhotoListV1({
  required ApiCuratedPhotoListV1RequestQuery query,
}) async {
  final response = await sendRequest.get(
    'curated',
    query: query.toMap(),
  );

  return ApiCuratedPhotoListV1ResponseBody.fromMap(jsonDecode(response.body));
}

class ApiCuratedPhotoListV1ResponseBody {
  int page;
  int perPage;
  List<Photo> photos;

  ApiCuratedPhotoListV1ResponseBody({
    required this.page,
    required this.perPage,
    required this.photos,
  });

  factory ApiCuratedPhotoListV1ResponseBody.fromMap(Map<String, dynamic> map) {
    return ApiCuratedPhotoListV1ResponseBody(
      page: map['page'],
      perPage: map['per_page'],
      photos: (map['photos'] as List).map((e) => Photo.fromMap(e)).toList(),
    );
  }
}

enum ViewType {
  gallery,
  collection,
}
