import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:goramp/utils/index.dart';
import '../app_config.dart';

class SearchResponse {
  List? hits;
  int? page;
  int? nbHits;
  int? nbPages;
  int? hitsPerPage;
  bool? exhaustiveNbHits;

  SearchResponse(
      {this.hits,
      this.page,
      this.nbHits,
      this.nbPages,
      this.hitsPerPage,
      this.exhaustiveNbHits});

  factory SearchResponse.fromMap(Map<String, dynamic> map) {
    return SearchResponse(
      hits: map['hits'] ?? [],
      page: map['page'],
      nbHits: map['nbHits'],
      nbPages: map['nbPages'],
      hitsPerPage: map['hitsPerPage'],
      exhaustiveNbHits: map['exhaustiveNbHits'],
    );
  }
  @override
  String toString() {
    return '$runtimeType('
        'hits: $hits, '
        'page: $page, '
        'nbHits: $nbHits, '
        'nbPages: $nbPages, '
        'hitsPerPage: $hitsPerPage, '
        'exhaustiveNbHits: $exhaustiveNbHits)';
  }
}

class SearchException implements Exception {
  final int? statusCode;
  final String? message;
  final String? code;
  final Object? error;
  SearchException({this.statusCode, this.code, this.message, this.error});

  @override
  String toString() {
    return "[statusCode: $statusCode, code: $code, message: $message]";
  }
}

class SearchService {
  final String baseUrl;
  final AppConfig config;
  final String? apiKey;
  final String? index;

  SearchService({required this.config, this.index, this.apiKey})
      : this.baseUrl =
            'https://${config.agoliaAppId}-dsn.algolia.net/1/indexes/$index/query';

  Future<SearchResponse> search(String? term,
      {int limit = 20, int page = 0, String? filters}) async {
    try {
      String query = encodeMap({
        "query": '$term',
        "hitsPerPage": '$limit',
        "page": '$page',
        "filters": filters,
      });
      var body = json.encode({"params": query});
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
        headers: {
          "X-Algolia-API-Key": apiKey!,
          "X-Algolia-Application-Id": config.agoliaAppId!,
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final results = json.decode(response.body);
        return SearchResponse.fromMap(results);
      } else {
        final Map<String, dynamic> resData = json.decode(response.body);
        throw SearchException(
            statusCode: response.statusCode,
            code: kUnknownError,
            message: resData["errorMessage"]);
      }
    } on ConnectionException catch (error) {
      print('error ${error}');
      throw SearchException(
          code: kConnectionError,
          message: CONNECTION_ERROR_MESSAGE,
          error: error);
    } on SocketException catch (error) {
      print('error ${error}');
      throw SearchException(
          code: kConnectionError,
          message: CONNECTION_ERROR_MESSAGE,
          error: error);
    } on HandshakeException catch (error) {
      print('error ${error}');
      throw SearchException(
          code: kConnectionError,
          message: CONNECTION_ERROR_MESSAGE,
          error: error);
    } on TimeoutException catch (error) {
      print('error ${error}');
      throw SearchException(
          code: kConnectionError,
          message: CONNECTION_ERROR_MESSAGE,
          error: error);
    } catch (error, stacktrace) {
      print('error ${error}');
      throw SearchException(
          code: kUnknownError, message: UKNOWN_ERROR_MESSAGE, error: error);
    }
  }

  String encodeMap(Map data) {
    return data.keys
        .map((key) =>
            "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}")
        .join("&");
  }
}
