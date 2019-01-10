import '../resources/repository/github_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/models.dart';

class GithubBloc {
  final gitRepo = GithubRepository();

  final subject = PublishSubject<String>();
  final githubUserSubject = PublishSubject<Response<GithubUserResponse>>();

  Stream<Response<GithubUserResponse>> get gitUser => githubUserSubject.stream;

  getGithubUsers(String query) async {
    if (query.trim() == "") {
      githubUserSubject.add(Response.success(null));
      return;
    }
    githubUserSubject.add(Response.loading());
    if (!subject.hasListener) searchGitUser();
    subject.add(query);
  }

  searchGitUser() {
    subject
        .distinct()
        .debounce(const Duration(milliseconds: 500))
        .switchMap<GithubUserResponse>((String query) => _searchUser(query))
        .listen((x) => githubUserSubject.add(Response.success(x)),
            onError: (e, s) => githubUserSubject.add(Response.error(e)));
  }

  Stream<GithubUserResponse> _searchUser(String query) async* {
    GithubUserResponse itemModel = await gitRepo.getGithubUsers(query);
    yield itemModel;
  }

  dispose() {
    subject.close();
    githubUserSubject.close();
  }
}

final bloc = GithubBloc();
