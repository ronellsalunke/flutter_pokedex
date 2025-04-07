import 'dart:convert';
import 'dart:io';

import 'package:flutter_dex/data/app_exceptions.dart';
import 'package:flutter_dex/data/network/base_api_services.dart';
import 'package:http/http.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
      await get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response =
      await post(Uri.parse(url), body: data).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 408:
        throw RequestTimeoutException(response.body.toString());
      case 429:
        throw TooManyRequestsException(response.body.toString());
      default:
        throw FetchDataException(
            "Error occurred while communicating with server, Status code ${response.statusCode}");
    }
  }
}