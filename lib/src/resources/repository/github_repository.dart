import 'dart:async';
import '../api.dart';
import '../../models/models.dart';

class GithubRepository {
  final apiProvider = ApiProvider();

  Future<GithubUser> getGithubUsers(String query) =>
      apiProvider.getGithuUsers(query);
}
