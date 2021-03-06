import 'dart:convert';
import 'package:http/http.dart' as http;

class GlobalAPIClient {
  final http.Client httpClient;
  GlobalAPIClient({required this.httpClient});

  static Future<Map> getRequest(String url) async {
    http.Response result = await http.get(
      Uri.parse(url),
      //headers: {"Content-Type": "application/json"},
    );

    return _processResponse(result);
  }

  static Future<Map> postRequest(String url, Map bodyJSON) async {
    http.Response result = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bodyJSON),
    );

    return _processResponse(result);
  }

  /// **********************************************************************
  /// Private functions
  /// **********************************************************************
  static Future<Map> _processResponse(http.Response response) async {
    final body = response.body;
    if (body.isNotEmpty) {
      final jsonBody = json.decode(body);
      return jsonBody;
    } else {
      // ignore: avoid_print
      print("processResponse error");
      return {"error": true};
    }
  }
}
