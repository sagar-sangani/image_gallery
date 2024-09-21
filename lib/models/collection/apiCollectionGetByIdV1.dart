part of 'collection.dart';

class ApiCollectionGetByIdV1RequestQuery {
  int page;
  int perPage;
  String type;

  ApiCollectionGetByIdV1RequestQuery({
    this.page = 1,
    this.perPage = 20,
    this.type = 'photos',
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'per_page': perPage,
      'type': type,
    };
  }
}

Future<ApiCollectionGetByIdV1ResponseBody> apiCollectionGetByIdV1({
  required ApiCollectionGetByIdV1RequestQuery query,
  required String collectionId,
}) async {
  final response = await sendRequest.get(
    'collections/$collectionId',
    query: query.toMap(),
  );

  return ApiCollectionGetByIdV1ResponseBody.fromMap(jsonDecode(response.body));
}

class ApiCollectionGetByIdV1ResponseBody {
  String id;
  List<Photo> media;
  int page;
  int perPage;
  int totalResults;

  ApiCollectionGetByIdV1ResponseBody({
    required this.id,
    required this.media,
    required this.page,
    required this.perPage,
    required this.totalResults,
  });

  factory ApiCollectionGetByIdV1ResponseBody.fromMap(Map<String, dynamic> map) {
    return ApiCollectionGetByIdV1ResponseBody(
      id: map['id'],
      media: (map['media'] as List).map((e) => Photo.fromMap(e)).toList(),
      page: map['page'],
      perPage: map['per_page'],
      totalResults: map['total_results'],
    );
  }
}
