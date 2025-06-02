import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:asset_vantage/src/data/models/preferences/user_preference.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';

import '../data/datasource/local/app_local_datasource.dart';
import '../injector.dart';
import 'api_constants.dart';
import 'unathorised_exception.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  Future<bool> checkNetwork() async {
    final connectivityStatus = await Connectivity().checkConnectivity();
    if(connectivityStatus == ConnectivityResult.none){
      return false;
    }else {
      return true;
    }
  }

  dynamic get(String path, {Map<dynamic, dynamic>? params, bool isReport = false}) async {

    _apiLogs(
      requestMethod: 'GET',
      api: await _getPath(path, params, isReport: isReport),
      headers: await _headers(),
    );

    final response = await _client.get(
      await _getPath(path, params, isReport: isReport),
      headers: await _headers(),
    );

    _apiLogs(
        requestMethod: 'GET',
        api: await _getPath(path, params, isReport: isReport),
        headers: await _headers(),
        statusCode: response.statusCode,
        response: response.body
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if(response.statusCode == 504) {
      throw TimeoutException(response.reasonPhrase);
    }else if(response.statusCode == 403){
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic multipartRequest(String path, {Map<dynamic, dynamic>? params, required Map<String, String> body}) async {

    _apiLogs(
      requestMethod: 'POST',
      api: await _getPath(path, params),
      headers: await _headers(),
      body: body,
    );

    var request = http.MultipartRequest('POST', await _getPath(path, params))
      ..fields.addAll(body);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    _apiLogs(
        statusCode: response.statusCode,
        response: respStr
    );

    if (response.statusCode == 200) {
      return true;
    } else if(response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic download(String path, {String? username, String? password, String? token, String? systemName, String? documentId}) async {

    _apiLogs(
      requestMethod: 'POST',
      api: Uri.parse(path),
      body: {"documents": documentId},
    );

    try{

      var request = http.MultipartRequest('POST', Uri.parse(path))
        ..headers.addAll({
          'Content-Type': 'application/x-www-form-urlencoded',
          'Auth': '$token'
        })..fields.addAll({"documents": documentId ?? ''});
      var response = await request.send();
      final respStr = await response.stream.toBytes();

      _apiLogs(
        requestMethod: 'POST',
        api: Uri.parse(path),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Auth': '$token'
        },
        body: {"documents": '$documentId'},
        statusCode: response.statusCode,
        response: respStr.toString(),
      );

      if (response.statusCode == 200) {
        return respStr;
      } else if(response.statusCode == 204) {
        throw Exception(response.reasonPhrase);
      }
      else if (response.statusCode == 401) {
        throw UnauthorisedException();
      } else {
        throw Exception(response.reasonPhrase);
      }
    }catch(e) {
      log("Exception: $e");
      throw Exception('');
    }
  }

  dynamic postWithDio(String path,{
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) async {


    try {
      final String url = await _getDioPath(path, params);
      final Map<String, dynamic> headers = await _headers();

      _apiLogs(
          requestMethod: 'POST',
          body: body,
          api: Uri.parse(url),
          headers: await _headers(),
      );

      final response = await Dio().post(
        url,
        data: body,
        options: Options(headers: headers),
      );

      _apiLogs(
          requestMethod: 'POST',
          api: Uri.parse(url),
          headers: await _headers(),
          body: body,
          statusCode: response.statusCode,
          response: jsonEncode(response.data)
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if(response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        throw UnauthorisedException();
      } else if(response.statusCode==406){
        return (response.data as Map)..addEntries({'statusCode': response.statusCode}.entries);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print('POST request failed: $e');
      rethrow;
    }
  }

  dynamic post(String path, {Map<dynamic, dynamic>? params, Map<dynamic, dynamic>? body}) async {
    _apiLogs(
      requestMethod: 'POST',
      api: await _getPath(path, params),
      headers: await _headers(),
      body: body,
    );

    final response = await _client.post(
      await _getPath(path, params),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );

    _apiLogs(
      requestMethod: 'POST',
      api: await _getPath(path, params),
      headers: await _headers(),
      body: body,
      statusCode: response.statusCode,
      response: response.body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if(response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else if(response.statusCode==406){
      return (json.decode(response.body) as Map)..addEntries({'statusCode': response.statusCode}.entries);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic put(String path, {Map<dynamic, dynamic>? params, Map<dynamic, dynamic>? body}) async {
    _apiLogs(
      requestMethod: 'PUT',
      api: await _getPath(path, params),
      headers: await _headers(),
      body: body,
    );

    final response = await _client.put(
      await _getPath(path, params),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );

    _apiLogs(
        statusCode: response.statusCode,
        response: response.body
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic delete(String path, {Map<dynamic, dynamic>? params, Map<dynamic, dynamic>? body}) async {
    _apiLogs(
      requestMethod: 'DELETE',
      api: await _getPath(path, params),
      headers: await _headers(),
      body: body,
    );

    final response = await _client.delete(
      await _getPath(path, params),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );

    _apiLogs(
        statusCode: response.statusCode,
        response: response.body
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic uploadFile(String path, {Uint8List? file, Map<dynamic, dynamic>? params, Map<dynamic, dynamic>? body}) async {

    _apiLogs(
      requestMethod: 'GET',
      api: Uri.parse(path),
      headers: await _headers(),
    );

    final response = await _client.put(
      Uri.parse(path),
      headers: await _headers(),
      body: file,
    );

    _apiLogs(
        statusCode: response.statusCode,
        response: response.body
    );

  }


  Future<Uri> _getPath(String path, Map<dynamic, dynamic>? params, {bool isReport = false}) async{

    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();

    var paramsString = '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    if(isReport) {
      return Uri.parse(
          '${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD_REPORTS[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }${paramsString.isNotEmpty ? "?$paramsString" : ""}');
    }else {
      return Uri.parse(
          '${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }$path${paramsString.isNotEmpty ? "?$paramsString" : ""}');
    }
  }

  Future<String> _getDioPath(String path, Map<dynamic, dynamic>? params, {bool isReport = false}) async{

    final dataSource = getItInstance<AppLocalDataSource>();
    final UserPreference preference = await dataSource.getUserPreference();

    var paramsString = '';

    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    if(isReport) {
      return '${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD_REPORTS[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }${paramsString.isNotEmpty ? "?$paramsString" : ""}';
    }else {
      return '${ApiConstants.isProd ? ApiConstants.BASE_URL_PROD[preference.regionUrl ?? 'base_uat'] : ApiConstants.BASE_URL_DEV }$path${paramsString.isNotEmpty ? "?$paramsString" : ""}';
    }
  }

  Future<Map<String, String>> _headers() async{
    final dataSource = getItInstance<AppLocalDataSource>();

    final UserPreference preference = await dataSource.getUserPreference();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',

      if(preference.idToken != null)
        'Authorization': '${preference.idToken}',
    };
  }

  void _apiLogs({String? requestMethod, Uri? api, Map<String, String>? headers, body, int? statusCode, String? response}) {
    if(requestMethod != null) {
      log('METHOD $requestMethod: ${api.toString()}');
    }
    if(headers != null) {
      log('HEADERS: $headers');
    }

    if(body != null)  {
      log('REQUEST_BODY: ${jsonEncode(body)}');
    }

    if(statusCode != null) {
      log('STATUS CODE: $statusCode');
    }

    if(response != null) {
      log('RESPONSE: $response');
    }
  }
}