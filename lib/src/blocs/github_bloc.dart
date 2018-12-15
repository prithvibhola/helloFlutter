import '../resources/repository/github_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/models.dart';

class GithubBloc {
  final gitRepo = GithubRepository();
  final subject = PublishSubject<GithubUserResponse>();

  Observable<GithubUserResponse> get gitUsers => subject.stream;

  getGithubUsers(String query) async {
//    GithubUserResponse itemModel = await gitRepo.getGithubUsers(query);
    subject
        .distinct()
        .debounce(const Duration(milliseconds: 500))
        .switchMap<GithubUserResponse>((String q) => _searchUser(q));
//        .add(itemModel);
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
