import 'dart:async';
import '../api.dart';
import '../../models/models.dart';

class GithubRepository {
  final apiProvider = ApiProvider();

  Future<GithubUserResponse> getGithubUsers(String query) =>
      apiProvider.getGithubUsers(query);
}
