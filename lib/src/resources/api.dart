import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/models.dart';

class ApiProvider {
  Client client = Client();

  Future<GithubUserResponse> getGithuUsers(String query) async {
    final response =
        await client.get("https://api.github.com/search/users?q=$query");
    print(response.body.toString());
    if (response.statusCode == 200) {
      return GithubUserResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
