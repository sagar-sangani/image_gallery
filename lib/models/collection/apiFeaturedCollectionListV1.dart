part of 'collection.dart';

class ApiFeaturedCollectionListV1RequestQuery {
  int page;
  int perPage;
  String type;

  ApiFeaturedCollectionListV1RequestQuery({
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

Future<ApiFeaturedCollectionListV1ResponseBody> apiFeaturedCollectionListV1({
  required ApiFeaturedCollectionListV1RequestQuery query,
}) async {
  final response = await sendRequest.get(
    'collections/featured',
    query: query.toMap(),
  );

  print(response);

  return ApiFeaturedCollectionListV1ResponseBody.fromMap(
      jsonDecode(response.body));
}

class ApiFeaturedCollectionListV1ResponseBody {
  List<Collection> collections;
  int page;
  int perPage;
  int totalResults;

  ApiFeaturedCollectionListV1ResponseBody({
    required this.collections,
    required this.page,
    required this.perPage,
    required this.totalResults,
  });

  factory ApiFeaturedCollectionListV1ResponseBody.fromMap(
      Map<String, dynamic> map) {
    return ApiFeaturedCollectionListV1ResponseBody(
      collections: (map['collections'] as List)
          .map((e) => Collection.fromMap(e))
          .toList(),
      page: map['page'],
      perPage: map['per_page'],
      totalResults: map['total_results'],
    );
  }
}
