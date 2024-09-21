import 'package:http/http.dart' as http;

class NetworkService {
  String baseUrl = 'https://api.pexels.com/v1/';

  Map<String, String> getHeaders() {
    String token = 'Mb8gRTNzvT3L08KJFvrxLhMiSt3TRBBNvqlRZU3HPWnyFrq9E3uYEdvy';

    return {
      // 'Content-Type': 'application/json',
      'Authorization': token,
    };
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      var url = '$baseUrl$path';

      var queryString = '';

      if (query != null) {
        query.forEach((key, value) {
          var index = query.entries.toList().indexWhere((e) => key == e.key);
          if (index != 0) queryString += '&';

          queryString += '$key=$value';
        });

        if (queryString.isNotEmpty) {
          url += '?$queryString';
        }
      }

      var res = await http.get(
        Uri.parse(url),
        headers: getHeaders(),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return res;
      }

      throw res;
    } catch (e) {
      rethrow;
    }
  }
}

NetworkService sendRequest = NetworkService();
