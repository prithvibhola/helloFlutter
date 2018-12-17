import '../resources/repository/github_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/models.dart';

class GithubBloc {
  final gitRepo = GithubRepository();
  final subject = PublishSubject<String>();

  Observable<GithubUserResponse> get gitUsers => subject.stream;

  getGithubUsers(String query) async {
//    GithubUserResponse itemModel = await gitRepo.getGithubUsers(query);
//    subject.sink.add(itemModel);

    if (!subject.hasListener) searchGitUser();
    subject.add(query);
  }

  searchGitUser() {
    subject
        .distinct()
        .debounce(const Duration(milliseconds: 500))
        .switchMap<GithubUserResponse>((String query) => _searchUser(query))
        .listen((x) => print("Next: $x"),
            onError: (e, s) => print("Error: $e"),
            onDone: () => print("Completed"));
  }

  Stream<GithubUserResponse> _searchUser(String query) async* {
    GithubUserResponse itemModel = await gitRepo.getGithubUsers(query);
    yield itemModel;
  }

  dispose() {
    subject.close();
  }
}

final bloc = GithubBloc();
